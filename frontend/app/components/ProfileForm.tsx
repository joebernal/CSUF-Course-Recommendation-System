"use client";

import { auth } from "@/lib/firebase/client";
import PasswordChangeFields from "@/app/components/PasswordChangeFields";
import ProfileIdentityFields from "@/app/components/ProfileIdentityFields";
import { onAuthStateChanged } from "firebase/auth";
import { FormEvent, useEffect, useState } from "react";

export default function ProfileForm() {
  const [uid, setUid] = useState("");
  const [name, setName] = useState("");
  const [preferredLanguage, setPreferredLanguage] = useState("Python");
  const [careerInterest, setCareerInterest] = useState("Undecided");
  const [currentPassword, setCurrentPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState("");
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (user) => {
      if (user) {
        setUid(user.uid);
        const displayName = user?.displayName?.trim();
        const emailPrefix = user?.email?.split("@")[0]?.trim();
        setName(displayName || emailPrefix || "");
      }
    });

    return () => unsubscribe();
  }, []);

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setMessage("");
    setIsError(false);

    if (!name.trim()) {
      setIsError(true);
      setMessage("Please provide your name.");
      return;
    }

    if (!uid) {
      setIsError(true);
      setMessage("You must be signed in to update your profile.");
      return;
    }

    if (newPassword || confirmPassword || currentPassword) {
      if (!currentPassword) {
        setIsError(true);
        setMessage("Enter current password to change password.");
        return;
      }

      if (newPassword.length < 8) {
        setIsError(true);
        setMessage("New password must be at least 8 characters.");
        return;
      }

      if (newPassword !== confirmPassword) {
        setIsError(true);
        setMessage("New password and confirm password do not match.");
        return;
      }
    }

    setIsLoading(true);

    try {
      const response = await fetch("/api/users/updateProfile", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          google_uid: uid,
          full_name: name.trim(),
          enrollmentStatus: null, // Not updated from profile form
          preferredTerms: { winter: false, summer: false }, // Not updated from profile form
          preferredLanguage,
          careerInterest,
        }),
      });

      const data = await response.json();

      if (!response.ok) {
        setIsError(true);
        setMessage(data.error || "Failed to update profile.");
      } else {
        setIsError(false);
        setMessage("Profile updated successfully!");
        // Reset password fields after successful update
        setCurrentPassword("");
        setNewPassword("");
        setConfirmPassword("");
      }
    } catch (error) {
      setIsError(true);
      setMessage("An error occurred while updating your profile.");
      console.error("Profile update error:", error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6" noValidate>
      <ProfileIdentityFields
        name={name}
        preferredLanguage={preferredLanguage}
        careerInterest={careerInterest}
        onNameChange={setName}
        onPreferredLanguageChange={setPreferredLanguage}
        onCareerInterestChange={setCareerInterest}
      />

      <PasswordChangeFields
        currentPassword={currentPassword}
        newPassword={newPassword}
        confirmPassword={confirmPassword}
        onCurrentPasswordChange={setCurrentPassword}
        onNewPasswordChange={setNewPassword}
        onConfirmPasswordChange={setConfirmPassword}
      />

      <button
        type="submit"
        disabled={isLoading}
        className="w-full rounded-xl bg-slate-900 px-4 py-3 text-sm font-semibold text-white transition hover:bg-slate-700 disabled:opacity-50"
      >
        {isLoading ? "Saving..." : "Save Changes"}
      </button>

      {message ? (
        <p
          className={`rounded-lg px-3 py-2 text-sm ${
            isError
              ? "border border-red-200 bg-red-50 text-red-800"
              : "border border-cyan-200 bg-cyan-50 text-cyan-800"
          }`}
        >
          {message}
        </p>
      ) : null}
    </form>
  );
}
