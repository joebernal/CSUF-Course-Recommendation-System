"use client";

import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged } from "firebase/auth";
import { useSearchParams } from "next/navigation";
import { FormEvent, useEffect, useMemo, useState } from "react";

type CourseSearchResult = {
  id: number;
  courseCode: string;
  courseName: string | null;
  unitsMin: number;
  unitsMax: number;
};

type CompletedCourse = {
  courseId: number;
  courseCode: string;
  courseName: string | null;
  unitsMin: number;
  unitsMax: number;
  term: string;
  year: number;
  grade: string | null;
};

function formatUnits(unitsMin: number, unitsMax: number) {
  if (unitsMin === unitsMax) {
    return `${unitsMax}`;
  }

  return `${unitsMin}-${unitsMax}`;
}

export default function CompletedCoursesManager() {
  const searchParams = useSearchParams();
  const [googleUid, setGoogleUid] = useState("");

  const [query, setQuery] = useState("");
  const [searchResults, setSearchResults] = useState<CourseSearchResult[]>([]);
  const [isSearching, setIsSearching] = useState(false);

  const [completedCourses, setCompletedCourses] = useState<CompletedCourse[]>([]);
  const [isCompletedLoading, setIsCompletedLoading] = useState(true);

  const [term, setTerm] = useState("Spring");
  const [year, setYear] = useState(String(new Date().getFullYear()));
  const [grade, setGrade] = useState("");

  const [error, setError] = useState("");
  const [success, setSuccess] = useState("");

  const completedIds = useMemo(
    () => new Set(completedCourses.map((course) => course.courseId)),
    [completedCourses],
  );

  const runSearch = async (rawQuery: string) => {
    const normalizedQuery = rawQuery.trim();
    setError("");
    setSuccess("");

    if (normalizedQuery.length < 2) {
      setSearchResults([]);
      setError("Enter at least 2 characters to search.");
      return;
    }

    setIsSearching(true);

    try {
      const response = await fetch(
        `/api/courses/search?q=${encodeURIComponent(normalizedQuery)}`,
        {
          method: "GET",
        },
      );

      const data = (await response.json()) as {
        courses?: CourseSearchResult[];
        error?: string;
      };

      if (!response.ok) {
        throw new Error(data.error ?? "Course search failed.");
      }

      setSearchResults(data.courses ?? []);
    } catch (searchError) {
      setSearchResults([]);
      setError(
        searchError instanceof Error
          ? searchError.message
          : "Course search failed.",
      );
    } finally {
      setIsSearching(false);
    }
  };

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setGoogleUid(user?.uid ?? "");
    });

    return () => unsubscribe();
  }, []);

  useEffect(() => {
    const prefill = (searchParams.get("prefill") ?? "").trim();

    if (prefill.length < 2) {
      return;
    }

    setQuery(prefill);
    void runSearch(prefill);
  }, [searchParams]);

  useEffect(() => {
    if (!googleUid) {
      setCompletedCourses([]);
      setIsCompletedLoading(false);
      return;
    }

    const loadCompleted = async () => {
      setIsCompletedLoading(true);
      setError("");

      try {
        const response = await fetch(
          `/api/courses/completed?google_uid=${encodeURIComponent(googleUid)}`,
          { method: "GET" },
        );

        const data = (await response.json()) as {
          completedCourses?: CompletedCourse[];
          error?: string;
        };

        if (!response.ok) {
          throw new Error(data.error ?? "Failed to load completed courses.");
        }

        setCompletedCourses(data.completedCourses ?? []);
      } catch (loadError) {
        setError(
          loadError instanceof Error
            ? loadError.message
            : "Failed to load completed courses.",
        );
      } finally {
        setIsCompletedLoading(false);
      }
    };

    loadCompleted();
  }, [googleUid]);

  const searchCourses = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    await runSearch(query);
  };

  const handleAddCompletedCourse = async (course: CourseSearchResult) => {
    setError("");
    setSuccess("");

    if (!googleUid) {
      setError("You must be signed in.");
      return;
    }

    if (!year || Number.isNaN(Number.parseInt(year, 10))) {
      setError("Enter a valid completion year.");
      return;
    }

    try {
      const response = await fetch("/api/courses/completed", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          google_uid: googleUid,
          course_id: course.id,
          term,
          year: Number.parseInt(year, 10),
          grade: grade.trim() || null,
        }),
      });

      const data = (await response.json()) as { error?: string; message?: string };

      if (!response.ok) {
        throw new Error(data.error ?? "Failed to add completed course.");
      }

      setCompletedCourses((current) => [
        ...current,
        {
          courseId: course.id,
          courseCode: course.courseCode,
          courseName: course.courseName,
          unitsMin: course.unitsMin,
          unitsMax: course.unitsMax,
          term,
          year: Number.parseInt(year, 10),
          grade: grade.trim() || null,
        },
      ]);
      setSuccess(data.message ?? "Completed course added.");
    } catch (addError) {
      setError(
        addError instanceof Error
          ? addError.message
          : "Failed to add completed course.",
      );
    }
  };

  const handleRemoveCompletedCourse = async (courseId: number) => {
    setError("");
    setSuccess("");

    if (!googleUid) {
      setError("You must be signed in.");
      return;
    }

    try {
      const response = await fetch(
        `/api/courses/completed/${courseId}?google_uid=${encodeURIComponent(googleUid)}`,
        {
          method: "DELETE",
        },
      );

      const data = (await response.json()) as { error?: string; message?: string };

      if (!response.ok) {
        throw new Error(data.error ?? "Failed to remove completed course.");
      }

      setCompletedCourses((current) =>
        current.filter((course) => course.courseId !== courseId),
      );
      setSuccess(data.message ?? "Completed course removed.");
    } catch (removeError) {
      setError(
        removeError instanceof Error
          ? removeError.message
          : "Failed to remove completed course.",
      );
    }
  };

  return (
    <div className="space-y-8">
      <form
        onSubmit={searchCourses}
        className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm"
      >
        <h2 className="text-xl font-bold text-slate-900">Search Courses</h2>
        <p className="mt-2 text-sm text-slate-600">
          Search by course code or course name, then add classes you have already
          completed.
        </p>

        <div className="mt-5 grid gap-4 md:grid-cols-[2fr_1fr_1fr_1fr_auto] md:items-end">
          <div>
            <label
              htmlFor="courseSearch"
              className="mb-2 block text-sm font-medium text-slate-700"
            >
              Course Search
            </label>
            <input
              id="courseSearch"
              type="text"
              value={query}
              onChange={(event) => setQuery(event.target.value)}
              placeholder="Try CPSC 120 or Data Structures"
              className="w-full rounded-xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            />
          </div>

          <div>
            <label htmlFor="term" className="mb-2 block text-sm font-medium text-slate-700">
              Term
            </label>
            <select
              id="term"
              value={term}
              onChange={(event) => setTerm(event.target.value)}
              className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-sm outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            >
              <option value="Spring">Spring</option>
              <option value="Fall">Fall</option>
              <option value="Winter">Winter</option>
              <option value="Summer">Summer</option>
            </select>
          </div>

          <div>
            <label htmlFor="year" className="mb-2 block text-sm font-medium text-slate-700">
              Year
            </label>
            <input
              id="year"
              type="number"
              min={2001}
              max={2100}
              value={year}
              onChange={(event) => setYear(event.target.value)}
              className="w-full rounded-xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            />
          </div>

          <div>
            <label htmlFor="grade" className="mb-2 block text-sm font-medium text-slate-700">
              Grade (Optional)
            </label>
            <input
              id="grade"
              type="text"
              maxLength={3}
              value={grade}
              onChange={(event) => setGrade(event.target.value)}
              placeholder="A"
              className="w-full rounded-xl border border-slate-300 px-4 py-3 text-sm outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            />
          </div>

          <button
            type="submit"
            disabled={isSearching}
            className="rounded-xl bg-slate-900 px-4 py-3 text-sm font-semibold text-white transition hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-70"
          >
            {isSearching ? "Searching..." : "Search"}
          </button>
        </div>
      </form>

      {error ? (
        <div className="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
          {error}
        </div>
      ) : null}

      {success ? (
        <div className="rounded-xl border border-cyan-200 bg-cyan-50 px-4 py-3 text-sm text-cyan-700">
          {success}
        </div>
      ) : null}

      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h3 className="text-lg font-semibold text-slate-900">Search Results</h3>
        {searchResults.length === 0 ? (
          <p className="mt-3 text-sm text-slate-600">
            No results yet. Search for a course above.
          </p>
        ) : (
          <ul className="mt-4 space-y-3">
            {searchResults.map((course) => {
              const isAlreadyCompleted = completedIds.has(course.id);
              return (
                <li
                  key={course.id}
                  className="flex flex-col gap-3 rounded-xl border border-slate-200 p-4 sm:flex-row sm:items-center sm:justify-between"
                >
                  <div>
                    <p className="text-sm font-semibold text-slate-900">
                      {course.courseCode}: {course.courseName ?? "Untitled Course"}
                    </p>
                    <p className="text-xs text-slate-600">
                      Units: {formatUnits(course.unitsMin, course.unitsMax)}
                    </p>
                  </div>

                  <button
                    type="button"
                    onClick={() => handleAddCompletedCourse(course)}
                    disabled={isAlreadyCompleted}
                    className="rounded-lg border border-cyan-300 px-3 py-2 text-sm font-semibold text-cyan-700 transition hover:bg-cyan-50 disabled:cursor-not-allowed disabled:border-slate-200 disabled:text-slate-400"
                  >
                    {isAlreadyCompleted ? "Already Added" : "Add to Completed"}
                  </button>
                </li>
              );
            })}
          </ul>
        )}
      </section>

      <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <h3 className="text-lg font-semibold text-slate-900">Completed Courses</h3>
        {isCompletedLoading ? (
          <p className="mt-3 text-sm text-slate-600">Loading completed courses...</p>
        ) : completedCourses.length === 0 ? (
          <p className="mt-3 text-sm text-slate-600">
            You have not added any completed courses yet.
          </p>
        ) : (
          <ul className="mt-4 space-y-3">
            {completedCourses.map((course) => (
              <li
                key={course.courseId}
                className="flex flex-col gap-3 rounded-xl border border-slate-200 p-4 sm:flex-row sm:items-center sm:justify-between"
              >
                <div>
                  <p className="text-sm font-semibold text-slate-900">
                    {course.courseCode}: {course.courseName ?? "Untitled Course"}
                  </p>
                  <p className="text-xs text-slate-600">
                    Completed: {course.term} {course.year}
                    {course.grade ? `, Grade ${course.grade}` : ""}
                  </p>
                </div>

                <button
                  type="button"
                  onClick={() => handleRemoveCompletedCourse(course.courseId)}
                  className="rounded-lg border border-red-300 px-3 py-2 text-sm font-semibold text-red-700 transition hover:bg-red-50"
                >
                  Remove
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
