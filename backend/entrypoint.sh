#!/bin/sh

# Wait for database to be ready
echo "Waiting for database..."
while ! nc -z db 3306; do
  sleep 1
done
echo "Database is up!"

# Run migrations
echo "Running migrations..."
npm run migrate

# Run seeders if needed (optional, maybe check if data already exists)
# For now, let's keep it manual or run it once
# npm run seed

# Start the application
echo "Starting application..."
npm start
