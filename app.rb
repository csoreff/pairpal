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
  db_connection do |conn|
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

get "/" do
  redirect "/pairings"
end

get "/pairings" do
  if time_to_pair? && !already_paired?
  #   set_pairings
  #   pairings = get_pairings
  # else
  #   pairings = {}
  # end

  erb :index, locals: {pairings: pairings}
end
