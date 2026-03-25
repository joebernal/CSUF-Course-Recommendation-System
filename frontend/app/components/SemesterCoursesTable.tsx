"use client";

import { useState } from "react";

export type PlanCourse = {
  code: string;
  title: string;
  units: number;
  isCompleted?: boolean;
};

type SemesterCoursesTableProps = {
  planId: string;
  semester: string;
  courses: PlanCourse[];
};

export default function SemesterCoursesTable({
  planId,
  semester,
  courses,
}: SemesterCoursesTableProps) {
  const [courseRows, setCourseRows] = useState(courses);
  const [pendingCode, setPendingCode] = useState<string | null>(null);
  const [message, setMessage] = useState("");
  const [errorMessage, setErrorMessage] = useState("");

  const markComplete = async (courseCode: string) => {
    setPendingCode(courseCode);
    setMessage("");
    setErrorMessage("");

    try {
      const response = await fetch(`/api/plans/${planId}/courses/complete`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          semester,
          courseCode,
          completed: true,
        }),
      });

      if (!response.ok) {
        throw new Error(`Request failed with status ${response.status}`);
      }

      setCourseRows((rows) =>
        rows.map((row) =>
          row.code === courseCode
            ? {
                ...row,
                isCompleted: true,
              }
            : row
        )
      );

      setMessage(`${courseCode} was marked complete.`);
    } catch {
      setErrorMessage(
        `Could not mark ${courseCode} complete. Confirm your API endpoint is available.`
      );
    } finally {
      setPendingCode(null);
    }
  };

  return (
    <div>
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-slate-200 text-left text-sm">
          <thead className="bg-white">
            <tr className="text-xs uppercase tracking-[0.08em] text-slate-500">
              <th className="px-4 py-3 font-semibold">Course</th>
              <th className="px-4 py-3 font-semibold">Title</th>
              <th className="px-4 py-3 font-semibold">Units</th>
              <th className="px-4 py-3 font-semibold">Status</th>
              <th className="px-4 py-3 font-semibold">Action</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 bg-white text-slate-700">
            {courseRows.map((course) => (
              <tr key={course.code}>
                <td className="whitespace-nowrap px-4 py-3 font-medium text-slate-900">
                  {course.code}
                </td>
                <td className="px-4 py-3">{course.title}</td>
                <td className="whitespace-nowrap px-4 py-3">{course.units}</td>
                <td className="whitespace-nowrap px-4 py-3">
                  {course.isCompleted ? (
                    <span className="rounded-full bg-emerald-100 px-2.5 py-1 text-xs font-semibold text-emerald-800">
                      Complete
                    </span>
                  ) : (
                    <span className="rounded-full bg-amber-100 px-2.5 py-1 text-xs font-semibold text-amber-800">
                      Pending
                    </span>
                  )}
                </td>
                <td className="whitespace-nowrap px-4 py-3">
                  <button
                    type="button"
                    onClick={() => markComplete(course.code)}
                    disabled={Boolean(course.isCompleted) || pendingCode === course.code}
                    className="rounded-md bg-slate-900 px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-50"
                  >
                    {course.isCompleted
                      ? "Completed"
                      : pendingCode === course.code
                        ? "Saving..."
                        : "Mark Complete"}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {message ? (
        <p className="mx-4 mb-4 mt-3 rounded-lg border border-emerald-200 bg-emerald-50 px-3 py-2 text-sm text-emerald-800">
          {message}
        </p>
      ) : null}

      {errorMessage ? (
        <p className="mx-4 mb-4 mt-3 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">
          {errorMessage}
        </p>
      ) : null}
    </div>
  );
}
