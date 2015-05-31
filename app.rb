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
  all = db_connection do |conn|
    if exec_type == "exec"
      conn.exec(statement)
    else
      conn.exec_params(statement, array_items)
    end
  end
  all = all.to_a
end

# Uncomment to automatically create a local db
# and populate with sample records

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")

get "/" do
  redirect "/pairings"
end

get "/pairings" do
  erb :index

end
