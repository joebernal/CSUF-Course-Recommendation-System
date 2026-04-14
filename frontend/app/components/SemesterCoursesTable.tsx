"use client";

import { Fragment, useState } from "react";
import { useRouter } from "next/navigation";

export type PlanCourse = {
  code: string;
  title: string;
  units: number;
  isCompleted?: boolean;
};

type SemesterCoursesTableProps = {
  planId: string;
  courses: PlanCourse[];
};

export default function SemesterCoursesTable({
  planId,
  courses,
}: SemesterCoursesTableProps) {
  const router = useRouter();
  const [expandedCourseCode, setExpandedCourseCode] = useState<string | null>(
    null,
  );
  const [courseDescriptions, setCourseDescriptions] = useState<
    Record<string, string>
  >({});
  const [isLoadingDescription, setIsLoadingDescription] = useState(false);

  const markComplete = (courseCode: string) => {
    router.push(
      `/completed-courses?prefill=${encodeURIComponent(courseCode)}&fromPlan=${encodeURIComponent(planId)}`,
    );
  };

  const toggleCourseDescription = async (courseCode: string) => {
    if (expandedCourseCode === courseCode) {
      setExpandedCourseCode(null);
      return;
    }

    setExpandedCourseCode(courseCode);

    if (courseDescriptions[courseCode]) {
      return;
    }

    setIsLoadingDescription(true);
    try {
      const response = await fetch(
        `/api/courses/description?course_code=${encodeURIComponent(courseCode)}`,
        {
          cache: "no-store",
        },
      );

      const data = (await response.json()) as {
        courseDescription?: string;
        error?: string;
      };

      if (!response.ok) {
        throw new Error(data.error || "Failed to load course description.");
      }

      setCourseDescriptions((prev) => ({
        ...prev,
        [courseCode]:
          data.courseDescription || "No course description available.",
      }));
    } catch (error) {
      console.error("Error loading course description:", error);
      setCourseDescriptions((prev) => ({
        ...prev,
        [courseCode]: "Unable to load course description right now.",
      }));
    } finally {
      setIsLoadingDescription(false);
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
            {courses.map((course) => (
              <Fragment key={course.code}>
                <tr>
                  <td className="whitespace-nowrap px-4 py-3 font-medium text-slate-900">
                    <button
                      type="button"
                      onClick={() => {
                        void toggleCourseDescription(course.code);
                      }}
                      className="rounded px-1 py-0.5 text-left text-cyan-800 underline decoration-cyan-400 underline-offset-4 transition hover:text-cyan-900"
                    >
                      {course.code}
                    </button>
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
                      disabled={Boolean(course.isCompleted)}
                      className="rounded-md bg-slate-900 px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-50"
                    >
                      {course.isCompleted ? "Completed" : "Mark Complete"}
                    </button>
                  </td>
                </tr>
                {expandedCourseCode === course.code ? (
                  <tr>
                    <td
                      colSpan={5}
                      className="bg-slate-50 px-4 py-3 text-sm text-slate-700"
                    >
                      {isLoadingDescription ? (
                        <span className="text-slate-500">Loading description...</span>
                      ) : (
                        <>
                          <p className="font-semibold text-slate-900">
                            {course.code} Description
                          </p>
                          <p className="mt-1 whitespace-pre-wrap">
                            {courseDescriptions[course.code] ||
                              "No course description available."}
                          </p>
                        </>
                      )}
                    </td>
                  </tr>
                ) : null}
              </Fragment>
            ))}
          </tbody>
        </table>
      </div>

    </div>
  );
}
