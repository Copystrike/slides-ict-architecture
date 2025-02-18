FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Create presentations directory and make check script executable
RUN mkdir -p presentaties && chmod +x check-presentations.sh

# Expose port
EXPOSE 8000

# Start the application and run the check script
CMD sh -c './check-presentations.sh && npm start "$(ls -d theorieles* | sort -V | tail -n 1)"'
