import { PrismaClient } from "@prisma/client";

const databaseUrl = process.env.MYSQL_URL || process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error("DATABASE_URL or MYSQL_URL environment variable is required");
}

export const prisma = new PrismaClient({
  errorFormat: "pretty",
});