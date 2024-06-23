-- db/init.sql

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role ENUM('core', 'mentor', 'mentee') NOT NULL,
    password VARCHAR(100) NOT NULL
);

CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(50) NOT NULL,
    domain VARCHAR(50) NOT NULL,
    task_name VARCHAR(50) NOT NULL,
    status ENUM('submitted', 'not_submitted') NOT NULL
);
