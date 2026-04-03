import pkg from "@prisma/client";

const { PrismaClient } = pkg;

export const prisma = new PrismaClient({
  errorFormat: process.env.NODE_ENV === "production" ? "minimal" : "pretty",
});