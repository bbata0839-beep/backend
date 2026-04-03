import app from "./app.js";
import { logger } from "./config/logger.js";
import "./jobs/reminderWorker.js";
import "./jobs/csvImportWorker.js";

import { execSync } from "child_process";

// ✅ Prisma generate runtime дээр
try {
  execSync("npx prisma generate", { stdio: "inherit" });
} catch (e) {
  console.error("Prisma generate failed", e);
}

// crash хамгаалалт
process.on("uncaughtException", (err) => {
  logger.error("uncaughtException", err?.message || err);
});

process.on("unhandledRejection", (reason) => {
  logger.error("unhandledRejection", reason?.message || reason);
});

// ✅ PORT
const port = Number(process.env.PORT || 4000);

app.listen(port, () => {
  logger.info(`API running on :${port}`);
});