import { NextResponse } from "next/server";

const backendBaseUrl =
  process.env.API_BASE_URL ??
  process.env.NEXT_PUBLIC_API_BASE_URL ??
  "http://127.0.0.1:5001";

export async function GET() {
  const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/majors/`;

  try {
    const upstreamResponse = await fetch(upstreamUrl, {
      method: "GET",
      cache: "no-store",
    });

    const rawText = await upstreamResponse.text();
    let parsed: unknown = [];

    if (rawText.length > 0) {
      try {
        parsed = JSON.parse(rawText);
      } catch {
        parsed = { message: rawText };
      }
    }

    return NextResponse.json(parsed, { status: upstreamResponse.status });
  } catch {
    return NextResponse.json(
      { errors: ["Could not reach majors API server."] },
      { status: 502 }
    );
  }
}
