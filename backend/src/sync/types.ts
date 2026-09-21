import type { FootballMatchDto } from "../footballData/mapMatch";
import type { PredictionOutcome } from "../scoring/points";

export interface RoundRecord {
  id: string;
  leagueId: string;
  type: string;
  competitionCodes: string[];
  matchday?: number | null;
  dateFrom: Date;
  dateTo: Date;
  fixtureIds: string[];
  status: string;
}

export interface FixtureRecord {
  id: string;
  apiId: number;
  status: string;
  homeScore: number | null;
  awayScore: number | null;
  kickoff: string;
}

export interface FixtureDocument extends FixtureRecord {
  competition: string;
  matchday: number;
  homeTeam: string;
  awayTeam: string;
}

export interface FixturePatch {
  status: FootballMatchDto["status"];
  homeScore: number | null;
  awayScore: number | null;
}

export interface PredictionRecord {
  id: string;
  userId: string;
  fixtureId: string;
  outcome: PredictionOutcome;
  homeGoals: number;
  awayGoals: number;
  points: number | null;
}

export interface StandingEntry {
  userId: string;
  nickname: string;
  points: number;
  rank: number;
}

export interface LeagueRecord {
  id: string;
  members: string[];
  seasonPoints: Record<string, number>;
  nicknames: Record<string, string>;
}

export interface BackendStore {
  getActiveRounds(): Promise<RoundRecord[]>;
  getLeagues(): Promise<LeagueRecord[]>;
  getRoundsByLeagueIds(leagueIds: string[]): Promise<RoundRecord[]>;
  getFixturesByIds(ids: string[]): Promise<FixtureRecord[]>;
  upsertFixture(fixture: FixtureDocument): Promise<void>;
  updateFixture(id: string, patch: FixturePatch): Promise<void>;
  getPredictionsByFixtureIds(fixtureIds: string[]): Promise<PredictionRecord[]>;
  updatePredictionPoints(id: string, points: number): Promise<void>;
  getLeaguesByIds(ids: string[]): Promise<LeagueRecord[]>;
  replaceRoundStandings(roundId: string, entries: StandingEntry[]): Promise<void>;
  replaceSeasonStandings(
    leagueId: string,
    entries: StandingEntry[],
    seasonPoints: Record<string, number>,
  ): Promise<void>;
  replaceMonthStandings(
    leagueId: string,
    yearMonth: string,
    entries: StandingEntry[],
  ): Promise<void>;
}

export interface SyncLogger {
  info(message: string): void;
  warn(message: string): void;
}

export interface RunSummary {
  fixturesUpdated: number;
  fixturesFinished: number;
  predictionsScored: number;
  roundStandingsUpdated: number;
  seasonStandingsUpdated: number;
  monthStandingsUpdated: number;
}
