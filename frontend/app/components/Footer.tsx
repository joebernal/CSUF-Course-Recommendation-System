import Link from "next/link";

export default function Footer() {
  return (
    <footer id="faq" className="border-t border-slate-200 bg-white/85">
      <div className="mx-auto flex w-full max-w-6xl flex-col gap-4 px-4 py-8 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between sm:px-6 lg:px-8">
        <p>(c) 2026 CPSC 491 Project</p>
        <div className="flex items-center gap-4">
          <a href="#" className="transition hover:text-slate-900">
            Terms
          </a>
          <Link href="/#about" className="transition hover:text-slate-900">
            About
          </Link>
          <Link href="/#about" className="transition hover:text-slate-900">
            Back to top
          </Link>
        </div>
      </div>
    </footer>
  );
}
