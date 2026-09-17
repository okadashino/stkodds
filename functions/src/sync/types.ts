import type { FootballMatchDto } from "../footballData/mapMatch";

export interface RoundRecord {
  id: string;
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

export interface FixtureStore {
  getActiveRounds(): Promise<RoundRecord[]>;
  getFixturesByIds(ids: string[]): Promise<FixtureRecord[]>;
  updateFixture(id: string, patch: FixturePatch): Promise<void>;
}

export interface SyncLogger {
  info(message: string): void;
  warn(message: string): void;
}
