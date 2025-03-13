CREATE DATABASE IF NOT EXISTS eco_track;
USE eco_track;

-- User Table
CREATE TABLE IF NOT EXISTS user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    password VARCHAR(45) NOT NULL,
    address VARCHAR(45),
    date_joined VARCHAR(45),
    email VARCHAR(45) UNIQUE NOT NULL,
    role TINYINT(1) NOT NULL,
    points INT DEFAULT 0
);

-- Eco-friendly Activities Table
CREATE TABLE IF NOT EXISTS eco_friendly_activities (
    activity_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(45) NOT NULL,
    description LONGTEXT,
    location VARCHAR(100),
    participants_count INT DEFAULT 0,
    date VARCHAR(45) NOT NULL,
    organizer_id INT NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES user(id) ON DELETE CASCADE
);

-- Environmental Issues Table
CREATE TABLE IF NOT EXISTS environmental_issues (
    issue_id INT AUTO_INCREMENT PRIMARY KEY,
    status TINYINT NOT NULL,
    location VARCHAR(100),
    reporter_id INT NOT NULL,
    title VARCHAR(45),
    description LONGTEXT,
    category VARCHAR(45),
    FOREIGN KEY (reporter_id) REFERENCES user(id) ON DELETE CASCADE
);

-- Report Table
CREATE TABLE IF NOT EXISTS report (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_date VARCHAR(45) NOT NULL,
    resolution_steps LONGTEXT,
    authority_id INT NOT NULL,
    issue_id INT NOT NULL,
    FOREIGN KEY (authority_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (issue_id) REFERENCES environmental_issues(issue_id) ON DELETE CASCADE
);

-- Notification Table
CREATE TABLE IF NOT EXISTS notification (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message MEDIUMTEXT NOT NULL,
    time_stamp VARCHAR(45) NOT NULL,
    title VARCHAR(30),
    description LONGTEXT,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

-- Facts Table
CREATE TABLE IF NOT EXISTS facts (
    number INT AUTO_INCREMENT PRIMARY KEY,
    fact LONGTEXT NOT NULL
);


-- Sample users--
INSERT INTO user (name, password, address, date_joined, email, role, points) 
VALUES 
    ('Mohib', '123', '123 Green St', '2025-03-12', 'mohib@example.com', 1, 0),
    ('Abuzar', '123', '456 Blue Ave', '2025-03-12', 'abuzar@example.com', 0, 0);

