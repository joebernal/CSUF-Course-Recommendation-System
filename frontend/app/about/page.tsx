import Navbar from "@/app/components/Navbar";

const teamMembers = [
    {
        name: "Joe Bernal",
        role: "Project Manager",
        description: "Some description.",
        githubUrl: "https://github.com",
    },
    {
        name: "Owin Rojas",
        role: "Frontend Developer",
        description: "Some description.",
        githubUrl: "https://github.com",
    },
    {
        name: "Jesse Mendoze",
        role: "Database Engineer",
        description: "Some description.",
        githubUrl: "https://github.com",
    },
    {
        name: "Adnaan Dejay",
        role: "Backend Developer",
        description: "Some description.",
        githubUrl: "https://github.com",
    },
];

export default function About() {
    return (
        <div className="flex min-h-screen flex-col text-slate-900">
            <Navbar />

            <main className="mx-auto w-full max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
                <h1 className="text-center text-4xl font-bold">About Tuffy Plan</h1>
                <p className="mx-auto mt-6 max-w-3xl text-center text-lg text-slate-700">
                    Tuffy Plan is a course planning tool designed to help students at the California
                    State University, Fullerton (CSUF) create and manage their academic plans. Our
                    mission is to simplify the course selection process, allowing students to focus on
                    their academic goals and make informed decisions about their education.
                </p>

                <section className="mt-12">
                    <h2 className="text-2xl font-semibold">Our Story</h2>
                    <p className="mt-4 text-slate-700">
                        Tuffy Plan was born out of the frustration that many students experience when
                        trying to navigate the complex course offerings and degree requirements at CSUF.
                        We wanted to create a tool that would make it easier for students to visualize
                        their academic journey and ensure they are on track for graduation.
                    </p>
                </section>

                <section className="mt-12">
                    <h2 className="text-2xl font-semibold">About Us</h2>
                    <p className="mt-3 text-slate-700">Meet the developers.</p>

                    <div className="mt-6 grid grid-cols-1 gap-6 md:grid-cols-2">
                        {teamMembers.map((member) => (
                            <article key={member.name} className="rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
                                <h3 className="text-lg font-semibold">{member.name}</h3>
                                <p className="mt-1 text-sm text-slate-500">{member.role}</p>
                                <p className="mt-3 text-slate-700">{member.description}</p>
                                <a
                                    href={member.githubUrl}
                                    target="_blank"
                                    rel="noreferrer"
                                    className="mt-4 inline-flex rounded-md border border-blue-300 px-3 py-1.5 text-sm font-medium text-blue-700 transition hover:bg-blue-50"
                                >
                                    GitHub Profile
                                </a>
                            </article>
                        ))}
                    </div>
                </section>
            </main>
        </div>
    );
}