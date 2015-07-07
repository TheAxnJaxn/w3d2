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
  author_id INTEGER REFERENCES users(id) NOT NULL
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_reply_id INTEGER REFERENCES id,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  body VARCHAR NOT NULL
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL
);

INSERT INTO
  users(fname, lname)
VALUES
  ("Ivan", "McCarter"), ("Krista", "Jackson"), ("Joe", "Bob"), ("Eric", "Esomething");

INSERT INTO
  questions(title, body, author_id)
VALUES
  ("Question 1", "This is my question??????", (SELECT id FROM users WHERE fname = "Ivan")),
  ("Question 2", "A second question???", (SELECT id FROM users WHERE fname = "Krista")),
  ("Question 3", "I have a third question?", (SELECT id FROM users WHERE lname = "McCarter"));

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  ((SELECT id FROM questions WHERE title = 'Question 1'), (SELECT id FROM users WHERE fname = "Ivan")),
  ((SELECT id FROM questions WHERE title = 'Question 1'), (SELECT id FROM users WHERE fname = "Joe")),
  ((SELECT id FROM questions WHERE title = 'Question 3'), (SELECT id FROM users WHERE fname = "Joe"));

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  ((SELECT id FROM questions WHERE title = 'Question 1'), NULL, (SELECT id FROM users WHERE fname = "Eric"), "This question is good."),
  ((SELECT id FROM questions WHERE title = 'Question 2'), NULL, (SELECT id FROM users WHERE fname = "Eric"), "This question is also good."),
  ((SELECT id FROM questions WHERE title = 'Question 1'), 1, (SELECT id FROM users WHERE fname = "Krista"), "I second that opinion!");

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = "Joe"), (SELECT id FROM questions WHERE title = 'Question 3')),
  ((SELECT id FROM users WHERE fname = "Joe"), (SELECT id FROM questions WHERE title = 'Question 2'));
