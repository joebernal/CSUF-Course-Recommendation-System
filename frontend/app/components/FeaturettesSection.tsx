const featurettes = [
  {
    title: "Requirement-aware recommendations",
    description:
      "See options that still align with your degree pathway, so your curiosity and your requirements work together.",
    artClass: "from-slate-900 via-blue-900 to-blue-700",
  },
  {
    title: "Semester-by-semester momentum",
    description:
      "Plan forward with confidence by mapping a sequence that reduces bottlenecks and keeps progress steady.",
    artClass: "from-orange-700 via-amber-600 to-yellow-400",
  },
  {
    title: "Anytime planning support",
    description:
      "Get immediate course guidance before enrollment windows, without waiting for advising appointments.",
    artClass: "from-emerald-700 via-teal-600 to-cyan-500",
  },
];

export default function FeaturettesSection() {
  return (
    <section id="features" className="py-16 sm:py-24">
      <div className="mx-auto max-w-6xl space-y-12 px-4 sm:px-6 lg:px-8">
        {featurettes.map((item, index) => (
          <article
            key={item.title}
            className="grid items-center gap-6 rounded-3xl border border-slate-200 bg-white p-6 shadow-sm md:grid-cols-2"
          >
            <div className={index % 2 === 1 ? "md:order-2" : ""}>
              <h3 className="text-2xl font-bold text-slate-900 sm:text-3xl">
                {item.title}
              </h3>
              <p className="mt-3 text-base leading-8 text-slate-600">
                {item.description}
              </p>
            </div>
            <div
              className={`relative h-52 overflow-hidden rounded-2xl bg-gradient-to-br ${item.artClass} sm:h-64 ${
                index % 2 === 1 ? "md:order-1" : ""
              }`}
              aria-hidden="true"
            >
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_20%_20%,rgba(255,255,255,0.28),transparent_38%),radial-gradient(circle_at_75%_80%,rgba(255,255,255,0.2),transparent_40%)]" />
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
