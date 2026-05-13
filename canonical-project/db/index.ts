/**
 * Database connection. Use the `db` export everywhere; never instantiate
 * a second Postgres client.
 *
 * Always set DATABASE_URL via env (copy .env.example to .env.local). The
 * connection fails loudly if it's missing — better than silently
 * connecting somewhere unexpected.
 */

import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import * as schema from "./schema";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error(
    "DATABASE_URL is not set. Copy canonical-project/.env.example to .env.local and fill it in.",
  );
}

const queryClient = postgres(connectionString);

export const db = drizzle(queryClient, { schema });
export type DB = typeof db;
