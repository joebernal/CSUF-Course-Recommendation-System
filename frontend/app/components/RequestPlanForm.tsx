"use client";

import { loadOnboardingPreferences } from "@/lib/onboarding/preferences";
import { auth } from "@/lib/firebase/client";
import { onAuthStateChanged } from "firebase/auth";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useState } from "react";

type MajorOption = {
  id: number;
  majorName: string;
};

type CatalogOption = {
  id: number;
  catalogName: string;
  startTerm: string;
  startYear: number;
};

const fallbackMajors: MajorOption[] = [
  { id: 1, majorName: "Computer Science" },
];

const fallbackCatalogs: CatalogOption[] = [
  { id: 1, catalogName: "Fall 2026", startTerm: "Fall", startYear: 2026 },
  { id: 2, catalogName: "Spring 2026", startTerm: "Spring", startYear: 2026 },
];

function normalizeMajors(data: unknown): MajorOption[] {
  if (!Array.isArray(data)) {
    return [];
  }

  const normalized = data
    .map((item) => {
      if (!item || typeof item !== "object") {
        return null;
      }

      const record = item as Record<string, unknown>;
      const id = record.id;
      const name =
        record.major_name ??
        record.major ??
        record.name ??
        record.title ??
        record.program ??
        record.value;

      const parsedId =
        typeof id === "number"
          ? id
          : typeof id === "string"
            ? Number.parseInt(id, 10)
            : NaN;

      if (
        !Number.isFinite(parsedId) ||
        typeof name !== "string" ||
        !name.trim()
      ) {
        return null;
      }

      return {
        id: parsedId,
        majorName: name.trim(),
      };
    })
    .filter((item): item is MajorOption => Boolean(item));

  return Array.from(
    new Map(normalized.map((item) => [item.id, item])).values(),
  );
}

function normalizeCatalogs(data: unknown): CatalogOption[] {
  if (!Array.isArray(data)) {
    return [];
  }

  const normalized = data
    .map((item) => {
      if (!item || typeof item !== "object") {
        return null;
      }

      const record = item as Record<string, unknown>;
      const id = record.id;
      const catalogName = record.catalog_name;
      const startTerm = record.start_term;
      const startYear = record.start_year;

      const parsedId =
        typeof id === "number"
          ? id
          : typeof id === "string"
            ? Number.parseInt(id, 10)
            : NaN;

      const parsedYear =
        typeof startYear === "number"
          ? startYear
          : typeof startYear === "string"
            ? Number.parseInt(startYear, 10)
            : NaN;

      if (
        !Number.isFinite(parsedId) ||
        typeof catalogName !== "string" ||
        typeof startTerm !== "string" ||
        !Number.isFinite(parsedYear)
      ) {
        return null;
      }

      return {
        id: parsedId,
        catalogName: catalogName.trim(),
        startTerm: startTerm.trim(),
        startYear: parsedYear,
      };
    })
    .filter((item): item is CatalogOption => Boolean(item));

  return Array.from(
    new Map(normalized.map((item) => [item.id, item])).values(),
  );
}

