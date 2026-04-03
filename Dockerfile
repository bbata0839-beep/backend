FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy Prisma schema and config
COPY prisma ./prisma
COPY prisma.config.js ./

# Generate Prisma client (with dummy DATABASE_URL for build only)
RUN DATABASE_URL="mysql://user:password@localhost:3306/dummy" npx prisma generate

# Copy application source
COPY src ./src

# Expose port
EXPOSE 3000

# Build DATABASE_URL from Railway MySQL variables if they exist, otherwise use DATABASE_URL
RUN echo '#!/bin/sh\n\
if [ -z "$DATABASE_URL" ]; then\n\
  if [ -n "$MYSQLHOST" ] && [ -n "$MYSQLUSER" ] && [ -n "$MYSQLPASSWORD" ] && [ -n "$MYSQLDATABASE" ]; then\n\
    PORT=${MYSQLPORT:-3306}\n\
    export DATABASE_URL="mysql://${MYSQLUSER}:${MYSQLPASSWORD}@${MYSQLHOST}:${PORT}/${MYSQLDATABASE}"\n\
  fi\n\
fi\n\
exec node src/server.js' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# Start application
CMD ["/app/entrypoint.sh"]
