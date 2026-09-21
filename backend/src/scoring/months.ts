export function utcYearMonth(value: Date | string): string {
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) {
    return "";
  }
  return `${date.getUTCFullYear()}-${String(date.getUTCMonth() + 1).padStart(2, "0")}`;
}

export function monthScopeId(yearMonth: string): string {
  return yearMonth.startsWith("month_") ? yearMonth : `month_${yearMonth}`;
}
