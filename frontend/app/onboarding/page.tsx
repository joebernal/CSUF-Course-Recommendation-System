import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import OnboardingForm from "@/app/components/OnboardingForm";
import ProtectedRoute from "@/app/components/ProtectedRoute";

export default function OnboardingPage() {
  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-10 sm:px-6 sm:py-12 lg:px-8">
          <div className="mx-auto w-full max-w-3xl rounded-3xl border border-slate-200 bg-slate-50 p-6 shadow-sm sm:p-8">
            <p className="text-xs uppercase tracking-[0.18em] text-cyan-700">Welcome to Tuffy Plan</p>
            <h1 className="mt-3 text-3xl font-bold text-slate-900 sm:text-4xl">Quick onboarding</h1>
            <p className="mt-3 text-sm leading-7 text-slate-600 sm:text-base">
              Tell us about your schedule preference so we can personalize your planning experience.
            </p>

            <div className="mt-8">
              <OnboardingForm />
            </div>
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}