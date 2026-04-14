"use client";

import DashboardTable, {
  type DashboardPlanRow,
} from "@/app/components/DashboardTable";
import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged } from "firebase/auth";
import Link from "next/link";
import { useEffect, useState } from "react";

export default function DashboardPage() {
  const [userName, setUserName] = useState("Student");
  const [tableRows, setTableRows] = useState<DashboardPlanRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (user) => {
      if (!user) {
        setUserName("Student");
        setTableRows([]);
        setLoading(false);
        return;
      }

      const displayName = user.displayName?.trim();
      const emailPrefix = user.email?.split("@")[0]?.trim();
      const name = displayName || emailPrefix || "Student";
      setUserName(name);

      try {
        setLoading(true);
        setError("");

        const idToken = await user.getIdToken();

        const response = await fetch("/api/plans", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${idToken}`,
          },
          body: JSON.stringify({
            google_uid: user.uid,
          }),
        });

        const data = await response.json();

        if (!response.ok) {
          throw new Error(data.error || "Failed to load plans.");
        }

        setTableRows(data.plans || []);
      } catch (err) {
        console.error("Error loading dashboard plans:", err);
        setError(err instanceof Error ? err.message : "Failed to load plans.");
        setTableRows([]);
      } finally {
        setLoading(false);
      }
    });

    return () => unsubscribe();
  }, []);

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-8 sm:px-6 sm:py-10 lg:px-8">
          <div className="mx-auto w-full max-w-6xl space-y-6">
            <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
              <p className="text-xs uppercase tracking-[0.2em] text-cyan-700">
                Welcome back, {userName}
              </p>
              <h1 className="mt-2 text-3xl font-bold text-slate-900 sm:text-4xl">
                Your Plans
              </h1>
              <p className="mt-3 max-w-3xl text-sm leading-7 text-slate-600 sm:text-base">
                Keep track of your plan requests here. Mark courses as you go
                and request a new plan.
              </p>
              <div className="mt-5">
                <Link
                  href="/completed-courses"
                  className="inline-flex items-center rounded-lg border border-cyan-300 bg-cyan-50 px-4 py-2 text-sm font-semibold text-cyan-800 transition hover:bg-cyan-100"
                >
                  Manage Completed Courses
                </Link>
              </div>
            </section>

            {loading ? (
              <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                <p className="text-sm text-slate-600">Loading your plans...</p>
              </section>
            ) : error ? (
              <section className="rounded-2xl border border-red-200 bg-red-50 p-6 shadow-sm">
                <p className="text-sm text-red-700">{error}</p>
              </section>
            ) : (
              <DashboardTable rows={tableRows} />
            )}
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
