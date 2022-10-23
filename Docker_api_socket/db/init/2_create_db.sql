CREATE DATABASE IF NOT EXISTS test_db;

USE test_db;

CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    roomId INT NOT NULL,
    mode TEXT NOT NULL,
    course TEXT NOT NULL,
    host TEXT NOT NULL,
    guest TEXT NOT NULL
);

INSERT INTO users (roomId, mode, course, host, guest) VALUES(111, "battle", "body", "aaaaa", "bbbbb");
INSERT INTO users (roomId, mode, course, host, guest) VALUES(222, "cooperate", "head", "ccccc", "ddddd");