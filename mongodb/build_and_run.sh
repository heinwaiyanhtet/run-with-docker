#!/bin/bash

# Configuration Variables
HOST_PORT=27019  
DB_USERNAME="admin"
DB_PASSWORD="password"
MONGODB_CONTAINER_NAME="mongodb-container"

# Start MongoDB container using Docker Compose
echo "Starting MongoDB container..."
docker compose up -d

# Check if the MongoDB container is running
if [ "$(docker ps -q -f name=$MONGODB_CONTAINER_NAME)" ]; then
    echo "MongoDB container is up and running."
else
    echo "Failed to start MongoDB container."
    exit 1
fi

# Print MongoDB connection URL
MONGODB_URL="mongodb://$DB_USERNAME:$DB_PASSWORD@localhost:$HOST_PORT"
echo "MongoDB connection URL: $MONGODB_URL"
