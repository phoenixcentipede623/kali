// web/app.js

const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;

// MySQL connection
const connection = mysql.createConnection({
  host: 'db',
  user: 'root',
  password: 'root',
  database: 'induction'
});

connection.connect();

app.use(express.urlencoded({ extended: true }));

// Simple login route
app.post('/login', (req, res) => {
  const { userid, password } = req.body;
  connection.query('SELECT * FROM users WHERE roll_number = ? AND password = ?', [userid, password], (err, results) => {
    if (err) throw err;
    if (results.length > 0) {
      const user = results[0];
      res.redirect(`/${user.role}/${user.roll_number}`);
    } else {
      res.send('Invalid credentials');
    }
  });
});

// Route for core
app.get('/core/:roll_number', (req, res) => {
  connection.query('SELECT * FROM users', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Route for mentors
app.get('/mentor/:roll_number', (req, res) => {
  const roll_number = req.params.roll_number;
  connection.query('SELECT * FROM users WHERE mentor = ?', [roll_number], (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Route for mentees
app.get('/mentee/:roll_number', (req, res) => {
  const roll_number = req.params.roll_number;
  connection.query('SELECT * FROM users WHERE roll_number = ?', [roll_number], (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
