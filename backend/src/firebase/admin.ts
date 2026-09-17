import {
  cert as defaultCert,
  initializeApp as defaultInitializeApp,
  type App,
  type Credential,
  type ServiceAccount,
} from "firebase-admin/app";

const SERVICE_ACCOUNT_ENV = "FIREBASE_SERVICE_ACCOUNT";

export class MissingServiceAccountError extends Error {
  constructor() {
    super(`${SERVICE_ACCOUNT_ENV} is missing or is not valid JSON`);
    this.name = "MissingServiceAccountError";
  }
}

export interface FirebaseAdminDeps {
  cert?: (serviceAccount: ServiceAccount) => Credential;
  initializeApp?: (options: { credential: Credential }) => App;
  serviceAccountJson?: string;
}

export function initFirebaseAdmin(deps: FirebaseAdminDeps = {}): App {
  const raw = deps.serviceAccountJson ?? process.env[SERVICE_ACCOUNT_ENV];
  if (!raw?.trim()) {
    throw new MissingServiceAccountError();
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    throw new MissingServiceAccountError();
  }

  if (!isServiceAccount(parsed)) {
    throw new MissingServiceAccountError();
  }

  const credential = (deps.cert ?? defaultCert)(parsed);
  return (deps.initializeApp ?? defaultInitializeApp)({ credential });
}

function isServiceAccount(value: unknown): value is ServiceAccount {
  return Boolean(value) && typeof value === "object";
}
