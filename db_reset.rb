system("dropdb pairpals")
system("createdb pairpals")
system("psql pairpals < schema.sql")