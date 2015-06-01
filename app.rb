require 'sinatra'
require 'pg'
require 'pry'

DBNAME = 'pairpals'
$paired = false


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

def get_preference_groups
  db do |conn|
    conn.exec("
      SELECT preference_id, user_id FROM daily_users
      ORDER BY preference_id
      ")
  end
  preference_groups = [[], [], [], []]
end

def set_pairings
  # Run through daily_users and match up based on preference
  # and furthest pairing history, per 'pairings' table
  get_preference_groups


  $paired = true
end

def get_pairings
  # Return [ [user1, user2, pref], [user3, user4, pref], ... ]
end

def time_to_pair?
  time = Time.now
  time.hour > 12
end

def already_paired?

end

# def daily_users
#   sql("
#     SELECT *
#     FROM daily_users
#     JOIN users ON users.id = daily_users.user_id
#     JOIN preferences ON preferences.id = daily_users.preference_id
#   ", "exec", nil)
# end

# def pairings
#   # Doesn't include all pairings for some reason
#   sql("
#     SELECT
#       users_first.first_name,
#       users_first.last_name,
#       users_second.first_name,
#       users_second.last_name,
#       preferences.type
#     FROM pairings
#     JOIN users AS users_first ON users_first.id = pairings.first_user_id
#     JOIN users AS users_second ON users_second.id = pairings.second_user_id
#     JOIN preferences ON preferences.id = pairings.preference_id
#   ", "exec", nil)
# end

get "/" do
  redirect "/pairings"
end

get "/pairings" do
  # if time_to_pair? && !already_paired?
  #   set_pairings
  #   pairings = get_pairings
  # else
  #   pairings = {}
  # end

  # @daily_users = daily_users
  # @pairings = pairings

  erb :index, locals: {pairings: pairings}
end

# Uncomment to automatically create a local db and populate with sample records.

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")
