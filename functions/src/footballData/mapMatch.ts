export interface FootballMatchDto {
  apiId: number;
  competition: string;
  matchday: number | null;
  homeTeam: string;
  awayTeam: string;
  kickoff: string;
  status: "scheduled" | "live" | "finished" | "postponed" | "cancelled";
  homeScore: number | null;
  awayScore: number | null;
}

export interface FootballDataMatch {
  id: number;
  utcDate: string;
  status: string;
  matchday?: number | null;
  competition?: { code?: string | null } | null;
  homeTeam?: { name?: string | null; shortName?: string | null } | null;
  awayTeam?: { name?: string | null; shortName?: string | null } | null;
  score?: {
    fullTime?: { home?: number | null; away?: number | null } | null;
  } | null;
}

export function mapFootballMatch(
  match: FootballDataMatch,
  fallbackCompetition?: string,
): FootballMatchDto {
  return {
    apiId: match.id,
    competition: match.competition?.code ?? fallbackCompetition ?? "",
    matchday: match.matchday ?? null,
    homeTeam: teamName(match.homeTeam),
    awayTeam: teamName(match.awayTeam),
    kickoff: match.utcDate,
    status: mapStatus(match.status),
    homeScore: match.score?.fullTime?.home ?? null,
    awayScore: match.score?.fullTime?.away ?? null,
  };
}

function teamName(
  team?: { name?: string | null; shortName?: string | null } | null,
): string {
  return team?.shortName || team?.name || "";
}

function mapStatus(status: string): FootballMatchDto["status"] {
  switch (status) {
    case "SCHEDULED":
    case "TIMED":
      return "scheduled";
    case "IN_PLAY":
    case "PAUSED":
    case "LIVE":
      return "live";
    case "FINISHED":
    case "AWARDED":
      return "finished";
    case "POSTPONED":
      return "postponed";
    case "CANCELLED":
    case "SUSPENDED":
      return "cancelled";
    default:
      return "scheduled";
  }
}
