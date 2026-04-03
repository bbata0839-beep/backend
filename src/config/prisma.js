import { PrismaClient } from "@prisma/client";

// Construct DATABASE_URL from Railway's individual MySQL variables or use provided URL
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
  
  throw new Error(
    "Database connection URL not found. Set MYSQL_URL, DATABASE_URL, or Railway MySQL variables (MYSQLHOST, MYSQLUSER, MYSQLPASSWORD, MYSQLPORT, MYSQLDATABASE)"
  );
};

export const prisma = new PrismaClient({
  errorFormat: "pretty",
});