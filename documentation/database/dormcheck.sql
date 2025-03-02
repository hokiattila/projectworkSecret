-- Drop existing tables in the correct order to avoid FK constraint issues
DROP TABLE IF EXISTS GEO_INFO;
DROP TABLE IF EXISTS CARDCHECKS;
DROP TABLE IF EXISTS PLACEMENT;
DROP TABLE IF EXISTS LOGIN;
DROP TABLE IF EXISTS ROOM;
DROP TABLE IF EXISTS BUILDING;
DROP TABLE IF EXISTS CARD_TABLE;
DROP TABLE IF EXISTS USER;
DROP EVENT IF EXISTS clear_cardchecks;


-- Create the database
CREATE DATABASE IF NOT EXISTS dormCheck;
USE dormCheck;

-- Create USER table
CREATE TABLE USER(
    userid INT AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(25) NULL DEFAULT "unknown",
    gender ENUM('male', 'female') NOT NULL,
    hashed_psw VARCHAR(255) NOT NULL,
    user_role ENUM('student', 'staff') NOT NULL,
    dob DATE NOT NULL,
    neptun_id VARCHAR(15) NULL,
    enroll_year VARCHAR(25) NULL
);

-- Create CARD table
CREATE TABLE CARD_TABLE(
    cardid VARCHAR(255) PRIMARY KEY
);

-- Create BUILDING table
CREATE TABLE BUILDING(
    bid INT AUTO_INCREMENT PRIMARY KEY,
    bname VARCHAR(255) NOT NULL,
    floor_count INT NOT NULL,
    baddress VARCHAR(255) NOT NULL
);

-- Create ROOM table with FK to BUILDING
CREATE TABLE ROOM(
    roomid INT AUTO_INCREMENT PRIMARY KEY,
    room_code VARCHAR(25) NULL,
    floor INT NOT NULL,
    block_number INT NULL DEFAULT 1,
    bid INT NOT NULL,
    cardid VARCHAR(255) NOT NULL,
    FOREIGN KEY (bid) REFERENCES BUILDING(bid) ON DELETE CASCADE,
    FOREIGN KEY (cardid) REFERENCES CARD_TABLE(cardid) ON DELETE CASCADE
);

-- Create LOGIN table
CREATE TABLE LOGIN(
    logid INT AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(32) NOT NULL UNIQUE,
    ltimestamp DATETIME NOT NULL,
    userid INT NOT NULL,
    FOREIGN KEY (userid) REFERENCES USER(userid) ON DELETE CASCADE
);

-- Create PLACEMENT table
CREATE TABLE PLACEMENT(
    userid INT NOT NULL,
    roomid INT NOT NULL,
    semester VARCHAR(25) NULL DEFAULT "2024/25-2",
    PRIMARY KEY(userid, roomid, semester),
    FOREIGN KEY (userid) REFERENCES USER(userid) ON DELETE CASCADE,
    FOREIGN KEY (roomid) REFERENCES ROOM(roomid) ON DELETE CASCADE
);

-- Create CARDCHECKS table
CREATE TABLE CARDCHECKS(
    cardid VARCHAR(255) NOT NULL,
    roomid INT NOT NULL,
    cevent VARCHAR(50) NOT NULL,
    ctimestamp DATETIME NOT NULL,
    PRIMARY KEY(cardid, roomid, ctimestamp), -- Adding timestamp to ensure uniqueness
    FOREIGN KEY (cardid) REFERENCES CARD_TABLE(cardid) ON DELETE CASCADE,
    FOREIGN KEY (roomid) REFERENCES ROOM(roomid) ON DELETE CASCADE
);

-- Create GEO_INFO table
CREATE TABLE GEO_INFO(
    logid INT NOT NULL,
    ip_address VARCHAR(32) NOT NULL,
    geo_info VARCHAR(255) NULL DEFAULT "unknown",
    PRIMARY KEY (logid, ip_address),
    FOREIGN KEY (logid) REFERENCES LOGIN(logid) ON DELETE CASCADE,
    FOREIGN KEY (ip_address) REFERENCES LOGIN(ip_address) ON DELETE CASCADE
);

INSERT INTO USER (firstname, lastname, email, phone, gender, hashed_psw, user_role, dob, neptun_id, enroll_year) VALUES 
('John', 'Doe', 'johndoe@example.com', '123-456-7890', 'male', 'hashed_password_1', 'student', '2000-05-15', 'AB1234', '2023'),
('Alice', 'Smith', 'alice.smith@example.com', NULL, 'female', 'hashed_password_2', 'staff', '1985-09-22', NULL, NULL);

INSERT INTO CARD_TABLE (cardid) VALUES 
("234556343233"), 
("544443432328");

INSERT INTO BUILDING (bname, floor_count, baddress) VALUES 
('Main Dormitory', 5, '123 University St, Cityville'),
('Annex Building', 3, '456 College Ave, Townsville');

INSERT INTO ROOM (room_code, floor, block_number, bid, cardid) VALUES 
("401", 2, 1, 1, '234556343233'), 
("402", 3, 2, 2, '544443432328');




SET GLOBAL event_scheduler = ON;

DELIMITER $$

CREATE EVENT IF NOT EXISTS clear_cardchecks
ON SCHEDULE EVERY 30 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    DELETE FROM CARDCHECKS;
END $$

DELIMITER ;
