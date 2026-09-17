import type { StandingEntry } from "../sync/types";

export function rankStandings(
  pointsByUser: Map<string, number>,
  nicknames: Record<string, string>,
): StandingEntry[] {
  return [...pointsByUser.entries()]
    .map(([userId, points]) => ({
      userId,
      nickname: nicknames[userId] || userId,
      points,
      rank: 0,
    }))
    .sort((a, b) => b.points - a.points || a.userId.localeCompare(b.userId))
    .map((entry, index) => ({ ...entry, rank: index + 1 }));
}
