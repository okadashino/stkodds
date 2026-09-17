export type PredictionOutcome = "home" | "draw" | "away";

export interface Scoreline {
  homeScore: number | null;
  awayScore: number | null;
}

export interface ScorePredictionInput {
  outcome: PredictionOutcome;
  homeGoals: number;
  awayGoals: number;
}

export function outcomeFromScore(home: number, away: number): PredictionOutcome {
  if (home > away) {
    return "home";
  }
  if (home < away) {
    return "away";
  }
  return "draw";
}

export function scorePrediction(prediction: ScorePredictionInput, actual: Scoreline): number {
  if (actual.homeScore == null || actual.awayScore == null) {
    return 0;
  }
  if (prediction.homeGoals === actual.homeScore && prediction.awayGoals === actual.awayScore) {
    return 3;
  }
  if (prediction.outcome !== outcomeFromScore(actual.homeScore, actual.awayScore)) {
    return 0;
  }
  const predictedDifference = prediction.homeGoals - prediction.awayGoals;
  const actualDifference = actual.homeScore - actual.awayScore;
  return predictedDifference === actualDifference ? 2 : 1;
}
