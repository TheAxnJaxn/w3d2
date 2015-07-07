DROP TABLE IF EXISTS users;

CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR NOT NULL,
  author_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  user_id INTEGER REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_reply_id INTEGER REFERENCES id,
  user_id INTEGER REFERENCES users(id),
  body VARCHAR NOT NULL
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ("Ivan", "McCarter"), ("Krista", "Jackson"), ("Joe", "Bob"), ("Eric", "Esomething");

INSERT INTO
  questions(title, body, author_id)
VALUES
  ("Question 1", "This is my question??????", ('SELECT id FROM users WHERE fname = "Ivan"')),
  ("Question 2", "A second question???", ('SELECT id FROM users WHERE fname = "Krista"')),
  ("Question 3", "I have a third question?", ('SELECT id FROM users WHERE lname = "McCarter"'));
