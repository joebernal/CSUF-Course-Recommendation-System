import CompletedCoursesManager from "@/app/components/CompletedCoursesManager";
import Footer from "@/app/components/Footer";
import Navbar from "@/app/components/Navbar";
import ProtectedRoute from "@/app/components/ProtectedRoute";

export default function CompletedCoursesPage() {
  return (
    <div className="flex min-h-screen flex-col">
      <Navbar />

      <ProtectedRoute>
        <main className="flex-1 px-4 py-8 sm:px-6 sm:py-10 lg:px-8">
          <div className="mx-auto w-full max-w-6xl space-y-6">
            <section className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
              <p className="text-xs uppercase tracking-[0.2em] text-cyan-700">
                Courses
              </p>
              <h1 className="mt-2 text-3xl font-bold text-slate-900 sm:text-4xl">
                Completed Course Tracker
              </h1>
              <p className="mt-3 max-w-3xl text-sm leading-7 text-slate-600 sm:text-base">
                Search courses and add the ones you have completed, so your plan
                can account for your progress.
              </p>
            </section>

            <CompletedCoursesManager />
          </div>
        </main>
      </ProtectedRoute>

      <Footer />
    </div>
  );
}
