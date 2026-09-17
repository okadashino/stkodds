export interface Throttle {
  acquire(): Promise<void>;
}

export class MinuteThrottle implements Throttle {
  constructor(
    private readonly maxRequests = 10,
    private readonly windowMs = 60_000,
    private readonly sleep: (ms: number) => Promise<void> = delay,
    private readonly now: () => number = () => Date.now(),
  ) {}

  private timestamps: number[] = [];

  async acquire(): Promise<void> {
    for (;;) {
      const now = this.now();
      this.timestamps = this.timestamps.filter((stamp) => now - stamp < this.windowMs);
      if (this.timestamps.length < this.maxRequests) {
        this.timestamps.push(now);
        return;
      }
      const oldest = this.timestamps[0] ?? now;
      await this.sleep(Math.max(this.windowMs - (now - oldest), 0));
    }
  }
}

export function delay(ms: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}
