import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions/v2";

initializeApp();
setGlobalOptions({
  region: "asia-northeast1",
  maxInstances: 10,
});

export { FootballDataClient } from "./footballData/client";
export { syncLiveFixtures } from "./sync/scheduled";
