# system("dropdb pairpals")
# system("createdb pairpals")
# system("psql pairpals < schema.sql")

system("heroku pg:psql DATABASE_NAME < schema.sql")