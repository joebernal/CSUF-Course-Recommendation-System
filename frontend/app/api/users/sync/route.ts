import { NextResponse } from "next/server";

const backendBaseUrl = process.env.API_BASE_URL ?? "http://127.0.0.1:5001";

export async function POST(request: Request) {
  console.log("SYNC ROUTE HIT");

  const authorization = request.headers.get("authorization");
  console.log("Authorization exists:", !!authorization);

  if (!authorization) {
    return NextResponse.json(
      { error: "Missing Authorization header." },
      { status: 401 },
    );
  }

  let body: unknown;

  try {
    body = await request.json();
    console.log("Parsed request body:", body);
  } catch (error) {
    console.error("Failed to parse JSON body:", error);
    return NextResponse.json({ error: "Invalid JSON body." }, { status: 400 });
  }

  const upstreamUrl = `${backendBaseUrl.replace(/\/$/, "")}/api/users/`;
  console.log("Forwarding to Flask URL:", upstreamUrl);

  try {
    const upstreamResponse = await fetch(upstreamUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: authorization,
      },
      body: JSON.stringify(body),
      cache: "no-store",
    });

    console.log("Received upstream response status:", upstreamResponse.status);

    const rawText = await upstreamResponse.text();
    console.log("Received upstream raw text:", rawText);

    let parsed: unknown = {};

    if (rawText.length > 0) {
      try {
        parsed = JSON.parse(rawText);
      } catch {
        parsed = { message: rawText };
      }
    }

    return NextResponse.json(parsed, { status: upstreamResponse.status });
  } catch (error) {
    console.error("Error while calling Flask backend:", error);
    return NextResponse.json(
      { error: "Could not reach backend server." },
      { status: 500 },
    );
  }
}
