FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy Prisma schema
COPY prisma ./prisma
COPY prisma.config.js ./

# Generate Prisma client with a dummy connection string
RUN DATABASE_URL="mysql://root:root@localhost:3306/dummy" npx prisma generate 2>&1 || true

# Copy application source
COPY src ./src

# Expose port
EXPOSE 3000

# Runtime: Build actual DATABASE_URL from Railway MySQL variables or use MYSQL_URL
ENV NODE_ENV=production

# Start with entrypoint that sets DATABASE_URL
ENTRYPOINT ["/bin/sh", "-c", "export DATABASE_URL=${DATABASE_URL:-${MYSQL_URL:-$([ -n \"$MYSQLHOST\" ] && [ -n \"$MYSQLUSER\" ] && [ -n \"$MYSQLPASSWORD\" ] && [ -n \"$MYSQLDATABASE\" ] && echo \"mysql://$MYSQLUSER:$MYSQLPASSWORD@$MYSQLHOST:${MYSQLPORT:-3306}/$MYSQLDATABASE\" || echo '')}}; node src/server.js"]
