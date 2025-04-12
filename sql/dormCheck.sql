CREATE DATABASE IF NOT EXISTS dormCheck;
USE dormCheck;

DROP TABLE IF EXISTS GEO_INFO;
DROP TABLE IF EXISTS PRICES;
DROP TABLE IF EXISTS GUESTRECEPTION;
DROP TABLE IF EXISTS ASSIGNMENT;
DROP TABLE IF EXISTS CARDCHECKS;
DROP TABLE IF EXISTS SUBSCRIPTIONS;
DROP TABLE IF EXISTS PLACEMENT;
DROP TABLE IF EXISTS USERLOGS;
DROP TABLE IF EXISTS GUESTS;
DROP TABLE IF EXISTS SERVICES;
DROP TABLE IF EXISTS ROOM;
DROP TABLE IF EXISTS BUILDING;
DROP TABLE IF EXISTS ACCESSCARD;
DROP TABLE IF EXISTS USER;
DROP EVENT IF EXISTS clear_cardchecks;



CREATE TABLE `USER`(
    userid INT AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(25) NOT NULL,
    lastname VARCHAR(25) NOT NULL,
    email VARCHAR(50)  NULL,
    phone VARCHAR(25) NULL DEFAULT "unknown",
    gender ENUM('male', 'female') NULL,
    hashed_psw VARCHAR(255) NULL,
    img_path VARCHAR(255) NULL DEFAULT "unknown.jpg",
    user_role ENUM('student', 'staff', 'administrator', 'unverified') NOT NULL DEFAULT 'student',
    dob DATE NULL,
    neptun_id VARCHAR(15) NULL,
    enroll_year VARCHAR(25) NULL
);

CREATE TABLE ACCESSCARD(
    cardid VARCHAR(255) PRIMARY KEY
);

CREATE TABLE BUILDING(
    bid INT AUTO_INCREMENT PRIMARY KEY,
    build_name VARCHAR(255) NOT NULL,
    floor_count INT NOT NULL,
    build_address VARCHAR(255) NOT NULL
);

CREATE TABLE ROOM(
    roomid INT AUTO_INCREMENT PRIMARY KEY,
    room_code VARCHAR(25) NOT NULL DEFAULT "unknown",
    floor INT NOT NULL,
    block_number INT NULL DEFAULT 0,
    bid INT NOT NULL,
    FOREIGN KEY (bid) REFERENCES BUILDING(bid) ON DELETE CASCADE
);

CREATE TABLE SERVICES(
    serviceid INT AUTO_INCREMENT PRIMARY KEY,
    `description` VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE GUESTS(
    guestid INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    ID_Card VARCHAR(50) NOT NULL
);

CREATE TABLE USERLOGS(
    logid INT AUTO_INCREMENT PRIMARY KEY,
    ip_address VARCHAR(125) NOT NULL,
    log_time DATETIME NOT NULL,
    userid INT NOT NULL,
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE
);

CREATE TABLE PLACEMENT(
    userid INT NOT NULL,
    roomid INT NOT NULL,
    semester VARCHAR(25) NULL DEFAULT "2024/25-2",
    moved_in TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY(userid, roomid, semester, moved_in),
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE,
    FOREIGN KEY (roomid) REFERENCES ROOM(roomid) ON DELETE CASCADE
);

CREATE TABLE SUBSCRIPTIONS (
    userid INT NOT NULL,
    serviceid INT NOT NULL,
    `start_date` DATE NOT NULL DEFAULT CURRENT_DATE,
    `end_date` DATE NOT NULL,
    PRIMARY KEY (userid, serviceid),
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE,
    FOREIGN KEY (serviceid) REFERENCES SERVICES(serviceid) ON DELETE CASCADE
);

CREATE TABLE CARDCHECKS(
    cardid VARCHAR(255) NOT NULL,
    userid INT NULL,
    cevent VARCHAR(50) NOT NULL,
    check_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(cardid, userid, check_time),
    FOREIGN KEY (cardid) REFERENCES ACCESSCARD(cardid) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE
);



CREATE TABLE ASSIGNMENT(
    userid INT NOT NULL,
    cardid VARCHAR(255) NOT NULL,
    valid_start DATE NOT NULL DEFAULT CURRENT_DATE,
    valid_end DATE NOT NULL,
    PRIMARY KEY(userid, cardid, valid_start),
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE,
    FOREIGN KEY (cardid) REFERENCES ACCESSCARD(cardid) ON DELETE CASCADE
);

CREATE TABLE GUESTRECEPTION(
    userid INT NOT NULL,
    guestid INT NOT NULL,
    checkin_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    checkout_time DATETIME NULL,
    FOREIGN KEY (userid) REFERENCES `USER`(userid) ON DELETE CASCADE,
    FOREIGN KEY (guestid) REFERENCES GUESTS(guestid) ON DELETE CASCADE
);

CREATE TABLE PRICES(
    `description` VARCHAR(120) NOT NULL,
    monthly_cost INT NOT NULL,
    PRIMARY KEY(`description`),
    FOREIGN KEY(`description`) REFERENCES SERVICES(`description`)
);


CREATE TABLE GEO_INFO(
    ip_address VARCHAR(125) NOT NULL,
    geo_info VARCHAR(255) NULL DEFAULT "unknown",
    PRIMARY KEY (ip_address)
);

CREATE TABLE INVALID_CHECKS(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    cardnumber VARCHAR(50) NOT NULL,
    cevent ENUM("UNASSIGNED, UNKNOWN CARD"),
    check_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ACCESSCARD VALUES ("UNKNOWN");
INSERT INTO `USER`(userid, firstname, lastname, user_role) VALUES (-1, "UNKNOWN", "USER", "unverified");
