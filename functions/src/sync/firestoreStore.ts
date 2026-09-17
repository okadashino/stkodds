import type { DocumentData, Firestore, Timestamp } from "firebase-admin/firestore";
import type { FixtureRecord, FixtureStore, RoundRecord } from "./types";

const ACTIVE_STATUSES = ["open", "locked"];

export function createFirestoreFixtureStore(db: Firestore): FixtureStore {
  return {
    async getActiveRounds() {
      const snapshot = await db
        .collection("rounds")
        .where("status", "in", ACTIVE_STATUSES)
        .get();
      return snapshot.docs.map((doc) => toRound(doc.id, doc.data()));
    },

    async getFixturesByIds(ids) {
      const uniqueIds = [...new Set(ids)];
      const fixtures: FixtureRecord[] = [];
      for (const chunkIds of chunk(uniqueIds, 10)) {
        const refs = chunkIds.map((id) => db.collection("fixtures").doc(id));
        const docs = await db.getAll(...refs);
        for (const doc of docs) {
          if (doc.exists) {
            fixtures.push(toFixture(doc.id, doc.data() ?? {}));
          }
        }
      }
      return fixtures;
    },

    async updateFixture(id, patch) {
      await db.collection("fixtures").doc(id).update({
        status: patch.status,
        homeScore: patch.homeScore,
        awayScore: patch.awayScore,
      });
    },
  };
}

function toRound(id: string, data: DocumentData): RoundRecord {
  return {
    id,
    type: String(data.type ?? ""),
    competitionCodes: Array.isArray(data.competitionCodes)
      ? data.competitionCodes.map(String)
      : [],
    matchday: typeof data.matchday === "number" ? data.matchday : null,
    dateFrom: asDate(data.dateFrom),
    dateTo: asDate(data.dateTo),
    fixtureIds: Array.isArray(data.fixtureIds) ? data.fixtureIds.map(String) : [],
    status: String(data.status ?? ""),
  };
}

function toFixture(id: string, data: DocumentData): FixtureRecord {
  return {
    id,
    apiId: Number(data.apiId),
    status: String(data.status ?? ""),
    homeScore: asNullableNumber(data.homeScore),
    awayScore: asNullableNumber(data.awayScore),
  };
}

function asDate(value: unknown): Date {
  if (value instanceof Date) {
    return value;
  }
  if (value && typeof value === "object" && "toDate" in value) {
    return (value as Timestamp).toDate();
  }
  if (typeof value === "string" || typeof value === "number") {
    return new Date(value);
  }
  return new Date(0);
}

function asNullableNumber(value: unknown): number | null {
  return typeof value === "number" ? value : null;
}

function chunk<T>(items: T[], size: number): T[][] {
  const groups: T[][] = [];
  for (let i = 0; i < items.length; i += size) {
    groups.push(items.slice(i, i + size));
  }
  return groups;
}
