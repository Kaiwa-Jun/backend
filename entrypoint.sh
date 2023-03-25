#!/bin/sh
set -e

# Check if the database is up and running.
if [ "$DATABASE_URL" ]; then
  echo "Waiting for the database to be ready..."
  while ! nc -z $DATABASE_HOST $DATABASE_PORT; do
    sleep 1
  done
fi

# Run migrations if necessary.
if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:migrate
fi

# Then exec the container's main command (what's set as CMD in the Dockerfile).
exec "$@"