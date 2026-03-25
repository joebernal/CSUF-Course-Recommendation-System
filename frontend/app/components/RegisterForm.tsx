"use client";

import { setClientSessionCookie } from "@/lib/auth/clientSession";
import { syncUserToApi } from "@/lib/api/syncUserToApi";
import { auth, googleProvider } from "@/lib/firebase/client";
import { FirebaseError } from "firebase/app";
import {
  createUserWithEmailAndPassword,
  signInWithPopup,
  updateProfile,
} from "firebase/auth";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { FormEvent, useState } from "react";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function RegisterForm() {
  const router = useRouter();
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [message, setMessage] = useState("");
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const getErrorMessage = (error: unknown) => {
    if (error instanceof FirebaseError) {
      switch (error.code) {
        case "auth/email-already-in-use":
          return "That email is already registered.";
        case "auth/invalid-email":
          return "Please enter a valid email address.";
        case "auth/weak-password":
          return "Password is too weak. Use at least 8 characters.";
        case "auth/popup-closed-by-user":
          return "Google sign-up was canceled.";
        default:
          return "Registration failed. Please try again.";
      }
    }

    if (error instanceof Error) {
      return error.message;
    }

    return "Something went wrong. Please try again.";
  };

  const handleRegister = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    setMessage("");

    if (!emailPattern.test(email.trim().toLowerCase())) {
      setIsError(true);
      setMessage("Please enter a valid email address.");
      return;
    }

    if (password !== confirmPassword) {
      setIsError(true);
      setMessage("Passwords do not match.");
      return;
    }

    if (password.length < 8) {
      setIsError(true);
      setMessage("Password must be at least 8 characters.");
      return;
    }

    setIsLoading(true);

    try {
      const credential = await createUserWithEmailAndPassword(auth, email, password);
      setClientSessionCookie();
      const displayName = `${firstName} ${lastName}`.trim();

      if (displayName.length > 0) {
        await updateProfile(credential.user, { displayName });
      }

      await syncUserToApi(credential.user, {
        fullName: displayName,
      });

      setIsError(false);
      setMessage("Account created successfully. Redirecting to onboarding...");
      router.push("/onboarding");
    } catch (error) {
      setIsError(true);
      setMessage(getErrorMessage(error));
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleRegister = async () => {
    setIsLoading(true);
    setMessage("");

    try {
      const credential = await signInWithPopup(auth, googleProvider);
      setClientSessionCookie();
      await syncUserToApi(credential.user);
      setIsError(false);
      setMessage("Signed up with Google. Redirecting to onboarding...");
      router.push("/onboarding");
    } catch (error) {
      setIsError(true);
      setMessage(getErrorMessage(error));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleRegister} className="space-y-5" noValidate>
      <div className="grid gap-4 sm:grid-cols-2">
        <div>
          <input
            id="firstName"
            name="firstName"
            type="text"
            autoComplete="given-name"
            required
            value={firstName}
            onChange={(event) => setFirstName(event.target.value)}
            placeholder="First name"
            className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
          />
        </div>

        <div>
          <input
            id="lastName"
            name="lastName"
            type="text"
            autoComplete="family-name"
            required
            value={lastName}
            onChange={(event) => setLastName(event.target.value)}
            placeholder="Last name"
            className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
          />
        </div>
      </div>

      <div>
        <input
          id="email"
          name="email"
          type="email"
          autoComplete="email"
          required
          pattern="[^\s@]+@[^\s@]+\.[^\s@]+"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          placeholder="Email"
          className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
        />
      </div>

      <div>
        <input
          id="password"
          name="password"
          type="password"
          autoComplete="new-password"
          required
          minLength={8}
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          placeholder="Password"
          className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
        />
      </div>

      <div>
        <input
          id="confirmPassword"
          name="confirmPassword"
          type="password"
          autoComplete="new-password"
          required
          minLength={8}
          value={confirmPassword}
          onChange={(event) => setConfirmPassword(event.target.value)}
          placeholder="Confirm password"
          className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
        />
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full rounded-full bg-[#082c5e] px-4 py-2.5 text-xl font-semibold text-white transition hover:bg-[#0a3c7f]"
      >
        {isLoading ? "Creating account..." : "Create account"}
      </button>

      <div className="h-px bg-slate-300" />

      <button
        type="button"
        onClick={handleGoogleRegister}
        disabled={isLoading}
        className="inline-flex w-full items-center justify-center gap-2 rounded-full border border-blue-200 bg-white px-4 py-2.5 text-2xl font-medium text-slate-700 transition hover:border-blue-300 hover:bg-slate-50"
      >
        <svg viewBox="0 0 24 24" aria-hidden="true" className="h-4 w-4">
          <path
            fill="currentColor"
            d="M21.35 11.1H12v2.98h5.36c-.23 1.54-1.75 4.52-5.36 4.52-3.22 0-5.84-2.66-5.84-5.94S8.78 6.72 12 6.72c1.83 0 3.05.78 3.75 1.46l2.56-2.47C16.68 4.2 14.54 3.3 12 3.3 7.2 3.3 3.3 7.2 3.3 12s3.9 8.7 8.7 8.7c5.02 0 8.34-3.52 8.34-8.48 0-.57-.06-.99-.13-1.42Z"
          />
        </svg>
        Sign up with Google
      </button>

      <p className="pt-2 text-center text-2xl text-slate-700">
        Already have an account?{" "}
        <Link href="/login" className="underline decoration-slate-500 underline-offset-2 hover:text-slate-900">
          Sign In
        </Link>
      </p>

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
