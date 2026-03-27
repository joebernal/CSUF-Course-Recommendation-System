import { NextRequest, NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/users/updateProfile`;
    const response = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });

    // Check if response has content and is JSON
    const contentType = response.headers.get("content-type");
    let data: any = {};

    if (contentType && contentType.includes("application/json")) {
      const text = await response.text();
      if (text) {
        data = JSON.parse(text);
      }
    } else {
      const text = await response.text();
      data = text ? { message: text } : { message: "Success" };
    }

    if (!response.ok) {
      return NextResponse.json(data || { error: "Failed to update profile" }, {
        status: response.status,
      });
    }

    return NextResponse.json(
      data || { message: "Profile updated successfully" },
      { status: 200 },
    );
  } catch (error) {
    console.error("Error updating profile:", error);
    return NextResponse.json(
      { error: "Failed to update profile" },
      { status: 500 },
    );
  }
}
