import { NextResponse } from "next/server";

const backendBaseUrl =
  process.env.API_BASE_URL ??
  process.env.NEXT_PUBLIC_API_BASE_URL ??
  "http://127.0.0.1:5001";

export async function POST(request: Request) {
  let body: unknown;

  try {
    body = await request.json();
  } catch {
    return NextResponse.json({ errors: ["Invalid JSON body"] }, { status: 400 });
  }

  const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/plans/`;

  const upstreamResponse = await fetch(upstreamUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
    cache: "no-store",
  });

  const rawText = await upstreamResponse.text();
  let parsed: unknown = {};

  if (rawText.length > 0) {
    try {
      parsed = JSON.parse(rawText);
    } catch {
      parsed = { message: rawText };
    }
  }

  return NextResponse.json(parsed, { status: upstreamResponse.status });
}
