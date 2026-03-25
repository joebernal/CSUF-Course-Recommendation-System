"use client";

import {
  type EnrollmentLoad,
  loadOnboardingPreferences,
  saveOnboardingPreferences,
} from "@/lib/onboarding/preferences";
import { useRouter } from "next/navigation";
import { FormEvent, useEffect, useState } from "react";

export default function OnboardingForm() {
  const router = useRouter();
  const [enrollmentLoad, setEnrollmentLoad] = useState<EnrollmentLoad | null>(null);
  const [takeWinterCourses, setTakeWinterCourses] = useState(false);
  const [takeSummerCourses, setTakeSummerCourses] = useState(false);
  const [message, setMessage] = useState("");
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const existingPreferences = loadOnboardingPreferences();

    if (!existingPreferences) {
      return;
    }

    setEnrollmentLoad(existingPreferences.enrollmentLoad);
    setTakeWinterCourses(existingPreferences.takeWinterCourses);
    setTakeSummerCourses(existingPreferences.takeSummerCourses);
  }, []);

  const handleSubmit = (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (!enrollmentLoad) {
      setIsError(true);
      setMessage("Please choose whether you are full-time or part-time.");
      return;
    }

    setIsLoading(true);

    saveOnboardingPreferences({
      enrollmentLoad,
      takeWinterCourses,
      takeSummerCourses,
      completedAt: new Date().toISOString(),
    });

    setIsError(false);
    setMessage("Preferences saved. Redirecting to dashboard...");
    router.push("/dashboard");
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-8" noValidate>
      <fieldset className="space-y-4">
        <legend className="text-xl font-semibold text-slate-900">Are you full-time or part-time?</legend>

        <label className="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 text-slate-800">
          <input
            type="radio"
            name="enrollmentLoad"
            value="full_time"
            checked={enrollmentLoad === "full_time"}
            onChange={() => setEnrollmentLoad("full_time")}
            className="h-4 w-4"
          />
          Full-time
        </label>

        <label className="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 text-slate-800">
          <input
            type="radio"
            name="enrollmentLoad"
            value="part_time"
            checked={enrollmentLoad === "part_time"}
            onChange={() => setEnrollmentLoad("part_time")}
            className="h-4 w-4"
          />
          Part-time
        </label>
      </fieldset>

      <fieldset className="space-y-4">
        <legend className="text-xl font-semibold text-slate-900">
          Do you plan to take winter or summer courses?
        </legend>

        <label className="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 text-slate-800">
          <input
            type="checkbox"
            checked={takeWinterCourses}
            onChange={(event) => setTakeWinterCourses(event.target.checked)}
            className="h-4 w-4"
          />
          I plan to take Winter courses
        </label>

        <label className="flex items-center gap-3 rounded-xl border border-slate-200 bg-white px-4 py-3 text-slate-800">
          <input
            type="checkbox"
            checked={takeSummerCourses}
            onChange={(event) => setTakeSummerCourses(event.target.checked)}
            className="h-4 w-4"
          />
          I plan to take Summer courses
        </label>
      </fieldset>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full rounded-full bg-[#082c5e] px-5 py-3 text-lg font-semibold text-white transition hover:bg-[#0a3c7f]"
      >
        {isLoading ? "Saving..." : "Continue to dashboard"}
      </button>

      {message ? (
        <p
          className={`rounded-lg px-3 py-2 text-sm ${
            isError
              ? "border border-red-200 bg-red-50 text-red-800"
              : "border border-cyan-200 bg-cyan-50 text-cyan-800"
          }`}
        >
          {message}
        </p>
      ) : null}
    </form>
  );
}