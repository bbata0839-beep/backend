import { defineConfig } from '@prisma/internals';

// Construct DATABASE_URL from Railway's individual MySQL variables
const getDatabaseUrl = () => {
  if (process.env.MYSQL_URL) return process.env.MYSQL_URL;
  if (process.env.DATABASE_URL) return process.env.DATABASE_URL;
  
  // Construct from individual Railway MySQL variables
  const host = process.env.MYSQLHOST;
  const user = process.env.MYSQLUSER;
  const password = process.env.MYSQLPASSWORD;
  const port = process.env.MYSQLPORT || 3306;
  const database = process.env.MYSQLDATABASE;
  
  if (host && user && password && database) {
    return `mysql://${user}:${password}@${host}:${port}/${database}`;
  }
  
  return 'mysql://localhost:3306/dev'; // fallback for local dev
};

export default defineConfig({
  datasources: {
    db: {
      url: getDatabaseUrl(),
    },
  },
});
