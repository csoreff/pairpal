require 'sinatra'
require 'pg'
require './helpers'

DBNAME = 'pairpals'

get '/' do
  # if time_to_pair? #&& !paired?
  #   clear_pairings # test function - not to use with paired?
  #   set_pairings
  # end
  erb :index, locals: {}
end

post '/adduser' do
  sanitize(params)
  
  first_name = params["first_name"]
  last_name = params["last_name"]

  add_user(first_name, last_name) unless user_exists?(first_name, last_name)

  pref = params["project_preference"]

  user_id = get_user_id(first_name, last_name)
  pref_id = get_preference_id(pref)

  if daily_user_exists?(user_id)
    # flash a warning
  else
    add_daily_user(user_id, pref_id)
  end

  redirect '/'
end

get '/pair' do
  set_pairings
  clear_daily_users
  redirect '/'
end

get '/clear' do
  clear_daily_users
  clear_pairings
  redirect '/'
end