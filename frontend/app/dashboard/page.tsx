"use client";

import DashboardTable, { type DashboardPlanRow } from "@/app/components/DashboardTable";
import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged } from "firebase/auth";
import { useEffect, useState } from "react";

const mockRows: DashboardPlanRow[] = [
  {
    id: "1",
    planName: "Plan A",
    catalogYear: "Spring 2022",
    dateRequested: "2024-06-10",
  },
  {
    id: "2",
    planName: "Plan B",
    catalogYear: "Fall 2026",
    dateRequested: "2024-06-12",
  },
  {
    id: "3",
    planName: "Fast Track Graduation",
    catalogYear: "Fall 2024",
    dateRequested: "2024-06-20",
  },
  {
    id: "4",
    planName: "Security Focus Path",
    catalogYear: "Spring 2025",
    dateRequested: "2024-07-03",
  },
  {
    id: "5",
    planName: "AI Elective Path",
    catalogYear: "Fall 2025",
    dateRequested: "2024-07-11",
  },
  {
    id: "6",
    planName: "Workload Balanced Plan",
    catalogYear: "Spring 2026",
    dateRequested: "2024-07-21",
  },
  {
    id: "7",
    planName: "Evening Class Plan",
    catalogYear: "Fall 2023",
    dateRequested: "2024-08-01",
  },
  {
    id: "8",
    planName: "Capstone Preparation",
    catalogYear: "Fall 2026",
    dateRequested: "2024-08-09",
  },
];

export default function DashboardPage() {
  const [userName, setUserName] = useState("Student");

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (!user) {
        setUserName("Student");
        return;
      }

      const displayName = user.displayName?.trim();
      const emailPrefix = user.email?.split("@")[0]?.trim();
      const name = displayName || emailPrefix || "Student";

      setUserName(name);
    });

    return () => unsubscribe();
  }, []);

  const tableRows = mockRows;

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-8 sm:px-6 sm:py-10 lg:px-8">
          <div className="mx-auto w-full max-w-6xl space-y-6">
            <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
              <p className="text-xs uppercase tracking-[0.2em] text-cyan-700">Welcome back, {userName}</p>
              <h1 className="mt-2 text-3xl font-bold text-slate-900 sm:text-4xl">
                Your Plans
              </h1>
              <p className="mt-3 max-w-3xl text-sm leading-7 text-slate-600 sm:text-base">
                Keep track of your plan requests here. Mark courses as you go and request a new plan.
              </p>
            </section>

            <DashboardTable rows={tableRows} />
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
