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
}

export interface FixturePatch {
  status: FootballMatchDto["status"];
  homeScore: number | null;
  awayScore: number | null;
}

export interface PredictionRecord {
  id: string;
  userId: string;
  roundId: string;
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
  getRoundsByLeagueIds(leagueIds: string[]): Promise<RoundRecord[]>;
  getFixturesByIds(ids: string[]): Promise<FixtureRecord[]>;
  updateFixture(id: string, patch: FixturePatch): Promise<void>;
  getPredictionsByRoundIds(roundIds: string[]): Promise<PredictionRecord[]>;
  updatePredictionPoints(id: string, points: number): Promise<void>;
  getLeaguesByIds(ids: string[]): Promise<LeagueRecord[]>;
  replaceRoundStandings(roundId: string, entries: StandingEntry[]): Promise<void>;
  replaceSeasonStandings(
    leagueId: string,
    entries: StandingEntry[],
    seasonPoints: Record<string, number>,
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
}
