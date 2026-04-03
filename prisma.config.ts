import { defineConfig } from '@prisma/internals';

export default defineConfig({
  datasources: {
    db: {
      url: process.env.MYSQL_URL || process.env.DATABASE_URL,
    },
  },
});
