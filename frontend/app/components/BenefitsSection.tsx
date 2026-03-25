const benefits = [
    {
        title: "Reduced Costs",
        description:
            "Choose courses with purpose so you avoid taking extra classes that do not move you closer to graduation.",
        toneClass: "from-amber-100 to-orange-100",
    },
    {
        title: "Optimized Paths",
        description:
            "Get clearer plans that balance prerequisites, availability, and your personal academic interests.",
        toneClass: "from-cyan-100 to-sky-100",
    },
    {
        title: "Increased Efficiency",
        description:
            "Build schedules faster with recommendation support that is available during every registration cycle.",
        toneClass: "from-emerald-100 to-teal-100",
    },
];

export default function BenefitsSection() {
    return (
        <section
            id="benefits"
            className="py-16 sm:py-24"
        >
            <div className="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
                <div className="mx-auto max-w-2xl text-center">
                    <p className="text-sm font-semibold uppercase tracking-[0.18em] text-orange-700">
                        Why Tuffy Plan
                    </p>
                    <h2 className="mt-3 text-3xl font-bold text-slate-900 sm:text-4xl">
                        Smarter planning from first semester to graduation
                    </h2>
                </div>

                <div className="mt-10 grid gap-5 md:grid-cols-3">
                    {benefits.map((item) => (
                        <article
                            key={item.title}
                            className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-lg"
                        >
                            <div
                                className={`mb-4 h-12 w-12 rounded-full  ${item.toneClass}`}
                                aria-hidden="true"
                            />
                            <h3 className="text-xl font-semibold text-slate-900">{item.title}</h3>
                            <p className="mt-2 text-sm leading-7 text-slate-600">
                                {item.description}
                            </p>
                        </article>
                    ))}
                </div>
            </div>
        </section>
    );
}
