FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy Prisma schema
COPY prisma ./prisma

# Generate Prisma client with a dummy connection string (build-time only)
RUN DATABASE_URL="mysql://root:root@localhost:3306/dummy" npx prisma generate

# Copy application source
COPY src ./src

# Expose port
EXPOSE 3000

ENV NODE_ENV=production

# Build actual DATABASE_URL from Railway MySQL variables at startup
ENTRYPOINT ["/bin/sh", "-c", "export DATABASE_URL=${DATABASE_URL:-$([ -n \\\"$MYSQLHOST\\\" ] && [ -n \\\"$MYSQLUSER\\\" ] && [ -n \\\"$MYSQLPASSWORD\\\" ] && [ -n \\\"$MYSQLDATABASE\\\" ] && echo \\\"mysql://$MYSQLUSER:$MYSQLPASSWORD@$MYSQLHOST:${MYSQLPORT:-3306}/$MYSQLDATABASE\\\" || echo 'mysql://root:root@localhost:3306/dummy')}; node src/server.js"]
