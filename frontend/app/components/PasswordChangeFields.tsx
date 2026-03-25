type PasswordChangeFieldsProps = {
  currentPassword: string;
  newPassword: string;
  confirmPassword: string;
  onCurrentPasswordChange: (value: string) => void;
  onNewPasswordChange: (value: string) => void;
  onConfirmPasswordChange: (value: string) => void;
};

export default function PasswordChangeFields({
  currentPassword,
  newPassword,
  confirmPassword,
  onCurrentPasswordChange,
  onNewPasswordChange,
  onConfirmPasswordChange,
}: PasswordChangeFieldsProps) {
  return (
    <fieldset className="space-y-4 rounded-xl border border-slate-200 bg-white p-4">
      <legend className="px-1 text-sm font-semibold text-slate-700">Change Password</legend>

      <div>
        <label htmlFor="currentPassword" className="mb-2 block text-sm font-medium text-slate-700">
          Current Password
        </label>
        <input
          id="currentPassword"
          name="currentPassword"
          type="password"
          value={currentPassword}
          onChange={(event) => onCurrentPasswordChange(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          placeholder="Current password"
        />
      </div>

      <div>
        <label htmlFor="newPassword" className="mb-2 block text-sm font-medium text-slate-700">
          New Password
        </label>
        <input
          id="newPassword"
          name="newPassword"
          type="password"
          value={newPassword}
          onChange={(event) => onNewPasswordChange(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          placeholder="At least 8 characters"
        />
      </div>

      <div>
        <label htmlFor="confirmPassword" className="mb-2 block text-sm font-medium text-slate-700">
          Confirm New Password
        </label>
        <input
          id="confirmPassword"
          name="confirmPassword"
          type="password"
          value={confirmPassword}
          onChange={(event) => onConfirmPasswordChange(event.target.value)}
          className="w-full rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-900 outline-none transition focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
          placeholder="Re-enter new password"
        />
      </div>
    </fieldset>
  );
}
