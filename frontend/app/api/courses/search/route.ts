import { NextRequest, NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

export async function GET(request: NextRequest) {
  try {
    const query = request.nextUrl.searchParams.get("q") ?? "";
    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/courses/search?q=${encodeURIComponent(query)}`;

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
    console.error("Error searching courses:", error);
    return NextResponse.json(
      { error: "Failed to search courses." },
      { status: 500 },
    );
  }
}
