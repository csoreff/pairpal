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

def time_to_pair?
  time = Time.now
  time.hour > 12
end

def already_paired?
  true
end

def get_pairings
  # Return [ [user1, user2, pref], [user3, user4, pref], ... ]
end

def set_pairings
  groups = { "1" => [], "2" => [], "3" => [] }

  get_preference_groups.each do |user|
    groups[user["preference_id"]] << user["user_id"]
  end

  remaining = []

  groups.each do |pref_id, group|
    group.shuffle!
    remaining << group.pop if group.count.odd?

    (0...group.length).step(2) do |x|
      add_pairing(pref_id, group[x], group[x+1])
    end
  end

  (0...remaining.length).step(2) do |x|
    add_pairing('3', remaining[x], remaining[x+1])
  end

  add_pairing('3', remaining[-1], 0) if remaining.count.odd?

  $paired = true
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
  # if time_to_pair? && !already_paired?
  #   set_pairings
  #   pairings = get_pairings
  # else
  #   pairings = {}
  # end

  erb :index, locals: {}
end

# Uncomment to automatically create a local db and populate with sample records.

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")
