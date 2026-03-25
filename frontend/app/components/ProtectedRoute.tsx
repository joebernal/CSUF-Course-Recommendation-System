"use client";

import { clearClientSessionCookie, setClientSessionCookie } from "@/lib/auth/clientSession";
import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged } from "firebase/auth";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useEffect, useState, type ReactNode } from "react";

type ProtectedRouteProps = {
  children: ReactNode;
};

export default function ProtectedRoute({ children }: ProtectedRouteProps) {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [isAuthorized, setIsAuthorized] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (!user) {
        clearClientSessionCookie();

        const loginUrl = new URL("/login", window.location.origin);
        const nextPath = `${pathname}${searchParams.size > 0 ? `?${searchParams.toString()}` : ""}`;
        loginUrl.searchParams.set("next", nextPath);

        router.replace(`${loginUrl.pathname}${loginUrl.search}`);
        return;
      }

      setClientSessionCookie();
      setIsAuthorized(true);
    });

    return () => unsubscribe();
  }, [pathname, router, searchParams]);

  if (!isAuthorized) {
    return (
      <main className="flex-1 px-4 py-10 sm:px-6 sm:py-14 lg:px-8">
        <div className="mx-auto w-full max-w-6xl rounded-2xl border border-slate-200 bg-white p-6 text-sm text-slate-600 shadow-sm sm:p-8">
          Verifying your session...
        </div>
      </main>
    );
  }

  return <>{children}</>;
}