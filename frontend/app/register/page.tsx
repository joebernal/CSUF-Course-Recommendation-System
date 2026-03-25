import Navbar from "@/app/components/Navbar";
import RegisterForm from "@/app/components/RegisterForm";
import Image from "next/image";

export default function RegisterPage() {
  return (
    <div className="flex min-h-screen flex-col bg-white">
      <Navbar />

      <main className="flex-1 px-4 pb-8 pt-6 sm:px-8 sm:pt-10 lg:px-12">
        <div className="mx-auto grid h-full w-full max-w-6xl items-center gap-8 lg:grid-cols-[minmax(0,520px)_1fr] lg:gap-10">
          <section className="mx-auto w-full max-w-[420px] py-6 sm:py-10 lg:mx-0 lg:py-12">
            <p className="text-[2rem] font-semibold leading-none text-slate-950 sm:text-[2.25rem]">
              Register
            </p>
            <p className="mt-4 text-lg text-slate-700">
              Create your account to start your CSUF plan.
            </p>

            <div className="mt-10">
              <RegisterForm />
            </div>

            <p className="mt-14 text-sm text-slate-600">(c) 2026 Tuffy Plan</p>
          </section>

          <section className="hidden items-center justify-center lg:flex">
            <Image
              src="/images/tuffy_laptop.png"
              alt="Tuffy working on a laptop"
              width={920}
              height={680}
              priority
              className="h-auto w-full max-w-[720px]"
            />
          </section>
        </div>
      </main>
    </div>
  );
}
