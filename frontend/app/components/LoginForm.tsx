"use client";

import { setClientSessionCookie } from "@/lib/auth/clientSession";
import { syncUserToApi } from "@/lib/api/syncUserToApi";
import { auth, googleProvider } from "@/lib/firebase/client";
import { FirebaseError } from "firebase/app";
import { signInWithEmailAndPassword, signInWithPopup } from "firebase/auth";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { FormEvent, useState } from "react";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

export default function LoginForm() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [message, setMessage] = useState("");
  const [isError, setIsError] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const getErrorMessage = (error: unknown) => {
    if (error instanceof FirebaseError) {
      switch (error.code) {
        case "auth/invalid-credential":
        case "auth/wrong-password":
        case "auth/user-not-found":
          return "Invalid email or password.";
        case "auth/too-many-requests":
          return "Too many attempts. Please try again later.";
        case "auth/popup-closed-by-user":
          return "Google sign-in was canceled.";
        default:
          return "Authentication failed. Please try again.";
      }
    }

    if (error instanceof Error) {
      return error.message;
    }

    return "Something went wrong. Please try again.";
  };

  const handleEmailLogin = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (!emailPattern.test(email.trim().toLowerCase())) {
      setIsError(true);
      setMessage("Please enter a valid email address.");
      return;
    }

    if (password.length < 8) {
      setIsError(true);
      setMessage("Password must be at least 8 characters.");
      return;
    }

    setIsLoading(true);
    setIsError(false);
    setMessage("");

    try {
      const credential = await signInWithEmailAndPassword(auth, email, password);
      setClientSessionCookie();
      await syncUserToApi(credential.user);
      setMessage("Signed in successfully. Redirecting...");
      router.push("/dashboard");
    } catch (error) {
      setIsError(true);
      setMessage(getErrorMessage(error));
    } finally {
      setIsLoading(false);
    }
  };

  const handleGoogleLogin = async () => {
    setIsLoading(true);
    setIsError(false);
    setMessage("");

    try {
      const credential = await signInWithPopup(auth, googleProvider);
      setClientSessionCookie();
      await syncUserToApi(credential.user);
      setMessage("Signed in with Google. Redirecting...");
      router.push("/dashboard");
    } catch (error) {
      setIsError(true);
      setMessage(getErrorMessage(error));
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <form onSubmit={handleEmailLogin} className="space-y-5" noValidate>
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
          autoComplete="current-password"
          required
          minLength={8}
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          placeholder="Password"
          className="w-full border-b border-slate-300 bg-transparent px-0 py-2 text-lg text-slate-900 outline-none transition placeholder:text-slate-500 focus:border-slate-500"
        />
      </div>

      <button
        type="submit"
        disabled={isLoading}
        className="w-full rounded-full bg-[#082c5e] px-4 py-2.5 text-xl font-semibold text-white transition hover:bg-[#0a3c7f]"
      >
        {isLoading ? "Logging in..." : "Log in"}
      </button>

      <div className="h-px bg-slate-300" />

      <button
        type="button"
        onClick={handleGoogleLogin}
        disabled={isLoading}
        className="inline-flex w-full items-center justify-center gap-2 rounded-full border border-blue-200 bg-white px-4 py-2.5 text-2xl font-medium text-slate-700 transition hover:border-blue-300 hover:bg-slate-50"
      >
        <svg viewBox="0 0 24 24" aria-hidden="true" className="h-4 w-4">
          <path
            fill="currentColor"
            d="M21.35 11.1H12v2.98h5.36c-.23 1.54-1.75 4.52-5.36 4.52-3.22 0-5.84-2.66-5.84-5.94S8.78 6.72 12 6.72c1.83 0 3.05.78 3.75 1.46l2.56-2.47C16.68 4.2 14.54 3.3 12 3.3 7.2 3.3 3.3 7.2 3.3 12s3.9 8.7 8.7 8.7c5.02 0 8.34-3.52 8.34-8.48 0-.57-.06-.99-.13-1.42Z"
          />
        </svg>
        Sign in with Google
      </button>

      <p className="pt-1 text-center text-2xl text-slate-700">
        <Link href="#" className="underline decoration-slate-500 underline-offset-2 hover:text-slate-900">
          Forgot your password?
        </Link>
      </p>

      <p className="pt-2 text-center text-2xl text-slate-700">
        Don&apos;t have an account?{" "}
        <Link href="/register" className="underline decoration-slate-500 underline-offset-2 hover:text-slate-900">
          Sign Up
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
