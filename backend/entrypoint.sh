#!/bin/sh

# Wait for database to be ready
echo "Waiting for database (db:3306)..."
while ! nc -z db 3306; do
  sleep 1
done
echo "Database port is open!"

# Extra wait to ensure MySQL is fully initialized
sleep 3

# Run migrations
echo "Running migrations..."
npm run migrate

# Run seeders if RUN_SEEDS=true
if [ "$RUN_SEEDS" = "true" ]; then
  echo "Running seeders..."
  npm run seed
fi

# Start the application
echo "Starting application..."
npm start
