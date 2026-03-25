import type { User } from "firebase/auth";

type SyncUserOptions = {
  fullName?: string;
};

export async function syncUserToApi(user: User, options?: SyncUserOptions) {
  const idToken = await user.getIdToken();
  const email = user.email ?? "";
  const fullName = options?.fullName ?? user.displayName ?? "";

  const response = await fetch("/api/users/sync", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${idToken}`,
    },
    body: JSON.stringify({
      email,
      google_uid: user.uid,
      full_name: fullName,
    }),
  });

  if (response.ok) {
    return;
  }

  let message = `User sync failed with status ${response.status}.`;

  try {
    const data = (await response.json()) as { error?: string; message?: string };
    const apiMessage = data.error ?? data.message;

    if (apiMessage) {
      message = apiMessage;

      if (response.status === 400 && /already exists/i.test(apiMessage)) {
        return;
      }
    }
  } catch {
    // Keep generic message when response body is not JSON.
  }

  throw new Error(message);
}
