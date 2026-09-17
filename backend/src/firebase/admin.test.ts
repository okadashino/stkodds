import { describe, expect, it, vi } from "vitest";
import { initFirebaseAdmin, MissingServiceAccountError } from "./admin";

const serviceAccount = {
  type: "service_account",
  project_id: "stkodds",
  client_email: "sync@stkodds.iam.gserviceaccount.com",
  private_key: "-----BEGIN PRIVATE KEY-----\nfake\n-----END PRIVATE KEY-----\n",
};

describe("initFirebaseAdmin", () => {
  it("initializes firebase-admin from FIREBASE_SERVICE_ACCOUNT JSON", () => {
    vi.stubEnv("FIREBASE_SERVICE_ACCOUNT", JSON.stringify(serviceAccount));
    const credential = { kind: "sa" };
    const cert = vi.fn().mockReturnValue(credential);
    const initializeApp = vi.fn().mockReturnValue({ name: "[DEFAULT]" });

    const app = initFirebaseAdmin({ cert, initializeApp });

    expect(cert).toHaveBeenCalledWith(serviceAccount);
    expect(initializeApp).toHaveBeenCalledWith({ credential });
    expect(app).toEqual({ name: "[DEFAULT]" });
    vi.unstubAllEnvs();
  });

  it("throws when FIREBASE_SERVICE_ACCOUNT is missing or invalid JSON", () => {
    const deps = { cert: vi.fn(), initializeApp: vi.fn() };
    delete process.env.FIREBASE_SERVICE_ACCOUNT;
    expect(() => initFirebaseAdmin(deps)).toThrow(MissingServiceAccountError);

    vi.stubEnv("FIREBASE_SERVICE_ACCOUNT", "{not-json");
    expect(() => initFirebaseAdmin(deps)).toThrow(MissingServiceAccountError);
    expect(deps.cert).not.toHaveBeenCalled();
    vi.unstubAllEnvs();
  });
});
