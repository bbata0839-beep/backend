FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy Prisma schema and related files
COPY prisma ./prisma

# Generate Prisma client
RUN npx prisma generate

# Copy application source
COPY src ./src
COPY prisma.config.js ./

# Expose port (adjust if needed)
EXPOSE 3000

# Start application
CMD ["node", "src/server.js"]
