/**
 * MembershipKit — minimal starter schema.
 *
 * This file ships ONLY the foundational tables (users, organizations,
 * memberships) so the app boots. Subsequent course chapters add:
 *  - Chapter 25 (auth flow): session + verification tables
 *  - Chapter 26 (dues plans): membership_plans, subscriptions, payments
 *  - Chapter 27 (invitations): invitations
 *  - Chapter 28 (events): events, event_rsvps
 *  - Chapter 29 (real-time): event_checkins
 *  - Chapter 31 (audit log): audit_log
 *
 * Drill: the student adds each table in their own fork as they progress.
 * The reference here grows in lockstep with the course.
 *
 * All IDs are UUIDv7-friendly text columns. All timestamps are timestamptz.
 * All money columns (when they land in Ch 26) will be bigint integer cents.
 */

import {
  pgTable,
  text,
  timestamp,
  pgEnum,
  boolean,
  index,
} from "drizzle-orm/pg-core";

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

export const membershipRoleEnum = pgEnum("membership_role", [
  "admin",
  "manager",
  "member",
  "guest",
]);

// ---------------------------------------------------------------------------
// Tables — foundational
// ---------------------------------------------------------------------------

export const users = pgTable(
  "users",
  {
    id: text("id").primaryKey(), // UUIDv7
    email: text("email").notNull().unique(),
    name: text("name").notNull(),
    emailVerifiedAt: timestamp("email_verified_at", { withTimezone: true }),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    deletedAt: timestamp("deleted_at", { withTimezone: true }),
  },
  (t) => ({
    emailIdx: index("users_email_idx").on(t.email),
  }),
);

export const organizations = pgTable(
  "organizations",
  {
    id: text("id").primaryKey(), // UUIDv7
    name: text("name").notNull(),
    slug: text("slug").notNull().unique(),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    deletedAt: timestamp("deleted_at", { withTimezone: true }),
  },
  (t) => ({
    slugIdx: index("organizations_slug_idx").on(t.slug),
  }),
);

export const memberships = pgTable(
  "memberships",
  {
    id: text("id").primaryKey(), // UUIDv7
    userId: text("user_id")
      .notNull()
      .references(() => users.id, { onDelete: "cascade" }),
    organizationId: text("organization_id")
      .notNull()
      .references(() => organizations.id, { onDelete: "cascade" }),
    role: membershipRoleEnum("role").notNull().default("member"),
    isActive: boolean("is_active").notNull().default(true),
    joinedAt: timestamp("joined_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    createdAt: timestamp("created_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    updatedAt: timestamp("updated_at", { withTimezone: true })
      .notNull()
      .defaultNow(),
    deletedAt: timestamp("deleted_at", { withTimezone: true }),
  },
  (t) => ({
    userOrgIdx: index("memberships_user_org_idx").on(t.userId, t.organizationId),
    orgRoleIdx: index("memberships_org_role_idx").on(t.organizationId, t.role),
  }),
);

// ---------------------------------------------------------------------------
// Tables — added in later chapters
// ---------------------------------------------------------------------------

// Chapter 26 (dues plans): membership_plans, subscriptions, payments
// Chapter 27 (invitations): invitations
// Chapter 28 (events): events, event_rsvps
// Chapter 29 (real-time): event_checkins
// Chapter 30 (AI search): no new tables; uses existing data
// Chapter 31 (audit log): audit_log

// As you complete each chapter's drill, add the corresponding table here
// in your student/canonical-project/db/schema.ts. The reference grows
// chapter-by-chapter; your build mirrors it.
