require 'pg'
require './helpers'

DBNAME = 'pairpals'

def db
  begin
    connection = PG.connect(dbname: DBNAME)
    yield(connection)
  rescue
    connection.close
  end
end

def exec(sql)
  db {|conn| conn.exec(sql)}
end

def exec_params(sql, vals)
  db {|conn| conn.exec_params(sql, vals)}
end

def user_exists?(first_name, last_name)
  exec_params("SELECT id FROM users WHERE first_name ILIKE $1 AND last_name ILIKE $2",
    [first_name, last_name]).count > 0
end

def get_user_id(first_name, last_name)
  exec_params("SELECT id FROM users WHERE first_name ILIKE $1 AND last_name ILIKE $2",
    [first_name, last_name])[0]["id"]
end

def daily_user_exists?(user_id)
  exec_params("SELECT user_id FROM daily_users WHERE user_id = $1", [user_id]).count > 0
end

def add_user(first_name, last_name)
  exec_params("INSERT INTO users (first_name, last_name) VALUES ($1, $2)",
    [first_name, last_name])
end

add_user('kevin', 'larrabee')

puts exec_params("SELECT day FROM pairings WHERE day = $1", [current_day]).count > 0

# puts user_exists?('kevin', 'beeere')
puts get_user_id('first name', 'last name')
puts daily_user_exists?(8)
# puts get_preference_id('daily')

