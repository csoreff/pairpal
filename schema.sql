DROP TABLE IF EXISTS
  users,
  daily_users,
  preferences,
  pairings
;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50)
);

CREATE TABLE daily_users (
  id SERIAL PRIMARY KEY,
  user_id INT,
  preference_id INT
);

CREATE TABLE preferences (
  id SERIAL PRIMARY KEY,
  type VARCHAR(25)
);

CREATE TABLE pairings (
  id SERIAL PRIMARY KEY,
  first_user_id INT,
  second_user_id INT,
  preference_id INT,
  day DATE
);

INSERT INTO users (first_name, last_name)
VALUES ('Kevin', 'Larrabee')
;
INSERT INTO users (first_name, last_name)
VALUES ('Danelson', 'Rosa')
;
INSERT INTO users (first_name, last_name)
VALUES ('Eiyre', 'Cat')
;
INSERT INTO users (first_name, last_name)
VALUES ('Jose', 'Cuervo')
;
INSERT INTO users (first_name, last_name)
VALUES ('John', 'Doe')
;
INSERT INTO users (first_name, last_name)
VALUES ('Jane', 'Doe')
;

INSERT INTO preferences (type)
VALUES ('Afternoon')
;
INSERT INTO preferences (type)
VALUES ('Evening')
;
INSERT INTO preferences (type)
VALUES ('Other')
;
