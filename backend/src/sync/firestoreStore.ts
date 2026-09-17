import type { CollectionReference, DocumentData, Firestore, Timestamp } from "firebase-admin/firestore";
import type {
  BackendStore,
  FixtureRecord,
  LeagueRecord,
  PredictionRecord,
  RoundRecord,
  StandingEntry,
} from "./types";
import type { PredictionOutcome } from "../scoring/points";

const ACTIVE_STATUSES = ["open", "locked"];

export function createFirestoreStore(db: Firestore): BackendStore {
  return {
    async getActiveRounds() {
      const snapshot = await db
        .collection("rounds")
        .where("status", "in", ACTIVE_STATUSES)
        .get();
      return snapshot.docs.map((doc) => toRound(doc.id, doc.data()));
    },

    async getRoundsByLeagueIds(leagueIds) {
      const rounds: RoundRecord[] = [];
      for (const ids of chunk([...new Set(leagueIds)], 10)) {
        if (ids.length === 0) {
          continue;
        }
        const snapshot = await db.collection("rounds").where("leagueId", "in", ids).get();
        for (const doc of snapshot.docs) {
          rounds.push(toRound(doc.id, doc.data()));
        }
      }
      return rounds;
    },

    async getFixturesByIds(ids) {
      const fixtures: FixtureRecord[] = [];
      for (const group of chunk([...new Set(ids)], 10)) {
        if (group.length === 0) {
          continue;
        }
        const refs = group.map((id) => db.collection("fixtures").doc(id));
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

    async getPredictionsByRoundIds(roundIds) {
      const predictions: PredictionRecord[] = [];
      for (const ids of chunk([...new Set(roundIds)], 10)) {
        if (ids.length === 0) {
          continue;
        }
        const snapshot = await db.collection("predictions").where("roundId", "in", ids).get();
        for (const doc of snapshot.docs) {
          predictions.push(toPrediction(doc.id, doc.data()));
        }
      }
      return predictions;
    },

    async updatePredictionPoints(id, points) {
      await db.collection("predictions").doc(id).update({ points });
    },

    async getLeaguesByIds(ids) {
      const leagues: LeagueRecord[] = [];
      for (const group of chunk([...new Set(ids)], 10)) {
        if (group.length === 0) {
          continue;
        }
        const refs = group.map((id) => db.collection("leagues").doc(id));
        const docs = await db.getAll(...refs);
        for (const doc of docs) {
          if (!doc.exists) {
            continue;
          }
          const standings = await doc.ref.collection("standings").get();
          const nicknames: Record<string, string> = {};
          for (const standing of standings.docs) {
            const nickname = standing.data().nickname;
            if (typeof nickname === "string" && nickname.length > 0) {
              nicknames[standing.id] = nickname;
            }
          }
          leagues.push(toLeague(doc.id, doc.data() ?? {}, nicknames));
        }
      }
      return leagues;
    },

    async replaceRoundStandings(roundId, entries) {
      await replaceStandings(db.collection("rounds").doc(roundId).collection("standings"), entries);
    },

    async replaceSeasonStandings(leagueId, entries, seasonPoints) {
      await db.collection("leagues").doc(leagueId).update({ seasonPoints });
      await replaceStandings(db.collection("leagues").doc(leagueId).collection("standings"), entries);
    },
  };
}

async function replaceStandings(
  collection: CollectionReference<DocumentData>,
  entries: StandingEntry[],
): Promise<void> {
  const existing = await collection.get();
  const keep = new Set(entries.map((entry) => entry.userId));
  for (const doc of existing.docs) {
    if (!keep.has(doc.id)) {
      await doc.ref.delete();
    }
  }
  for (const entry of entries) {
    await collection.doc(entry.userId).set({
      userId: entry.userId,
      nickname: entry.nickname,
      points: entry.points,
      rank: entry.rank,
    });
  }
}

function toRound(id: string, data: DocumentData): RoundRecord {
  return {
    id,
    leagueId: String(data.leagueId ?? ""),
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

function toPrediction(id: string, data: DocumentData): PredictionRecord {
  return {
    id,
    userId: String(data.userId ?? ""),
    roundId: String(data.roundId ?? ""),
    fixtureId: String(data.fixtureId ?? ""),
    outcome: asOutcome(data.outcome),
    homeGoals: Number(data.homeGoals ?? 0),
    awayGoals: Number(data.awayGoals ?? 0),
    points: asNullableNumber(data.points),
  };
}

function toLeague(
  id: string,
  data: DocumentData,
  nicknames: Record<string, string>,
): LeagueRecord {
  const seasonPoints: Record<string, number> = {};
  if (data.seasonPoints && typeof data.seasonPoints === "object") {
    for (const [userId, value] of Object.entries(data.seasonPoints as Record<string, unknown>)) {
      if (typeof value === "number") {
        seasonPoints[userId] = value;
      }
    }
  }
  return {
    id,
    members: Array.isArray(data.members) ? data.members.map(String) : [],
    seasonPoints,
    nicknames,
  };
}

function asOutcome(value: unknown): PredictionOutcome {
  return value === "away" || value === "draw" || value === "home" ? value : "home";
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
