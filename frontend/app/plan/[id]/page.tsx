import Link from "next/link";
import { notFound } from "next/navigation";

import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import GraduationTimeline from "@/app/components/GraduationTimeline";
import SemesterCoursesTable, {
  type PlanCourse,
} from "@/app/components/SemesterCoursesTable";

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

type DegreeRequirement = {
  requirementName: string;
  requiredUnitsMin: number | null;
  note: string | null;
};

type DegreeRequirementsResponse = {
  requirements: DegreeRequirement[];
};

async function getPlanDetails(
  id: string,
  googleUid?: string,
): Promise<PlanDetails | null> {
  try {
    const query = googleUid
      ? `?google_uid=${encodeURIComponent(googleUid)}`
      : "";

    const response = await fetch(
      `http://localhost:3000/api/plans/${id}${query}`,
      {
        cache: "no-store",
      },
    );

    if (response.status === 404) {
      return null;
    }

    if (!response.ok) {
      throw new Error(`Failed to fetch plan details: ${response.status}`);
    }

    return (await response.json()) as PlanDetails;
  } catch (error) {
    console.error("getPlanDetails error:", error);
    return null;
  }
}

async function getDegreeRequirements(id: string): Promise<DegreeRequirement[]> {
  try {
    const baseUrl =
      process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:5001";

    const response = await fetch(
      `${baseUrl}/api/plans/${id}/degree-requirements`,
      {
        cache: "no-store",
      },
    );

    if (response.status === 404) {
      return [];
    }

    if (!response.ok) {
      throw new Error(
        `Failed to fetch degree requirements: ${response.status}`,
      );
    }

    const data = (await response.json()) as DegreeRequirementsResponse;
    return data.requirements || [];
  } catch (error) {
    console.error("getDegreeRequirements error:", error);
    return [];
  }
}

export default async function PlanDetailsPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<{ google_uid?: string }>;
}) {
  const { id } = await params;
  const { google_uid: googleUid } = await searchParams;
  const details = await getPlanDetails(id, googleUid);

  if (!details) {
    notFound();
  }

  const degreeRequirements = await getDegreeRequirements(id);

  const totalUnits = details.semesters.reduce(
    (sum, semester) =>
      sum +
      semester.courses.reduce(
        (courseSum, course) => courseSum + course.units,
        0,
      ),
    0,
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
                  <p className="text-xs uppercase tracking-[0.2em] text-cyan-700">
                    Plan Details
                  </p>
                  <h1 className="mt-2 text-3xl font-bold text-slate-900 sm:text-4xl">
                    {details.planName}
                  </h1>
                  <p className="mt-2 text-sm text-slate-600">
                    Plan ID: {details.id}
                  </p>
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
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">
                    Catalog Year
                  </p>
                  <p className="mt-2 text-base font-semibold text-slate-900">
                    {details.catalogYear}
                  </p>
                </article>

                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">
                    Date Requested
                  </p>
                  <p className="mt-2 text-base font-semibold text-slate-900">
                    {details.dateRequested}
                  </p>
                </article>

                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">
                    Enrollment
                  </p>
                  <p className="mt-2 text-base font-semibold text-slate-900">
                    {details.enrollmentStatus}
                  </p>
                </article>

                <article className="rounded-xl border border-slate-200 bg-slate-50 p-4">
                  <p className="text-xs uppercase tracking-[0.08em] text-slate-500">
                    Total Units
                  </p>
                  <p className="mt-2 text-base font-semibold text-slate-900">
                    {totalUnits}
                  </p>
                </article>
              </div>
            </section>
            <GraduationTimeline
              courses={details.semesters.flatMap((s) =>
                s.courses.map((c) => ({
                  term: s.semester.split(" ")[0],
                  year: parseInt(s.semester.split(" ")[1]),
                  course_code: c.code,
                  course_name: c.title,
                  units_max: c.units,
                  isCompleted: c.isCompleted,
                })),
              )}
              totalUnitsRequired={totalUnits}
              majorName={details.major}
              catalogYear={details.catalogYear}
            />
            <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
              <div className="mb-4 flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-900">
                  Semester Breakdown
                </h2>
                <p className="text-sm text-slate-600">Major: {details.major}</p>
              </div>

              <div className="space-y-5">
                {details.semesters.map((semester, index) => (
                  <article
                    key={semester.semester}
                    className="rounded-xl border border-slate-200"
                  >
                    <header className="flex items-center justify-between border-b border-slate-200 bg-slate-50 px-4 py-3">
                      <h3 className="text-sm font-semibold text-slate-900">
                        {index + 1}. {semester.semester}
                      </h3>
                      <span className="text-xs text-slate-500">
                        {semester.courses.reduce(
                          (sum, course) => sum + course.units,
                          0,
                        )}{" "}
                        units
                      </span>
                    </header>

                    <SemesterCoursesTable
                      planId={details.id}
                      courses={semester.courses}
                    />
                  </article>
                ))}
              </div>
            </section>

            {/* degree requirements section (bottom) */}
            <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
              <div className="mb-4 flex items-center justify-between">
                <h2 className="text-xl font-bold text-slate-900">
                  Degree Requirements
                </h2>
                <p className="text-sm text-slate-600">{details.major}</p>
              </div>

              {degreeRequirements.length === 0 ? (
                <p className="text-sm text-slate-600">
                  No degree requirements found for this plan.
                </p>
              ) : (
                <div className="space-y-3">
                  {degreeRequirements.map((req, idx) => (
                    <article
                      key={`${req.requirementName}-${idx}`}
                      className="rounded-xl border border-slate-200 bg-slate-50 p-4"
                    >
                      <div className="flex flex-col gap-1 sm:flex-row sm:items-baseline sm:justify-between">
                        <p className="text-base font-semibold text-slate-900">
                          {req.requirementName}
                        </p>
                        <p className="text-sm font-medium text-slate-700">
                          {req.requiredUnitsMin ?? "—"} units
                        </p>
                      </div>
                      {req.note ? (
                        <p className="mt-2 text-sm text-slate-700">
                          {req.note}
                        </p>
                      ) : null}
                    </article>
                  ))}
                </div>
              )}
            </section>
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
