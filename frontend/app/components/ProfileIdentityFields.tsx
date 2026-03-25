type ProfileIdentityFieldsProps = {
  name?: string;
  preferredLanguage: string;
  careerInterest: string;
  onNameChange?: (value: string) => void;
  onPreferredLanguageChange: (value: string) => void;
  onCareerInterestChange: (value: string) => void;
  includeName?: boolean;
};

export const languageOptions = ["Python", "Java", "C", "C#", "Other"];

export const careerInterestOptions = [
  "Web Development",
  "Artificial Intelligence",
  "Security",
  "Data Science",
  "Systems",
  "Game Development",
  "Undecided",
];

export default function ProfileIdentityFields({
  name,
  preferredLanguage,
  careerInterest,
  onNameChange,
  onPreferredLanguageChange,
  onCareerInterestChange,
  includeName = true,
}: ProfileIdentityFieldsProps) {
  return (
    <>
      {includeName ? (
        <div>
          <label htmlFor="name" className="mb-2 block text-sm font-medium text-slate-700">
            Name
          </label>
          <input
            id="name"
            name="name"
            type="text"
            value={name ?? ""}
            onChange={(event) => onNameChange?.(event.target.value)}
            className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            placeholder="Your name"
            required
          />
        </div>
      ) : null}

      <div>
        <label htmlFor="preferredLanguage" className="mb-2 block text-sm font-medium text-slate-700">
          Preferred Language
        </label>
        <select
          id="preferredLanguage"
          name="preferredLanguage"
          value={preferredLanguage}
          onChange={(event) => onPreferredLanguageChange(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
        >
          {languageOptions.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
      </div>

      <div>
        <label htmlFor="careerInterest" className="mb-2 block text-sm font-medium text-slate-700">
          Career Interest
        </label>
        <select
          id="careerInterest"
          name="careerInterest"
          value={careerInterest}
          onChange={(event) => onCareerInterestChange(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
        >
          {careerInterestOptions.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
      </div>
    </>
  );
}
