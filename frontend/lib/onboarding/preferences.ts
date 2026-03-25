export type EnrollmentLoad = "full_time" | "part_time";

export type OnboardingPreferences = {
  enrollmentLoad: EnrollmentLoad;
  takeWinterCourses: boolean;
  takeSummerCourses: boolean;
  preferredLanguage: string;
  careerInterest: string;
  completedAt: string;
};

const ONBOARDING_STORAGE_KEY = "tuffy_plan_onboarding_preferences_v1";

export function saveOnboardingPreferences(preferences: OnboardingPreferences) {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(ONBOARDING_STORAGE_KEY, JSON.stringify(preferences));
}

export function loadOnboardingPreferences(): OnboardingPreferences | null {
  if (typeof window === "undefined") {
    return null;
  }

  const raw = window.localStorage.getItem(ONBOARDING_STORAGE_KEY);

  if (!raw) {
    return null;
  }

  try {
    const parsed = JSON.parse(raw) as Partial<OnboardingPreferences>;

    if (
      (parsed.enrollmentLoad === "full_time" || parsed.enrollmentLoad === "part_time") &&
      typeof parsed.takeWinterCourses === "boolean" &&
      typeof parsed.takeSummerCourses === "boolean"
    ) {
      return {
        enrollmentLoad: parsed.enrollmentLoad,
        takeWinterCourses: false,
        takeSummerCourses: false,
        preferredLanguage:
          typeof parsed.preferredLanguage === "string" ? parsed.preferredLanguage : "Python",
        careerInterest:
          typeof parsed.careerInterest === "string" ? parsed.careerInterest : "Undecided",
        completedAt: typeof parsed.completedAt === "string" ? parsed.completedAt : new Date().toISOString(),
      };
    }

    return null;
  } catch {
    return null;
  }
}