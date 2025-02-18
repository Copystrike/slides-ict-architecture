FROM node:18-alpine

WORKDIR /app

# Install Chrome dependencies and netcat
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    freetype-dev \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs \
    yarn \
    dbus \
    udev \
    netcat-openbsd

# Add Chrome user
RUN addgroup -S pptruser && adduser -S -G pptruser pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser /app

# Set Puppeteer environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy script first and verify it exists
COPY check-presentations.sh .

# Copy remaining application files
COPY . .

# Fix line endings and permissions for both scripts
RUN apk add --no-cache dos2unix \
    && dos2unix check-presentations.sh \
    && dos2unix start.sh \
    && chmod +x check-presentations.sh \
    && chmod +x start.sh \
    && mkdir -p presentaties

# Expose port
EXPOSE 8000

# Use the startup script
CMD ["./start.sh"]


