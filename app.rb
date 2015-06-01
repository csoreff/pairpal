require 'sinatra'
require 'pg'
require 'pry'

require_relative 'helpers'

DBNAME = 'pairpals'

get "/" do
  erb :index, locals: {}
end

get '/show' do
  # # Allow get access only when necessary
  # unless time_to_pair?
  #   redirect '/'
  # end

  unless paired?
    set_pairings
  end

  erb :show, locals: {}
end

# Uncomment to automatically create a local db and populate with sample records.

# system("createdb #{DBNAME}")
# system("psql #{DBNAME} < schema.sql")
