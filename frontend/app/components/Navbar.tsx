"use client";

import { clearClientSessionCookie, setClientSessionCookie } from "@/lib/auth/clientSession";
import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged, signOut } from "firebase/auth";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";


export default function Navbar() {
  const router = useRouter();
  const [isOpen, setIsOpen] = useState(false);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isCheckingAuth, setIsCheckingAuth] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setIsAuthenticated(Boolean(user));

      if (user) {
        setClientSessionCookie();
      } else {
        clearClientSessionCookie();
      }

      setIsCheckingAuth(false);
    });

    return () => unsubscribe();
  }, []);

  const handleLogout = async () => {
    await signOut(auth);
    clearClientSessionCookie();
    setIsOpen(false);
    router.push("/login");
  };

  return (
    <header className="sticky top-0 z-50 border-b border-[#0f4a80] bg-[#083b6f]">
      <div className="mx-auto flex h-16 w-full max-w-6xl items-center justify-between px-4 sm:px-6 lg:px-8">
        <Link
          href="/"
          className="text-4xl font-bold tracking-tight text-white transition hover:text-cyan-100"
        >
          Tuffy Plan
        </Link>

        <div className="hidden items-center gap-2 md:flex">

          {!isAuthenticated ? (
            <Link
            href="/about"
            className="rounded-full px-4 py-2 text-sm font-semibold text-white/90 transition hover:bg-white/10 hover:text-white"
          >
            About Us
          </Link>
          ) : null}
          {!isCheckingAuth && isAuthenticated ? (
            <Link
              href="/dashboard"
              className="rounded-full px-4 py-2 text-sm font-semibold text-white/90 transition hover:bg-white/10 hover:text-white"
            >
              Dashboard
            </Link>
          ) : null}
          {!isCheckingAuth && isAuthenticated ? (
            <Link
              href="/profile"
              className="rounded-full px-4 py-2 text-sm font-semibold text-white/90 transition hover:bg-white/10 hover:text-white"
            >
              Profile
            </Link>
          ) : null}
          {isCheckingAuth ? (
            <span className="rounded-full border border-white/60 px-4 py-2 text-sm font-semibold text-white/80">
              ...
            </span>
          ) : isAuthenticated ? (
            <button
              type="button"
              onClick={handleLogout}
              className="rounded-full border border-white/70 px-4 py-2 text-sm font-semibold text-white transition hover:bg-white/10"
            >
              Logout
            </button>
          ) : (
            <Link
              href="/login"
              className="inline-flex items-center gap-2 rounded-full border border-white/70 px-4 py-2 text-sm font-semibold text-white transition hover:bg-white/10"
            >
              <svg
                viewBox="0 0 24 24"
                className="h-4 w-4"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                aria-hidden="true"
              >
                <path d="M20 21a8 8 0 0 0-16 0" />
                <circle cx="12" cy="7" r="4" />
              </svg>
              Login
            </Link>
          )}
        </div>

        <button
          type="button"
          className="inline-flex h-10 w-10 items-center justify-center rounded-full border border-white/70 text-white md:hidden"
          onClick={() => setIsOpen((open) => !open)}
          aria-label="Toggle menu"
          aria-expanded={isOpen}
        >
          <svg
            viewBox="0 0 24 24"
            className="h-5 w-5"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            aria-hidden="true"
          >
            {isOpen ? (
              <path d="M6 18L18 6M6 6l12 12" />
            ) : (
              <path d="M4 7h16M4 12h16M4 17h16" />
            )}
          </svg>
        </button>
      </div>

      {isOpen ? (
        <div className="border-t border-[#0f4a80] bg-[#083b6f] px-4 pb-4 pt-3 md:hidden">
          <nav className="flex flex-col gap-2" aria-label="Mobile navigation">
           
            {!isCheckingAuth && isAuthenticated ? (
              <Link
                href="/dashboard"
                onClick={() => setIsOpen(false)}
                className="rounded-lg px-3 py-2 text-sm font-medium text-white/90 transition hover:bg-white/10 hover:text-white"
              >
                Dashboard
              </Link>
            ) : null}
            {isCheckingAuth ? (
              <span className="mt-1 rounded-lg border border-white/50 px-3 py-2 text-sm font-semibold text-white/80">
                ...
              </span>
            ) : isAuthenticated ? (
              <button
                type="button"
                onClick={handleLogout}
                className="mt-1 rounded-lg border border-white/70 px-3 py-2 text-sm font-semibold text-white"
              >
                Logout
              </button>
            ) : (
              <Link
                href="/login"
                onClick={() => setIsOpen(false)}
                className="mt-1 rounded-lg border border-white/70 px-3 py-2 text-sm font-semibold text-white"
              >
                Login
              </Link>
            )}
          </nav>
        </div>
      ) : null}
    </header>
  );
}