from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Database connection
def get_db_connection():
    conn = mysql.connector.connect(
        host='db',
        user='user',
        password='password',
        database='userdb'
    )
    return conn

@app.route('/')
def index():
    if 'userid' in session:
        userid = session['userid']
        role = get_user_role(userid)
        if role == 'core':
            return redirect(url_for('core'))
        elif role == 'mentor':
            return redirect(url_for('mentor'))
        elif role == 'mentee':
            return redirect(url_for('mentee'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        userid = request.form['userid']
        password = request.form['password']
        if authenticate_user(userid, password):
            session['userid'] = userid
            return redirect(url_for('index'))
        return 'Invalid credentials'
    return render_template('login.html')

def authenticate_user(userid, password):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users WHERE userid = %s AND password = %s', (userid, password))
    user = cur.fetchone()
    cur.close()
    conn.close()
    return user

def get_user_role(userid):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT role FROM users WHERE userid = %s', (userid,))
    role = cur.fetchone()[0]
    cur.close()
    conn.close()
    return role

@app.route('/core')
def core():
    if 'userid' in session and get_user_role(session['userid']) == 'core':
        user_details = get_all_user_details()
        return render_template('core.html', user_details=user_details)
    return redirect(url_for('login'))

@app.route('/mentor')
def mentor():
    if 'userid' in session and get_user_role(session['userid']) == 'mentor':
        userid = session['userid']
        mentees = get_mentees(userid)
        details = {mentee: get_user_details(mentee) for mentee in mentees}
        return render_template('mentor.html', user_details=details)
    return redirect(url_for('login'))

@app.route('/mentee')
def mentee():
    if 'userid' in session and get_user_role(session['userid']) == 'mentee':
        userid = session['userid']
        details = {userid: get_user_details(userid)}
        return render_template('mentee.html', user_details=details)
    return redirect(url_for('login'))

def get_all_user_details():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users')
    users = cur.fetchall()
    cur.close()
    conn.close()
    return {user[0]: {'name': user[1], 'email': user[2]} for user in users}

def get_mentees(mentor_id):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT mentee_id FROM mentor_mentees WHERE mentor_id = %s', (mentor_id,))
    mentees = cur.fetchall()
    cur.close()
    conn.close()
    return [mentee[0] for mentee in mentees]

def get_user_details(userid):
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('SELECT * FROM users WHERE userid = %s', (userid,))
    user = cur.fetchone()
    cur.close()
    conn.close()
    return {'name': user[1], 'email': user[2]}

@app.route('/logout')
def logout():
    session.pop('userid', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)
