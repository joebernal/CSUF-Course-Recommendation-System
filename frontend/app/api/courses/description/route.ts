import { NextRequest, NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

export async function GET(request: NextRequest) {
  try {
    const courseCode = request.nextUrl.searchParams.get("course_code") ?? "";
    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/courses/description?course_code=${encodeURIComponent(courseCode)}`;

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
    console.error("Error getting course description:", error);
    return NextResponse.json(
      { error: "Failed to get course description." },
      { status: 500 },
    );
  }
}
