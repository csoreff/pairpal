require 'sinatra'
require 'pg'
require 'pry'

require_relative 'helpers'


DBNAME = 'pairpals'

get "/" do
  if !paired? # && time_to_pair?
    set_pairings
  end
  erb :index, locals: {}
end

# Uncomment to automatically create a local db and populate with sample records.

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")
