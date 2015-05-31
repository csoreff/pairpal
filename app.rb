#require 'sinatra'
require 'pg'

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

system("createdb #{DBNAME}")
system("psql #{DBNAME} < schema.sql")