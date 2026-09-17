import { getFirestore } from "firebase-admin/firestore";
import { logger } from "firebase-functions";
import { defineSecret } from "firebase-functions/params";
import { onSchedule } from "firebase-functions/v2/scheduler";
import { FootballDataClient } from "../footballData/client";
import { createFirestoreFixtureStore } from "./firestoreStore";
import { syncActiveRoundFixtures } from "./syncActiveFixtures";

export const footballDataApiKey = defineSecret("FOOTBALL_DATA_API_KEY");

export const syncLiveFixtures = onSchedule(
  {
    schedule: "every 15 minutes",
    timeZone: "Etc/UTC",
    region: "asia-northeast1",
    secrets: [footballDataApiKey],
    timeoutSeconds: 540,
    memory: "256MiB",
  },
  async () => {
    const updated = await syncActiveRoundFixtures({
      store: createFirestoreFixtureStore(getFirestore()),
      client: new FootballDataClient({ apiKey: footballDataApiKey.value() }),
      logger,
    });
    logger.debug("syncLiveFixtures completed", { updated });
  },
);
