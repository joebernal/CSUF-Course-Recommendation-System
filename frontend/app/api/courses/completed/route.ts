import { NextRequest, NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

export async function GET(request: NextRequest) {
  try {
    const googleUid = request.nextUrl.searchParams.get("google_uid") ?? "";
    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/courses/completed?google_uid=${encodeURIComponent(googleUid)}`;

    const response = await fetch(upstreamUrl, {
      method: "GET",
      cache: "no-store",
    });

    const text = await response.text();
    let data: unknown = {};

    if (text) {
      try {
        data = JSON.parse(text);
      } catch {
        data = { message: text };
      }
    }

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error("Error getting completed courses:", error);
    return NextResponse.json(
      { error: "Failed to get completed courses." },
      { status: 500 },
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/courses/completed`;

    const response = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
      cache: "no-store",
    });

    const text = await response.text();
    let data: unknown = {};

    if (text) {
      try {
        data = JSON.parse(text);
      } catch {
        data = { message: text };
      }
    }

    return NextResponse.json(data, { status: response.status });
  } catch (error) {
    console.error("Error adding completed course:", error);
    return NextResponse.json(
      { error: "Failed to add completed course." },
      { status: 500 },
    );
  }
}
