import Link from "next/link";
import { notFound } from "next/navigation";

import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import SemesterCoursesTable, { type PlanCourse } from "@/app/components/SemesterCoursesTable";

type SemesterPlan = {
  semester: string;
  courses: PlanCourse[];
};

type PlanDetails = {
  id: string;
  planName: string;
  catalogYear: string;
  dateRequested: string;
  enrollmentStatus: "Full Time" | "Part Time";
  major: string;
  semesters: SemesterPlan[];
};

const planDetailsById: Record<string, PlanDetails> = {
  "1": {
    id: "1",
    planName: "Plan A",
    catalogYear: "Spring 2022",
    dateRequested: "2024-06-10",
    enrollmentStatus: "Full Time",
    major: "Computer Science",
    semesters: [
      {
        semester: "Fall 2026",
        courses: [
          { code: "CPSC 335", title: "Algorithm Engineering", units: 3, isCompleted: true },
          { code: "CPSC 351", title: "Operating Systems", units: 3 },
          { code: "MATH 338", title: "Statistics for Engineers", units: 3, isCompleted: true },
        ],
      },
      {
        semester: "Spring 2027",
        courses: [
          { code: "CPSC 449", title: "Web Back-End Engineering", units: 3 },
          { code: "CPSC 471", title: "Computer Communications", units: 3 },
          { code: "CPSC 386", title: "Game Design and Production", units: 3 },
        ],
      },
    ],
  },
  "2": {
    id: "2",
    planName: "Plan B",
    catalogYear: "Fall 2026",
    dateRequested: "2024-06-12",
    enrollmentStatus: "Part Time",
    major: "Computer Science",
    semesters: [
      {
        semester: "Fall 2026",
        courses: [
          { code: "CPSC 353", title: "Intro to Computer Security", units: 3 },
          { code: "CPSC 471", title: "Computer Communications", units: 3, isCompleted: true },
        ],
      },
      {
        semester: "Spring 2027",
        courses: [
          { code: "CPSC 481", title: "Artificial Intelligence", units: 3 },
          { code: "CPSC 491", title: "Senior Project", units: 3 },
        ],
      },
    ],
  },
};

export default async function PlanDetailsPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const details = planDetailsById[id];

  if (!details) {
    notFound();
  }

  const totalUnits = details.semesters.reduce(
    (sum, semester) => sum + semester.courses.reduce((courseSum, course) => courseSum + course.units, 0),
    0
  );

  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-8 sm:px-6 sm:py-10 lg:px-8">
          <div className="mx-auto w-full max-w-6xl space-y-6">
            <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
              <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                <div>
                  <p className="text-xs uppercase tracking-[0.2em] text-cyan-700">Plan Details</p>
                  <h1 className="mt-2 text-3xl font-bold text-slate-900 sm:text-4xl">
                    {details.planName}
                  </h1>
                  <p className="mt-2 text-sm text-slate-600">Plan ID: {details.id}</p>
                </div>

                <div className="flex items-center gap-2">
                  <Link
                    href="/dashboard"
                    className="rounded-lg border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50"
                  >
                    Back to Plans
                  </Link>
                  <Link
                    href="/request"
                    className="rounded-lg bg-slate-900 px-4 py-2 text-sm font-semibold text-white transition hover:bg-slate-700"
                  >
                    Request New Plan
                  </Link>
                </div>
              </div>

              <div className="mt-6 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">Catalog Year</p>
                  <p className="mt-2 text-base font-semibold text-slate-900">{details.catalogYear}</p>
                </article>
                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">Date Requested</p>
                  <p className="mt-2 text-base font-semibold text-slate-900">{details.dateRequested}</p>
                </article>
                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">Enrollment</p>
                  <p className="mt-2 text-base font-semibold text-slate-900">{details.enrollmentStatus}</p>
                </article>
                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">Total Units</p>
                  <p className="mt-2 text-base font-semibold text-slate-900">{totalUnits}</p>
                </article>
              </div>
            </section>

            <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
              <div className="mb-4 flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-900">Semester Breakdown</h2>
                <p className="text-sm text-slate-600">Major: {details.major}</p>
              </div>

              <div className="space-y-5">
                {details.semesters.map((semester, index) => (
                  <article key={semester.semester} className="rounded-xl border border-slate-200">
                    <header className="flex items-center justify-between border-b border-slate-200 bg-slate-50 px-4 py-3">
                      <h3 className="text-sm font-semibold text-slate-900">
                        {index + 1}. {semester.semester}
                      </h3>
                      <span className="text-xs text-slate-500">
                        {semester.courses.reduce((sum, course) => sum + course.units, 0)} units
                      </span>
                    </header>

                    <SemesterCoursesTable
                      planId={details.id}
                      semester={semester.semester}
                      courses={semester.courses}
                    />
                  </article>
                ))}
              </div>
            </section>
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
