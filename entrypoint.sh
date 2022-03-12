#!/bin/bash
# docker entrypoint script.

# assign a default for the database_user
DB_USER=${DATABASE_USER}
DB_HOST=${DATABASE_HOST}

# wait until Postgres is ready
while ! pg_isready -q -h "$DB_HOST" -p 5432 -U "$DB_USER"
do
  ls
  echo "$(date) - waiting for database to start"
  sleep 2
done

bin="/app/bin/ebanx_umbrella"
eval "$bin eval \"EbanxWeb.Release.migrate\""
# start the elixir application
exec "$bin" "start"