CREATE TABLE IF NOT EXISTS accounts(
    id VARCHAR(255) NOT NULL primary key COMMENT 'primary key',
    createdAt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Time Created',
    updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Last Update',
    name varchar(255) COMMENT 'User Name',
    email varchar(255) COMMENT 'User Email',
    picture varchar(255) COMMENT 'User Picture'
) default charset utf8 COMMENT '';

CREATE TABLE IF NOT EXISTS events(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    coverImg VARCHAR(255) DEFAULT 'https: / / media.istockphoto.com / photos / cheering - crowd - with - hands - in - air - at - music - festival - picture - id1247853982 ? k = 20 & m = 1247853982 & s = 612x612 & w = 0 & h = QyAzDkXf7kr7ZljPCsdIrpREnqBRpb0ybotTQ7037cA =',
    location VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    startDate DATE NOT NULL,
    isCanceled TINYINT DEFAULT 0,
    type ENUM('concert', 'convention', 'sport', 'digital'),
    creatorId VARCHAR(255) NOT NULL,
    FOREIGN KEY(creatorId) REFERENCES accounts(id)
) default charset utf8 COMMENT '';

CREATE TABLE IF NOT EXISTS tickets(
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    eventId INT NOT NULL,
    accountId VARCHAR(255) NOT NULL,
    FOREIGN KEY (eventId) REFERENCES events(id),
    FOREIGN KEY(accountId) REFERENCES accounts(id)
) default charset utf8 COMMENT '';

/* Make an event */

INSERT INTO
    events (
        name,
        coverImg,
        location,
        capacity,
        startDate,
        isCanceled,
        type,
        creatorId
    )
VALUES
    (
        'bacon fest',
        'https://image.cnbcfm.com/api/v1/image/106422623-1583263287565sports-fans_t20_a8xnpx.jpg?v=1583263335&w=1600&h=900',
        'codeworks',
        100,
        '2022-5-23',
        0,
        'sport',
        '6287bd3ae213abcf468b14d6'
    );

/* Make a ticket */

INSERT INTO
    tickets (eventId, accountId)
VALUES
    (10, '6287bd3ae213abcf468b14d6');

/* Decrease event capacity after ticket created */

/* This is a stretch goal */

DELIMITER //

CREATE TRIGGER event_ticket_decrease
AFTER
INSERT
    ON tickets FOR EACH ROW BEGIN
UPDATE
    events e
SET
    e.capacity = e.capacity - 1
WHERE
    e.id = NEW.eventId;

END// 

DELIMITER ;

/* Many to many relationship: grab all the tickets and 'populate' their events and accounts */

/* Build in steps...start with only selecting names to show off how the table is created/joined */

SELECT
    e.name,
    e.capacity,
    t.id AS ticketId,
    a.name
FROM
    tickets t
    JOIN events e on t.eventId = e.id
    JOIN accounts a on a.id = t.accountId
WHERE
    t.id = 2;

SELECT FROM WHERE;

SELECT e.* FROM events e WHERE e.startDate < CURRENT_DATE();

/* Shows off like operator....%% will look for anything that contains value inside % */

SELECT
    e.*,
    a.*
FROM
    events e
    JOIN accounts a ON a.id = e.creatorId
WHERE
    e.name LIKE "%horse%"