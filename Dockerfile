FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Expose port
EXPOSE 8000

# Start the application with the latest theory lesson
CMD sh -c 'npm start "$(ls -d theorieles* | sort -V | tail -n 1)"'
