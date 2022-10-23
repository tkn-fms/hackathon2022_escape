CREATE DATABASE IF NOT EXISTS test_db;

USE test_db;

CREATE TABLE IF NOT EXISTS answers (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    uid INT NOT NULL,
    qid INT NOT NULL,
    answer TEXT NOT NULL
);

INSERT INTO answers (uid, qid, answer) VALUES(1, 2, "test");
INSERT INTO answers (uid, qid, answer) VALUES(2, 3, "test2");