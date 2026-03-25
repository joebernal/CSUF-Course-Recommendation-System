const SESSION_COOKIE_NAME = "tuffy_session";
const ONE_DAY_IN_SECONDS = 60 * 60 * 24;

export function setClientSessionCookie() {
  if (typeof document === "undefined") {
    return;
  }

  document.cookie = `${SESSION_COOKIE_NAME}=1; Path=/; Max-Age=${ONE_DAY_IN_SECONDS}; SameSite=Lax`;
}

export function clearClientSessionCookie() {
  if (typeof document === "undefined") {
    return;
  }

  document.cookie = `${SESSION_COOKIE_NAME}=; Path=/; Max-Age=0; SameSite=Lax`;
}

export { SESSION_COOKIE_NAME };