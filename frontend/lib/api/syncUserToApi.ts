import type { User } from "firebase/auth";

type SyncUserOptions = {
  fullName?: string;
};

export async function syncUserToApi(user: User, options?: SyncUserOptions) {
  console.log("syncUserToApi started");

  const idToken = await user.getIdToken();
  console.log("Got idToken");

  const email = user.email ?? "";
  const fullName = options?.fullName ?? user.displayName ?? "";

  const payload = {
    email,
    google_uid: user.uid,
    full_name: fullName,
  };

  console.log("Sending payload to /api/users/sync:", payload);

  const response = await fetch("/api/users/sync", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${idToken}`,
    },
    body: JSON.stringify(payload),
  });

  console.log("sync response status:", response.status);

  if (response.ok) {
    console.log("syncUserToApi success");
    return;
  }

  let message = `User sync failed with status ${response.status}.`;

  try {
    const data = (await response.json()) as {
      error?: string;
      message?: string;
    };
    console.log("sync response body:", data);

    const apiMessage = data.error ?? data.message;

    if (apiMessage) {
      message = apiMessage;

      if (response.status === 400 && /already exists/i.test(apiMessage)) {
        return;
      }
    }
  } catch (err) {
    console.log("Could not parse error JSON:", err);
  }

  throw new Error(message);
}
