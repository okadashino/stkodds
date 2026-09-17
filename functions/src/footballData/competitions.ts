export const ALLOWED_COMPETITIONS = ["PL", "PD", "BL1", "SA", "FL1", "CL"] as const;

export type AllowedCompetition = (typeof ALLOWED_COMPETITIONS)[number];

export function isAllowedCompetition(code: string): code is AllowedCompetition {
  return (ALLOWED_COMPETITIONS as readonly string[]).includes(code);
}
