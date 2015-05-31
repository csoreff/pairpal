require 'sinatra'
require 'pg'
require 'pry'

DBNAME = 'pairpals'

### DATABASE methods

def db
  begin
    connection = PG.connect(dbname: DBNAME)
    yield(connection)
  rescue
    connection.close
  end
end

def sql(statement, exec_type, array_items)
  db do |conn|
    if exec_type == "exec"
      conn.exec(statement)
    else
      conn.exec_params(statement, array_items)
    end
  end
end

def daily_users
  sql("
    SELECT *
    FROM daily_users
    JOIN users ON users.id = daily_users.user_id
    JOIN preferences ON preferences.id = daily_users.preference_id
  ", "exec", nil)
end


def pairings
  # Doesn't include all pairings for some reason
  sql("
    SELECT
      users_first.first_name,
      users_first.last_name,
      users_second.first_name,
      users_second.last_name,
      preferences.type
    FROM pairings
    JOIN users AS users_first ON users_first.id = pairings.first_user_id
    JOIN users AS users_second ON users_second.id = pairings.second_user_id
    JOIN preferences ON preferences.id = pairings.preference_id
  ", "exec", nil)
end

get "/" do
  redirect "/pairings"
end

get "/pairings" do
  @daily_users = daily_users
  @pairings = pairings
  erb :index
end

# Uncomment to automatically create a local db and populate with sample records.

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")
