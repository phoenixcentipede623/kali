import mysql.connector

conn = mysql.connector.connect(
    host='localhost',
    user='user',
    password='password',
    database='userdb'
)

cur = conn.cursor()
cur.execute('''
CREATE TABLE IF NOT EXISTS users (
    userid VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255)
)
''')
cur.execute('''
CREATE TABLE IF NOT EXISTS mentor_mentees (
    mentor_id VARCHAR(255),
    mentee_id VARCHAR(255),
    FOREIGN KEY (mentor_id) REFERENCES users (userid),
    FOREIGN KEY (mentee_id) REFERENCES users (userid)
)
''')

# Insert dummy data
cur.execute('''
INSERT INTO users (userid, name, email, password, role) VALUES
('core_user', 'Core User', 'core@example.com', 'core_pass', 'core'),
('mentor_user', 'Mentor User', 'mentor@example.com', 'mentor_pass', 'mentor'),
('mentee_user', 'Mentee User', 'mentee@example.com', 'mentee_pass', 'mentee')
ON DUPLICATE KEY UPDATE
    name=VALUES(name), email=VALUES(email), password=VALUES(password), role=VALUES(role)
''')
cur.execute('''
INSERT INTO mentor_mentees (mentor_id, mentee_id) VALUES
('mentor_user', 'mentee_user')
ON DUPLICATE KEY UPDATE
    mentor_id=VALUES(mentor_id), mentee_id=VALUES(mentee_id)
''')

conn.commit()
cur.close()
conn.close()
