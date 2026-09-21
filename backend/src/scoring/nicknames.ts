export function nicknamesFromUsers(
  users: Array<{ id: string; nickname?: unknown }>,
): Record<string, string> {
  const nicknames: Record<string, string> = {};
  for (const user of users) {
    if (typeof user.nickname !== "string") {
      continue;
    }
    const nickname = user.nickname.trim();
    if (nickname.length === 0) {
      continue;
    }
    nicknames[user.id] = nickname;
  }
  return nicknames;
}
