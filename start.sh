#!/bin/sh

# Start the web server in the background
npm start "theorieles 3" &

# Wait for the server to be ready
echo "Waiting for server to start..."
while ! nc -z localhost 8000; do   
  sleep 1
done
echo "Server is ready!"

# Run the presentation generation
sh ./check-presentations.sh

# Keep the container running
wait
