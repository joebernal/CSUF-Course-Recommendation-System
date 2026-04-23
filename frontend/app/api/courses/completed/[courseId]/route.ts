import { NextRequest, NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

type Params = {
  params: Promise<{ courseId: string }>;
};

export async function DELETE(request: NextRequest, { params }: Params) {
  try {
    const { courseId } = await params;
    const googleUid = request.nextUrl.searchParams.get("google_uid") ?? "";

    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/courses/completed/${encodeURIComponent(courseId)}?google_uid=${encodeURIComponent(googleUid)}`;

    const response = await fetch(upstreamUrl, {
      method: "DELETE",
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
    console.error("Error removing completed course:", error);
    return NextResponse.json(
      { error: "Failed to remove completed course." },
      { status: 500 },
    );
  }
}
