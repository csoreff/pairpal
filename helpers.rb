### WRAPPER methods

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


### GENERAL UTILITY

def current_day
  Time.now.to_s.slice(0..9)
end

def time_to_pair?
  time = Time.now
  time.hour.between?(12, 14)
end

def paired?
  # If database contains pairing for current day,
  # daily_users have already been paired
  db do |conn|
    conn.exec("
      SELECT day FROM pairings WHERE day = '#{current_day}'
      ").count > 0
  end
end


### DATABASE I/O

def daily_users
  sql("
    SELECT *
    FROM daily_users
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

  add_pairing('3', remaining[-1], 0) if remaining.count.odd?
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
end
