### WRAPPER methods

def db
   connection_settings = { dbname: ENV["DATABASE_NAME"] || DBNAME }

   if ENV["DATABASE_HOST"]
     connection_settings[:host] = ENV["DATABASE_HOST"]
   end

   if ENV["DATABASE_USER"]
     connection_settings[:user] = ENV["DATABASE_USER"]
   end

   if ENV["DATABASE_PASS"]
     connection_settings[:password] = ENV["DATABASE_PASS"]
   end

   begin
     connection = PG.connect(connection_settings)
     yield(connection)
   ensure
     connection.close
   end
 end

def exec(sql)
  db {|conn| conn.exec(sql)}
end

def exec_params(sql, vals)
  db {|conn| conn.exec_params(sql, vals)}
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


### GENERAL UTILITY

def current_day
  Time.now.to_s.slice(0..9)
end

def time_to_pair?
  # t = Time.now
  # t.hour >= 11 && t.min >= 30
  true
end

def time_to_post?
  # t = Time.now
  # t.hour <= 11 && t.min < 30
  true
end

def paired?
  exec_params("SELECT day FROM pairings WHERE day = $1", [current_day]).count > 0
end


### DATABASE I/O

def add_user(first_name, last_name)
  exec_params("INSERT INTO users (first_name, last_name) VALUES ($1, $2)",
    [first_name, last_name])
end

def user_exists?(first_name, last_name)
  exec_params("SELECT id FROM users WHERE first_name ILIKE $1 AND last_name ILIKE $2",
    [first_name, last_name]).count > 0
end

def daily_user_exists?(user_id)
  exec_params("SELECT user_id FROM daily_users WHERE user_id = $1", [user_id]).count > 0
end

def get_user_id(first_name, last_name)
  exec_params("SELECT id FROM users WHERE first_name ILIKE $1 AND last_name ILIKE $2",
    [first_name, last_name])[0]["id"]
end

def get_preference_id(preference)
  id = exec_params("SELECT id FROM preferences WHERE type ILIKE $1", [preference])
  id[0]["id"]
end

def add_daily_user(user_id, pref_id)
  exec_params("
    INSERT INTO daily_users (user_id, preference_id)
    VALUES ($1, $2)", [user_id, pref_id])
end

def daily_users
  sql("
    SELECT * FROM daily_users
    JOIN users ON users.id = daily_users.user_id
    JOIN preferences ON preferences.id = daily_users.preference_id
  ", "exec", nil)
end

def get_preference_groups
  sql("
      SELECT preference_id, user_id FROM daily_users
      ORDER BY preference_id
      ", 'exec', nil)
end

def add_pairing(pref, first_user, second_user)
  sql("
      INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
      VALUES ('#{first_user}', '#{second_user}', '#{pref}', '#{current_day}')
      ", 'exec', nil)
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

  # Uncomment below to add the remaining odd user
  # to pairings table by 'themselves' (ie paired with null user)
  # add_pairing('3', remaining[-1], 0) if remaining.count.odd?
end

def clear_pairings
  sql("DELETE FROM pairings", "exec", nil)
end

def clear_daily_users
  sql("DELETE FROM daily_users", "exec", nil)
end

def pairings
  # Need to update this to reflect odd number of daily_users,
  # where last person is stored in row with second_user_id = 0
  sql("
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
    ORDER BY preferences.type
  ", "exec", nil)

  # sql("
  #   SELECT
  #     users_first.first_name AS first_first_name,
  #     users_first.last_name AS first_last_name,
  #     users_second.first_name AS second_first_name,
  #     users_second.last_name AS second_last_name,
  #     preferences.type
  #   FROM pairings
  #     LEFT JOIN users AS users_first ON users_first.id = pairings.first_user_id
  #     LEFT JOIN users AS users_second ON users_second.id = pairings.second_user_id
  #     LEFT JOIN preferences ON preferences.id = pairings.preference_id
  #   ORDER BY preferences.type
  # ", "exec", nil)
end
