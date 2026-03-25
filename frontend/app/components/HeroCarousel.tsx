"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

type Slide = {
  title: string;
  description: string;
  ctaLabel: string;
  ctaHref: string;
  toneClass: string;
};

const slides: Slide[] = [
  {
    title: "Plan your courses around your interests",
    description:
      "Build a schedule that still respects major requirements while keeping the classes you care about front and center.",
    ctaLabel: "Sign up today",
    ctaHref: "#",
    toneClass: "bg-gradient-to-br from-slate-950 via-blue-950 to-slate-900",
  },
  {
    title: "A faster path to graduation",
    description:
      "Find combinations that reduce delays, cut unnecessary credits, and help you graduate on time with less stress.",
    ctaLabel: "Learn more",
    ctaHref: "#features",
    toneClass: "bg-gradient-to-br from-amber-900 via-orange-700 to-rose-700",
  },
  {
    title: "Personalized guidance whenever you need it",
    description:
      "Get recommendations instantly instead of waiting for an advising slot during busy registration periods.",
    ctaLabel: "Get started",
    ctaHref: "#benefits",
    toneClass: "bg-gradient-to-br from-emerald-900 via-teal-700 to-cyan-700",
  },
];

export default function HeroCarousel() {
  const [activeIndex, setActiveIndex] = useState(0);

  useEffect(() => {
    const timer = window.setInterval(() => {
      setActiveIndex((current) => (current + 1) % slides.length);
    }, 5500);

    return () => window.clearInterval(timer);
  }, []);

  const showPrevious = () => {
    setActiveIndex((current) => (current - 1 + slides.length) % slides.length);
  };

  const showNext = () => {
    setActiveIndex((current) => (current + 1) % slides.length);
  };

  return (
    <section aria-label="Highlights" className="w-full">
      <div className="relative isolate h-[420px] overflow-hidden rounded-3xl border border-white/20 shadow-2xl shadow-slate-900/25 sm:h-[500px]">
        {slides.map((slide, index) => (
          <article
            key={slide.title}
            className={`absolute inset-0 transition-opacity duration-700 ${
              index === activeIndex ? "opacity-100" : "pointer-events-none opacity-0"
            }`}
            aria-hidden={index !== activeIndex}
          >
            <div className={`absolute inset-0 ${slide.toneClass}`} />
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(255,255,255,0.22),transparent_38%),radial-gradient(circle_at_82%_80%,rgba(255,255,255,0.14),transparent_42%)]" />
            <div className="relative flex h-full flex-col justify-end p-8 text-white sm:p-12">
              <h1 className="max-w-2xl text-3xl font-bold leading-tight sm:text-5xl">
                {slide.title}
              </h1>
              <p className="mt-4 max-w-2xl text-sm text-white/85 sm:text-lg">
                {slide.description}
              </p>
              <div className="mt-6">
                <Link
                  href={slide.ctaHref}
                  className="inline-flex items-center rounded-full bg-white px-6 py-3 text-sm font-semibold text-slate-900 transition hover:bg-slate-200"
                >
                  {slide.ctaLabel}
                </Link>
              </div>
            </div>
          </article>
        ))}

        <button
          type="button"
          onClick={showPrevious}
          className="absolute left-3 top-1/2 -translate-y-1/2 rounded-full border border-white/30 bg-white/15 p-2 text-white backdrop-blur transition hover:bg-white/25"
          aria-label="Previous slide"
        >
          <svg
            viewBox="0 0 24 24"
            className="h-5 w-5"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            aria-hidden="true"
          >
            <path d="m15 18-6-6 6-6" />
          </svg>
        </button>

        <button
          type="button"
          onClick={showNext}
          className="absolute right-3 top-1/2 -translate-y-1/2 rounded-full border border-white/30 bg-white/15 p-2 text-white backdrop-blur transition hover:bg-white/25"
          aria-label="Next slide"
        >
          <svg
            viewBox="0 0 24 24"
            className="h-5 w-5"
            fill="none"
            stroke="currentColor"
            strokeWidth="2"
            aria-hidden="true"
          >
            <path d="m9 18 6-6-6-6" />
          </svg>
        </button>

        <div className="absolute bottom-5 left-1/2 flex -translate-x-1/2 items-center gap-2">
          {slides.map((slide, index) => (
            <button
              key={slide.title}
              type="button"
              onClick={() => setActiveIndex(index)}
              className={`h-2.5 rounded-full transition-all ${
                activeIndex === index ? "w-8 bg-white" : "w-2.5 bg-white/50"
              }`}
              aria-label={`Go to slide ${index + 1}`}
            />
          ))}
        </div>
      </div>
    </section>
  );
}
