FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy Prisma schema (no datasource URL needed in schema for Prisma v7 when using external config)
COPY prisma ./prisma

# Generate Prisma client with a dummy connection string
RUN DATABASE_URL="mysql://root:root@localhost:3306/dummy" npx prisma generate 2>&1 || true

# Copy application source
COPY src ./src

# Expose port
EXPOSE 3000

# Runtime: Build actual DATABASE_URL from Railway MySQL variables
ENV NODE_ENV=production

# Start with entrypoint that constructs DATABASE_URL
ENTRYPOINT ["/bin/sh", "-c", "if [ -z \"$DATABASE_URL\" ]; then if [ -n \"$MYSQLHOST\" ] && [ -n \"$MYSQLUSER\" ] && [ -n \"$MYSQLPASSWORD\" ] && [ -n \"$MYSQLDATABASE\" ]; then export DATABASE_URL=\"mysql://$MYSQLUSER:$MYSQLPASSWORD@$MYSQLHOST:${MYSQLPORT:-3306}/$MYSQLDATABASE\"; fi; fi; node src/server.js"]
