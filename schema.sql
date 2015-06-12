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

CREATE VIEW pairings_view AS
SELECT
  pairings.id,
  users_first.first_name AS first_first_name,
  users_first.last_name AS first_last_name,
  users_second.first_name AS second_first_name,
  users_second.last_name AS second_last_name,
  preferences.type
FROM pairings
  JOIN users AS users_first ON users_first.id = pairings.first_user_id
  JOIN users AS users_second ON users_second.id = pairings.second_user_id
  JOIN preferences ON preferences.id = pairings.preference_id
ORDER BY preferences.type;

INSERT INTO preferences (type) VALUES ('Daily');
INSERT INTO preferences (type) VALUES ('Evening');
INSERT INTO preferences (type) VALUES ('Other');

-- INSERT INTO users (first_name, last_name)
-- VALUES ('Kevin', 'Larrabee')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Danelson', 'Rosa')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Eiyre', 'Cat')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Jose', 'Cuervo')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('John', 'Doe')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Crown', 'Royale')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Julian', 'Bashir')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Siri', 'Apul')
-- ;
-- INSERT INTO users (first_name, last_name)
-- VALUES ('Bic', 'Mitchum')
-- ;
-- -- INSERT INTO users (first_name, last_name)
-- -- VALUES ('Mike', 'Lowry')
-- -- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('1', '1')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('10', '1')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('2', '2')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('9', '2')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('3', '3')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('8', '3')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('4', '1')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('7', '1')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('5', '2')
-- ;
-- INSERT INTO daily_users (user_id, preference_id)
-- VALUES ('6', '2')
-- ;

-- INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
-- VALUES (1, 10, 1, '5/31/15')
-- ;
-- INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
-- VALUES (2, 9, 2, '5/31/15')
-- ;
-- INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
-- VALUES (3, 8, 3, '5/31/15')
-- ;
-- INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
-- VALUES (4, 7, 1, '5/31/15')
-- ;
-- INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
-- VALUES (5, 6, 2, '5/31/15')
-- ;
