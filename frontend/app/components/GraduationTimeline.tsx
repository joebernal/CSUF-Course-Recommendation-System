"use client";

export type PlanCourse = {
  term: string;
  year: number;
  course_code: string;
  course_name: string;
  units_max: number;
  isCompleted?: boolean;
};

type GraduationTimelineProps = {
  courses: PlanCourse[];
  totalUnitsRequired?: number;
  majorName?: string;
  catalogYear?: string;
};

type SemesterStatus = "complete" | "current" | "upcoming";

type Semester = {
  label: string;
  term: string;
  year: number;
  units: number;
  status: SemesterStatus;
};

const TERM_ORDER: Record<string, number> = {
  Winter: 0,
  Spring: 1,
  Summer: 2,
  Fall: 3,
};

export default function GraduationTimeline({
  courses,
  totalUnitsRequired = 120,
  majorName = "Computer Science",
  catalogYear = "Fall 2025 & Beyond",
}: GraduationTimelineProps) {
  // Group courses into semesters
  const semesterMap = new Map<string, { term: string; year: number; units: number; allComplete: boolean }>();

  for (const c of courses) {
    const key = `${c.year}-${TERM_ORDER[c.term] ?? 99}-${c.term}`;
    const existing = semesterMap.get(key);
    if (existing) {
      existing.units += c.units_max;
      if (!c.isCompleted) existing.allComplete = false;
    } else {
      semesterMap.set(key, {
        term: c.term,
        year: c.year,
        units: c.units_max,
        allComplete: c.isCompleted ?? false,
      });
    }
  }

  const sorted = Array.from(semesterMap.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([, v]) => v);

  let foundCurrent = false;
  const semesters: Semester[] = sorted.map((s) => {
    let status: SemesterStatus;
    if (s.allComplete) {
      status = "complete";
    } else if (!foundCurrent) {
      status = "current";
      foundCurrent = true;
    } else {
      status = "upcoming";
    }
    return { label: `${s.term} ${s.year}`, term: s.term, year: s.year, units: s.units, status };
  });

  const completedUnits = courses.reduce(
    (sum, course) => sum + (course.isCompleted ? course.units_max : 0),
    0,
  );

  const remainingUnits = Math.max(totalUnitsRequired - completedUnits, 0);
  const pct = Math.min(
    100,
    Math.round((completedUnits / Math.max(totalUnitsRequired, 1)) * 100),
  );

  const lastSem = semesters[semesters.length - 1];
  const expectedGrad = lastSem ? lastSem.label : "—";
  const semsRemaining = semesters.filter((s) => s.status === "current" || s.status === "upcoming").length;

  return (
    <div className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
      {/* Header */}
      <div className="mb-5">
        <h2 className="text-lg font-semibold text-slate-900">Graduation Timeline</h2>
        <p className="mt-0.5 text-sm text-slate-500">
          {majorName} &middot; {catalogYear}
        </p>
      </div>

      {/* Metric cards */}
      <div className="mb-5 grid grid-cols-3 gap-3">
        {[
          { label: "Completed", value: completedUnits },
          { label: "Remaining", value: remainingUnits },
          { label: "Total required", value: totalUnitsRequired },
        ].map(({ label, value }) => (
          <div key={label} className="rounded-lg bg-slate-50 px-4 py-3">
            <p className="text-xs uppercase tracking-[0.08em] text-slate-500">{label}</p>
            <p className="mt-1 text-2xl font-semibold text-slate-900">{value}</p>
            <p className="text-xs text-slate-400">units</p>
          </div>
        ))}
      </div>

      {/* Progress bar */}
      <div className="mb-5 rounded-xl border border-slate-100 bg-slate-50 p-4">
        <div className="mb-2 flex justify-between text-sm">
          <span className="font-medium text-slate-700">Overall progress</span>
          <span className="text-slate-400">{pct}% complete</span>
        </div>

        <div className="relative h-7 w-full overflow-hidden rounded-full bg-slate-200">
          <div
            className="h-full rounded-full transition-all duration-1000 ease-out"
            style={{
              width: `${pct}%`,
              background: "linear-gradient(90deg, #3B6D11, #639922)",
            }}
          >
            <div
              className="absolute inset-0 rounded-full"
              style={{
                background:
                  "repeating-linear-gradient(135deg, rgba(255,255,255,0.12) 0px, rgba(255,255,255,0.12) 8px, transparent 8px, transparent 16px)",
              }}
            />
            {pct > 10 && (
              <span className="relative z-10 flex h-full items-center justify-end pr-3 text-xs font-semibold text-white">
                {pct}%
              </span>
            )}
          </div>
        </div>

        <div className="mt-1 flex justify-between text-xs text-slate-400">
          <span>0</span>
          <span>30</span>
          <span>60</span>
          <span>90</span>
          <span>120</span>
        </div>
      </div>

      {/* Semester list */}
      <div className="rounded-xl border border-slate-100 bg-slate-50 p-4">
        <p className="mb-3 text-sm font-semibold text-slate-700">Semester breakdown</p>
        <div className="space-y-2">
          {semesters.map((s) => (
            <div key={s.label} className="flex items-center gap-3">
              <span
                className={`h-2.5 w-2.5 flex-shrink-0 rounded-full ${
                  s.status === "complete"
                    ? "bg-emerald-500"
                    : s.status === "current"
                    ? "bg-blue-500"
                    : "bg-slate-300"
                }`}
              />
              <span className="flex-1 text-sm text-slate-500">{s.label}</span>
              <span className="text-sm font-medium text-slate-800">{s.units} units</span>
              <StatusBadge status={s.status} />
            </div>
          ))}
        </div>

        <div className="my-4 h-px bg-slate-200" />

        {/* Graduation banner */}
        <div className="flex items-center gap-3 rounded-lg border border-emerald-200 bg-emerald-50 px-4 py-3">
          <div className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-full bg-emerald-600">
            <svg
              width="18"
              height="18"
              viewBox="0 0 24 24"
              fill="none"
              stroke="white"
              strokeWidth="2"
              strokeLinecap="round"
              strokeLinejoin="round"
            >
              <path d="M22 10v6M2 10l10-5 10 5-10 5z" />
              <path d="M6 12v5c3 3 9 3 12 0v-5" />
            </svg>
          </div>
          <div>
            <p className="text-sm font-semibold text-emerald-800">
              Expected graduation: {expectedGrad}
            </p>
            <p className="text-xs text-emerald-700">
              {semsRemaining} semester{semsRemaining !== 1 ? "s" : ""} remaining
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

function StatusBadge({ status }: { status: SemesterStatus }) {
  if (status === "complete") {
    return (
      <span className="rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-800">
        Complete
      </span>
    );
  }
  if (status === "current") {
    return (
      <span className="rounded-full bg-blue-100 px-2.5 py-1 text-xs font-semibold text-blue-800">
        In progress
      </span>
    );
  }
  return (
    <span className="rounded-full bg-amber-100 px-2.5 py-1 text-xs font-semibold text-amber-800">
      Pending
    </span>
  );
}
