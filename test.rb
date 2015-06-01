require 'pg'

#system('ruby db_reset.rb')

def db
  begin
    connection = PG.connect(dbname: 'pairpals')
    yield(connection)
  rescue
    connection.close
  end
end

def current_day
  Time.now.to_s.slice(0..9)
end

def get_preference_groups
  db do |conn|
    conn.exec("
      SELECT preference_id, user_id FROM daily_users
      ORDER BY preference_id
      ")
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

def add_pairing(pref, first_user, second_user)
  day = Time.now.to_s.slice(0..9)

  db do |conn|
    conn.exec("
      INSERT INTO pairings (first_user_id, second_user_id, preference_id, day)
      VALUES ('#{first_user}', '#{second_user}', '#{pref}', '#{day}')
      ")
  end
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

def paired?
  db do |conn|
    conn.exec("SELECT day FROM pairings WHERE day = '#{current_day}'").count > 0
  end
end

puts paired?