DROP TABLE IF EXISTS
  users,
  daily_users,
  preferences,
  pairings;

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