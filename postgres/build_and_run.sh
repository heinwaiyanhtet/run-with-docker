#!/bin/bash

# Check if docker-compose is installed
if ! command -v docker compose &> /dev/null
then
    echo "docker compose could not be found. Please install it first."
    exit 1
fi

# Run docker-compose
echo "Starting PostgreSQL service..."
docker compose up -d

# Check if the service started successfully
if [ $? -eq 0 ]; then
    echo "PostgreSQL container started successfully."
else
    echo "Failed to start PostgreSQL container."
    exit 1
fi

# Wait a few seconds to ensure the PostgreSQL service is fully up
echo "Waiting for PostgreSQL service to initialize..."
# sleep 10


# Get the container ID based on the correct service name
CONTAINER_NAME=$(docker compose ps -q postgres) # Use the correct service name, 'postgres'
if [ -n "$CONTAINER_NAME" ]; then
    echo "Copying database.sql to the container..."
    docker cp database.sql "$CONTAINER_NAME":/database.sql

    # Execute database.sql in the PostgreSQL container
    echo "Executing database.sql in the container..."
    docker exec -i "$CONTAINER_NAME" psql -U admin -d bossnation -f /database.sql
    # docker exec -i "$CONTAINER_NAME" pg_restore -U admin -d bossnation /database.sql
    if [ $? -eq 0 ]; then
        echo "SQL file executed successfully."
    else
        echo "Failed to execute SQL file."
    fi
else
    echo "Failed to find the PostgreSQL container."
    exit 1
fi

POSTGRES_USER="admin" 
POSTGRES_PASSWORD="w6T63z5lvBItSOoGA77NZ1qQhwnlN45yT2NKMnnpVykwTetfXYY" 
POSTGRES_DB="bossnation"
POSTGRES_HOST="localhost"
POSTGRES_PORT=$(docker compose port postgres 5432 | cut -d: -f2) # Extract the mapped port

# Output the connection string
echo "Your PostgreSQL connection string is ready to use:"
echo "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"
