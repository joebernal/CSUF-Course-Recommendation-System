"use client";

import { loadOnboardingPreferences } from "@/lib/onboarding/preferences";
import { FormEvent, useEffect, useState } from "react";

const fallbackMajors = [
  "Computer Science",
  "Software Engineering",
  "Computer Engineering",
];

function normalizeMajors(data: unknown): string[] {
  if (!Array.isArray(data)) {
    return [];
  }

  const names = data
    .map((item) => {
      if (typeof item === "string") {
        return item.trim();
      }

      if (item && typeof item === "object") {
        const record = item as Record<string, unknown>;
        const candidate =
          record.major_name ??
          record.major ??
          record.name ??
          record.title ??
          record.program ??
          record.value;

        if (typeof candidate === "string") {
          return candidate.trim();
        }
      }

      return "";
    })
    .filter((name) => name.length > 0);

  return Array.from(new Set(names));
}

export default function RequestPlanForm() {
  const [major, setMajor] = useState("");
  const [majors, setMajors] = useState<string[]>([]);
  const [isMajorsLoading, setIsMajorsLoading] = useState(true);
  const [majorsLoadError, setMajorsLoadError] = useState("");
  const [enrollmentStatus, setEnrollmentStatus] = useState<"fulltime" | "parttime">("fulltime");
  const [catalogYear, setCatalogYear] = useState("Spring 2022");
  const [startSeason, setStartSeason] = useState("Spring");
  const [startYear, setStartYear] = useState("2026");
  const [onboardingDefaultsMessage, setOnboardingDefaultsMessage] = useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [errors, setErrors] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const onboardingPreferences = loadOnboardingPreferences();

    if (!onboardingPreferences) {
      return;
    }

    setEnrollmentStatus(
      onboardingPreferences.enrollmentLoad === "full_time" ? "fulltime" : "parttime"
    );

    if (onboardingPreferences.takeWinterCourses && !onboardingPreferences.takeSummerCourses) {
      setStartSeason("Winter");
    } else if (onboardingPreferences.takeSummerCourses && !onboardingPreferences.takeWinterCourses) {
      setStartSeason("Summer");
    }

    const seasonalPreference =
      onboardingPreferences.takeWinterCourses && onboardingPreferences.takeSummerCourses
        ? "winter and summer"
        : onboardingPreferences.takeWinterCourses
          ? "winter"
          : onboardingPreferences.takeSummerCourses
            ? "summer"
            : null;

    setOnboardingDefaultsMessage(
      seasonalPreference
        ? `Defaults applied from onboarding: ${
            onboardingPreferences.enrollmentLoad === "full_time" ? "full-time" : "part-time"
          } and ${seasonalPreference} availability.`
        : `Defaults applied from onboarding: ${
            onboardingPreferences.enrollmentLoad === "full_time" ? "full-time" : "part-time"
          } enrollment.`
    );
  }, []);

  useEffect(() => {
    let isCancelled = false;

    const loadMajors = async () => {
      setIsMajorsLoading(true);
      setMajorsLoadError("");

      try {
        const response = await fetch("/api/majors", {
          method: "GET",
        });

        const data = (await response.json()) as unknown;

        if (!response.ok) {
          throw new Error("Could not load majors.");
        }

        const normalized = normalizeMajors(data);

        if (normalized.length === 0) {
          throw new Error("No majors returned by API.");
        }

        if (!isCancelled) {
          setMajors(normalized);
          setMajor((current) => (current && normalized.includes(current) ? current : normalized[0]));
        }
      } catch {
        if (!isCancelled) {
          setMajors(fallbackMajors);
          setMajor((current) => current || fallbackMajors[0]);
          setMajorsLoadError("Could not load majors from API. Showing fallback list.");
        }
      } finally {
        if (!isCancelled) {
          setIsMajorsLoading(false);
        }
      }
    };

    loadMajors();

    return () => {
      isCancelled = true;
    };
  }, []);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    setSuccessMessage("");
    setErrors([]);

    if (!major) {
      setErrors(["major is required"]);
      return;
    }

    setIsLoading(true);

    const payload = {
      major,
      enrollment: enrollmentStatus,
      catalog_year: catalogYear,
      start_semester: startSeason,
      semester_year: Number.parseInt(startYear, 10),
    };

    try {
      const response = await fetch("/api/plans", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      const data = (await response.json()) as {
        message?: string;
        errors?: string[];
      };

      if (!response.ok) {
        setErrors(data.errors && data.errors.length > 0 ? data.errors : ["Request failed"]);
        return;
      }

      setSuccessMessage(data.message ?? "Plan request submitted successfully.");
    } catch {
      setErrors(["Could not submit request. Please check your API server and try again."]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6" noValidate>
      <div>
        <label htmlFor="majorSelect" className="mb-2 block text-sm font-medium text-slate-700">
          Major
        </label>
        <select
          id="majorSelect"
          name="major"
          value={major}
          onChange={(event) => setMajor(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          disabled={isMajorsLoading || majors.length === 0}
          required
        >
          {isMajorsLoading ? <option value="">Loading majors...</option> : null}
          {!isMajorsLoading && majors.length === 0 ? (
            <option value="">No majors available</option>
          ) : null}
          {!isMajorsLoading
            ? majors.map((majorOption) => (
                <option key={majorOption} value={majorOption}>
                  {majorOption}
                </option>
              ))
            : null}
        </select>
        {majorsLoadError ? (
          <p className="mt-2 text-xs font-medium text-amber-700">{majorsLoadError}</p>
        ) : null}
      </div>

      <fieldset>
        <legend className="mb-2 block text-sm font-medium text-slate-700">Enrollment Status</legend>
        <div className="space-y-2 rounded-xl border border-slate-200 bg-slate-50 p-4">
          <label className="flex items-center gap-3 text-sm text-slate-700">
            <input
              type="radio"
              name="enrollmentStatus"
              value="fulltime"
              checked={enrollmentStatus === "fulltime"}
              onChange={() => setEnrollmentStatus("fulltime")}
              className="h-4 w-4 border-slate-300 text-cyan-600 focus:ring-cyan-500"
            />
            Full Time
          </label>
          <label className="flex items-center gap-3 text-sm text-slate-700">
            <input
              type="radio"
              name="enrollmentStatus"
              value="parttime"
              checked={enrollmentStatus === "parttime"}
              onChange={() => setEnrollmentStatus("parttime")}
              className="h-4 w-4 border-slate-300 text-cyan-600 focus:ring-cyan-500"
            />
            Part Time
          </label>
        </div>
        {onboardingDefaultsMessage ? (
          <p className="mt-2 text-xs font-medium text-cyan-700">{onboardingDefaultsMessage}</p>
        ) : null}
      </fieldset>

      <div>
        <label htmlFor="catalogYear" className="mb-2 block text-sm font-medium text-slate-700">
          Catalog Year
        </label>
        <select
          id="catalogYear"
          name="catalogYear"
          value={catalogYear}
          onChange={(event) => setCatalogYear(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          required
        >
          
          <option value="Spring 2026">Spring 2026</option>
          <option value="Fall 2026">Fall 2026</option>
        </select>
      </div>

      <div>
        <p className="mb-2 text-sm font-medium text-slate-700">Start Semester</p>
        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label htmlFor="startSeason" className="mb-2 block text-sm text-slate-600">
              Season
            </label>
            <select
              id="startSeason"
              name="startSeason"
              value={startSeason}
              onChange={(event) => setStartSeason(event.target.value)}
              className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
              required
            >
              <option value="Spring">Spring</option>
              <option value="Fall">Fall</option>
              <option value="Winter">Winter</option>
              <option value="Summer">Summer</option>
            </select>
          </div>

          <div>
            <label htmlFor="startYear" className="mb-2 block text-sm text-slate-600">
              Year
            </label>
            <select
              id="startYear"
              name="startYear"
              value={startYear}
              onChange={(event) => setStartYear(event.target.value)}
              className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
              required
            >
              <option value="2022">2022</option>
              <option value="2023">2023</option>
              <option value="2024">2024</option>
              <option value="2025">2025</option>
              <option value="2026">2026</option>
              <option value="2027">2027</option>
            </select>
          </div>
        </div>
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full rounded-xl bg-slate-900 px-4 py-3 text-sm font-semibold text-white transition hover:bg-slate-700"
      >
        {isLoading ? "Generating..." : "Generate Plan"}
      </button>

      {successMessage ? (
        <p className="rounded-lg border border-cyan-200 bg-cyan-50 px-3 py-2 text-sm text-cyan-800">
          {successMessage}
        </p>
      ) : null}

      {errors.length > 0 ? (
        <div className="rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-800">
          <p className="font-semibold">Please fix the following:</p>
          <ul className="mt-1 list-disc pl-5">
            {errors.map((error) => (
              <li key={error}>{error}</li>
            ))}
          </ul>
        </div>
      ) : null}
    </form>
  );
}
