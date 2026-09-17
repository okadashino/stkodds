import { describe, expect, it, vi } from "vitest";
import { MinuteThrottle } from "./throttle";

describe("MinuteThrottle", () => {
  it("allows 10 requests then waits for the 60s window", async () => {
    let releaseSleep: () => void = () => undefined;
    const sleep = vi.fn().mockImplementation(
      () =>
        new Promise<void>((resolve) => {
          releaseSleep = resolve;
        }),
    );
    let now = 1_000;
    const throttle = new MinuteThrottle(10, 60_000, sleep, () => now);

    for (let i = 0; i < 10; i += 1) {
      await throttle.acquire();
    }
    expect(sleep).not.toHaveBeenCalled();

    const eleventh = throttle.acquire();
    await vi.waitFor(() => {
      expect(sleep).toHaveBeenCalledWith(60_000);
    });

    now = 61_000;
    releaseSleep();
    await eleventh;
  });
});
