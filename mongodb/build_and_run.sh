#!/bin/bash

# Configuration Variables
DB_USERNAME="admin"
DB_PASSWORD="password"
MONGODB_CONTAINER_NAME="mongodb-container"

# Start MongoDB container using Docker Compose
echo "Starting MongoDB container..."
docker-compose up -d

# Check if the MongoDB container is running
if [ "$(docker ps -q -f name=$MONGODB_CONTAINER_NAME)" ]; then
    echo "MongoDB container is up and running."
else
    echo "Failed to start MongoDB container."
    exit 1
fi

# MongoDB will be available on localhost:27017 since we are using host networking
MONGODB_URL="mongodb://$DB_USERNAME:$DB_PASSWORD@localhost:27017"
echo "MongoDB connection URL: $MONGODB_URL"