export default function RequestPlanForm() {
  const router = useRouter();

  const [googleUid, setGoogleUid] = useState("");

  const [majorId, setMajorId] = useState("");
  const [majors, setMajors] = useState<MajorOption[]>([]);
  const [isMajorsLoading, setIsMajorsLoading] = useState(true);
  const [majorsLoadError, setMajorsLoadError] = useState("");

  const [enrollmentStatus, setEnrollmentStatus] = useState<
    "fulltime" | "parttime"
  >("fulltime");

  const [catalogYearId, setCatalogYearId] = useState("");
  const [catalogs, setCatalogs] = useState<CatalogOption[]>([]);
  const [isCatalogsLoading, setIsCatalogsLoading] = useState(true);
  const [catalogsLoadError, setCatalogsLoadError] = useState("");

  const [startSeason, setStartSeason] = useState("Spring");
  const [startYear, setStartYear] = useState("2026");

  const [onboardingDefaultsMessage, setOnboardingDefaultsMessage] =
    useState("");
  const [successMessage, setSuccessMessage] = useState("");
  const [errors, setErrors] = useState<string[]>([]);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      setGoogleUid(user?.uid ?? "");
    });

    return () => unsubscribe();
  }, []);

  useEffect(() => {
    const onboardingPreferences = loadOnboardingPreferences();

    if (!onboardingPreferences) {
      return;
    }

    setEnrollmentStatus(
      onboardingPreferences.enrollmentLoad === "full_time"
        ? "fulltime"
        : "parttime",
    );

    if (
      onboardingPreferences.takeWinterCourses &&
      !onboardingPreferences.takeSummerCourses
    ) {
      setStartSeason("Winter");
    } else if (
      onboardingPreferences.takeSummerCourses &&
      !onboardingPreferences.takeWinterCourses
    ) {
      setStartSeason("Summer");
    }

    const seasonalPreference =
      onboardingPreferences.takeWinterCourses &&
      onboardingPreferences.takeSummerCourses
        ? "winter and summer"
        : onboardingPreferences.takeWinterCourses
          ? "winter"
          : onboardingPreferences.takeSummerCourses
            ? "summer"
            : null;

    setOnboardingDefaultsMessage(
      seasonalPreference
        ? `Defaults applied from onboarding: ${
            onboardingPreferences.enrollmentLoad === "full_time"
              ? "full-time"
              : "part-time"
          } and ${seasonalPreference} availability.`
        : `Defaults applied from onboarding: ${
            onboardingPreferences.enrollmentLoad === "full_time"
              ? "full-time"
              : "part-time"
          } enrollment.`,
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
          setMajorId((current) =>
            current && normalized.some((item) => String(item.id) === current)
              ? current
              : String(normalized[0].id),
          );
        }
      } catch {
        if (!isCancelled) {
          setMajors(fallbackMajors);
          setMajorId((current) => current || String(fallbackMajors[0].id));
          setMajorsLoadError(
            "Could not load majors from API. Showing fallback list.",
          );
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

  useEffect(() => {
    let isCancelled = false;

    const loadCatalogs = async () => {
      setIsCatalogsLoading(true);
      setCatalogsLoadError("");

      try {
        const response = await fetch("/api/plans/catalogs", { method: "GET" });
        const data = (await response.json()) as unknown;

        if (!response.ok) {
          throw new Error("Could not load catalogs.");
        }

        const normalized = normalizeCatalogs(data);
        if (normalized.length === 0) {
          throw new Error("No catalogs returned by API.");
        }

        if (!isCancelled) {
          setCatalogs(normalized);
          setCatalogYearId((current) => {
            const selected =
              normalized.find((item) => String(item.id) === current) ??
              normalized[0];
            setStartSeason(selected.startTerm);
            setStartYear(String(selected.startYear));
            return String(selected.id);
          });
        }
      } catch {
        if (!isCancelled) {
          setCatalogs(fallbackCatalogs);
          setCatalogYearId((current) => {
            const selected =
              fallbackCatalogs.find((item) => String(item.id) === current) ??
              fallbackCatalogs[0];
            setStartSeason(selected.startTerm);
            setStartYear(String(selected.startYear));
            return String(selected.id);
          });
          setCatalogsLoadError(
            "Could not load catalogs from API. Showing fallback list.",
          );
        }
      } finally {
        if (!isCancelled) {
          setIsCatalogsLoading(false);
        }
      }
    };

    loadCatalogs();

    return () => {
      isCancelled = true;
    };
  }, []);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    setSuccessMessage("");
    setErrors([]);

    const newErrors: string[] = [];

    if (!googleUid) {
      newErrors.push("You must be signed in to generate a plan.");
    }

    if (!majorId) {
      newErrors.push("major_id is required");
    }

    if (!catalogYearId) {
      newErrors.push("catalog_year_id is required");
    }

    if (!startSeason) {
      newErrors.push("starting_term is required");
    }

    if (!startYear || Number.isNaN(Number.parseInt(startYear, 10))) {
      newErrors.push("starting_year is required");
    }

    if (newErrors.length > 0) {
      setErrors(newErrors);
      return;
    }

    setIsLoading(true);

    const payload = {
      google_uid: googleUid,
      major_id: Number.parseInt(majorId, 10),
      catalog_year_id: Number.parseInt(catalogYearId, 10),
      starting_term: startSeason,
      starting_year: Number.parseInt(startYear, 10),
    };

    try {
      const response = await fetch("/api/plans/generate", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      });

      const data = (await response.json()) as {
        message?: string;
        error?: string;
        errors?: string[];
        plan_id?: number;
      };

      if (!response.ok) {
        setErrors(
          data.errors && data.errors.length > 0
            ? data.errors
            : [data.error ?? "Request failed"],
        );
        return;
      }

      setSuccessMessage(data.message ?? "Plan generated successfully.");

      if (data.plan_id) {
        router.push(`/plan/${data.plan_id}`);
        return;
      }

      router.push("/plan");
    } catch {
      setErrors([
        "Could not submit request. Please check your API server and try again.",
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6" noValidate>
      <div>
        <label
          htmlFor="majorSelect"
          className="mb-2 block text-sm font-medium text-slate-700"
        >
          Major
        </label>
        <select
          id="majorSelect"
          name="major"
          value={majorId}
          onChange={(event) => setMajorId(event.target.value)}
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
                <option key={majorOption.id} value={majorOption.id}>
                  {majorOption.majorName}
                </option>
              ))
            : null}
        </select>
        {majorsLoadError ? (
          <p className="mt-2 text-xs font-medium text-amber-700">
            {majorsLoadError}
          </p>
        ) : null}
      </div>

      <fieldset>
        <legend className="mb-2 block text-sm font-medium text-slate-700">
          Enrollment Status
        </legend>
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
          <p className="mt-2 text-xs font-medium text-cyan-700">
            {onboardingDefaultsMessage}
          </p>
        ) : null}
      </fieldset>

      <div>
        <label
          htmlFor="catalogYear"
          className="mb-2 block text-sm font-medium text-slate-700"
        >
          Catalog Year
        </label>
        <select
          id="catalogYear"
          name="catalogYear"
          value={catalogYearId}
          onChange={(event) => {
            const selectedId = event.target.value;
            setCatalogYearId(selectedId);
            const selected = catalogs.find(
              (item) => String(item.id) === selectedId,
            );
            if (selected) {
              setStartSeason(selected.startTerm);
              setStartYear(String(selected.startYear));
            }
          }}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          disabled={isCatalogsLoading || catalogs.length === 0}
          required
        >
          {isCatalogsLoading ? (
            <option value="">Loading catalogs...</option>
          ) : null}
          {!isCatalogsLoading && catalogs.length === 0 ? (
            <option value="">No catalogs available</option>
          ) : null}
          {!isCatalogsLoading
            ? catalogs.map((catalogOption) => (
                <option key={catalogOption.id} value={catalogOption.id}>
                  {catalogOption.catalogName}
                </option>
              ))
            : null}
        </select>
        {catalogsLoadError ? (
          <p className="mt-2 text-xs font-medium text-amber-700">
            {catalogsLoadError}
          </p>
        ) : null}
      </div>

      <div>
        <p className="mb-2 text-sm font-medium text-slate-700">
          Start Semester
        </p>
        <div className="grid gap-4 sm:grid-cols-2">
          <div>
            <label
              htmlFor="startSeason"
              className="mb-2 block text-sm text-slate-600"
            >
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
            <label
              htmlFor="startYear"
              className="mb-2 block text-sm text-slate-600"
            >
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
        className="w-full rounded-xl bg-slate-900 px-4 py-3 text-sm font-semibold text-white transition hover:bg-slate-700 disabled:cursor-not-allowed disabled:opacity-70"
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
