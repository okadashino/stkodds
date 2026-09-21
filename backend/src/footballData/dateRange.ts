export const FOOTBALL_DATA_CHUNK_DAYS = 9;

export function utcDateOffset(now: Date, days: number): string {
  const date = new Date(
    Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + days),
  );
  return date.toISOString().slice(0, 10);
}

export function dateRangeChunks(
  from: string,
  to: string,
  maxDays = FOOTBALL_DATA_CHUNK_DAYS,
): Array<[string, string]> {
  if (from > to) {
    return [];
  }
  const chunks: Array<[string, string]> = [];
  let cursor = from;
  while (cursor <= to) {
    const chunkEnd = minIsoDate(addIsoDays(cursor, maxDays - 1), to);
    chunks.push([cursor, chunkEnd]);
    cursor = addIsoDays(chunkEnd, 1);
  }
  return chunks;
}

function addIsoDays(isoDate: string, days: number): string {
  return utcDateOffset(new Date(`${isoDate}T00:00:00.000Z`), days);
}

function minIsoDate(left: string, right: string): string {
  return left <= right ? left : right;
}
