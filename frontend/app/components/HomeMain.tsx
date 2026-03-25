import Image from "next/image";
import Link from "next/link";

export default function HomeMain() {
  return (
    <section id="about" className="bg-[#e7e7e9]">
      <div className="mx-auto grid w-full max-w-7xl items-center gap-6 px-4 pb-10 pt-12 sm:px-6 md:grid-cols-2 md:gap-8 md:pb-14 md:pt-16 lg:px-10 lg:pt-20">
        <div className="max-w-xl">
          <h1 className="text-5xl font-bold leading-[1.05] tracking-tight text-[#140d0f] sm:text-6xl lg:text-7xl">
            Plan Your CSUF
            <br />
            Degree in
            <br />
            Minutes.
          </h1>

          <p className="mt-8 max-w-lg text-lg leading-8 text-[#2f2f34]">
            Generate a personalized semester-by-semester roadmap based on your
            completed coursework, availability, and academic goals.
          </p>

          <div className="mt-8">
            <Link
              href="/register"
              className="inline-flex items-center gap-2 rounded-full bg-[#0b3d70] px-5 py-3 text-base font-semibold text-white transition hover:bg-[#0a325e]"
            >
              <svg
                viewBox="0 0 24 24"
                className="h-4 w-4"
                fill="none"
                stroke="currentColor"
                strokeWidth="2"
                aria-hidden="true"
              >
                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                <circle cx="8.5" cy="7" r="4" />
                <path d="M20 8v6M23 11h-6" />
              </svg>
              Register Now
            </Link>
          </div>
        </div>

        <div className="relative min-h-[320px] sm:min-h-[420px] md:min-h-[500px]">
          <Image
            src="/images/tuffy.png"
            alt="Tuffy mascot holding a diploma"
            fill
            priority
            sizes="(max-width: 768px) 100vw, 48vw"
            className="object-contain"
          />
        </div>
      </div>
    </section>
  );
}
