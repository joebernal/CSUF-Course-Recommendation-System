import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";
import RequestPlanForm from "@/app/components/RequestPlanForm";

export default function RequestPlanPage() {
  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-10 sm:px-6 sm:py-14 lg:px-8">
          <div className="mx-auto grid w-full max-w-6xl items-stretch overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-xl shadow-slate-900/10 lg:grid-cols-2">
            <section className="relative overflow-hidden bg-slate-950 p-8 text-white sm:p-10">
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(56,189,248,0.4),transparent_42%),radial-gradient(circle_at_80%_78%,rgba(245,158,11,0.35),transparent_40%)]" />
              <div className="relative">
                <p className="text-xs uppercase tracking-[0.2em] text-cyan-200">Plan Request</p>
                <h1 className="mt-3 text-3xl font-bold leading-tight sm:text-4xl">
                  Request a New Plan
                </h1>
                <p className="mt-4 max-w-md text-sm leading-7 text-white/80 sm:text-base">
                  Submit your enrollment preferences and catalog details to generate
                  a personalized roadmap.
                </p>

                <div className="mt-8 space-y-3 text-sm text-white/90">
                  <p className="rounded-lg border border-white/20 bg-white/10 px-4 py-3">
                    Choose major and enrollment status
                  </p>
                  <p className="rounded-lg border border-white/20 bg-white/10 px-4 py-3">
                    Select catalog year and start semester
                  </p>
                  <p className="rounded-lg border border-white/20 bg-white/10 px-4 py-3">
                    Generate a plan tailored to your timeline
                  </p>
                </div>
              </div>
            </section>

            <section className="p-8 sm:p-10">
              <h2 className="text-2xl font-bold text-slate-900">Request Details</h2>
              <p className="mt-2 text-sm text-slate-600">
                Complete the fields below to generate your plan.
              </p>

              <div className="mt-6">
                <RequestPlanForm />
              </div>
            </section>
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
