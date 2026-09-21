import { describe, expect, it } from "vitest";
import { nicknamesFromUsers } from "./nicknames";

describe("nicknamesFromUsers", () => {
  it("uses the profile nickname instead of the user id", () => {
    expect(
      nicknamesFromUsers([
        { id: "longFirebaseUid", nickname: "  jack  " },
        { id: "u2", nickname: "" },
        { id: "u3" },
      ]),
    ).toEqual({ longFirebaseUid: "jack" });
  });
});
