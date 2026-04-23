"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";

export type DashboardPlanRow = {
  id: string;
  planName: string;
  catalogYear: string;
  dateRequested: string;
};

type SortKey = "planName" | "catalogYear" | "dateRequested";
type SortDirection = "asc" | "desc";

type DashboardTableProps = {
  rows: DashboardPlanRow[];
  googleUid?: string;
};

const pageSize = 6;

export default function DashboardTable({ rows, googleUid }: DashboardTableProps) {
  const [tableRows, setTableRows] = useState(rows);
  const [searchQuery, setSearchQuery] = useState("");
  const [sortKey, setSortKey] = useState<SortKey>("dateRequested");
  const [sortDirection, setSortDirection] = useState<SortDirection>("asc");
  const [currentPage, setCurrentPage] = useState(1);
  const [message, setMessage] = useState("");
  const [deletingPlanId, setDeletingPlanId] = useState<string | null>(null);

  useEffect(() => {
    setTableRows(rows);
  }, [rows]);

  const filteredRows = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();

    return tableRows.filter((row) => {
      const matchesQuery =
        normalizedQuery.length === 0 ||
        row.planName.toLowerCase().includes(normalizedQuery) ||
        row.catalogYear.toLowerCase().includes(normalizedQuery) ||
        row.dateRequested.toLowerCase().includes(normalizedQuery);

      return matchesQuery;
    });
  }, [tableRows, searchQuery]);

  const sortedRows = useMemo(() => {
    const sorted = [...filteredRows].sort((a, b) => {
      const direction = sortDirection === "asc" ? 1 : -1;

      return String(a[sortKey]).localeCompare(String(b[sortKey])) * direction;
    });

    return sorted;
  }, [filteredRows, sortDirection, sortKey]);

  const pageCount = Math.max(1, Math.ceil(sortedRows.length / pageSize));
  const safeCurrentPage = Math.min(currentPage, pageCount);
  const start = (safeCurrentPage - 1) * pageSize;
  const pagedRows = sortedRows.slice(start, start + pageSize);

  const setSort = (nextKey: SortKey) => {
    if (sortKey === nextKey) {
      setSortDirection((direction) => (direction === "asc" ? "desc" : "asc"));
      return;
    }

    setSortKey(nextKey);
    setSortDirection("asc");
  };

  const handleDeletePlan = async (planId: string, planName: string) => {
    if (!googleUid) {
      setMessage("Sign in again, then try deleting this plan.");
      return;
    }

    setDeletingPlanId(planId);
    setMessage("");

    try {
      const response = await fetch(
        `/api/plans/${encodeURIComponent(planId)}?google_uid=${encodeURIComponent(googleUid)}`,
        {
          method: "DELETE",
        },
      );

      const data = (await response.json()) as { error?: string; message?: string };

      if (!response.ok) {
        throw new Error(data.error || "Failed to delete plan.");
      }

      setTableRows((current) => current.filter((row) => row.id !== planId));
      setMessage(data.message || `${planName} deleted successfully.`);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Failed to delete plan.");
    } finally {
      setDeletingPlanId(null);
    }
  };

  return (
    <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
      <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
        <div>
          <h2 className="text-xl font-bold text-slate-900">Your Plans</h2>
          <p className="mt-1 text-sm text-slate-600">
            Table UI is ready for API data integration.
          </p>
        </div>

        <div className="grid gap-3 sm:grid-cols-[minmax(260px,1fr)_auto] sm:items-end">
          <label className="text-sm text-slate-600">
            <span className="mb-1 block font-medium">Search</span>
            <input
              value={searchQuery}
              onChange={(event) => {
                setSearchQuery(event.target.value);
                setCurrentPage(1);
              }}
              placeholder="Search plan, catalog year, date"
              className="w-full rounded-lg border border-slate-300 bg-white px-3 py-2 text-slate-900 outline-none transition placeholder:text-slate-400 focus:border-cyan-500 focus:ring-2 focus:ring-cyan-200"
            />
          </label>
          <Link
            href="/request"
            className="rounded-lg bg-slate-900 px-4 py-2.5 text-sm font-semibold text-white transition hover:bg-slate-700"
          >
            Request Plan
          </Link>
        </div>
      </div>

      <div className="mt-5 overflow-x-auto rounded-xl border border-slate-200">
        <table className="min-w-full divide-y divide-slate-200 text-left text-sm">
          <thead className="bg-slate-50">
            <tr className="text-xs uppercase tracking-[0.08em] text-slate-500">
              <th className="px-4 py-3 font-semibold">#</th>
              <th className="px-4 py-3">
                <button type="button" onClick={() => setSort("planName")} className="font-semibold">
                  Plan
                </button>
              </th>
              <th className="px-4 py-3">
                <button type="button" onClick={() => setSort("catalogYear")} className="font-semibold">
                  Catalog Year
                </button>
              </th>
              <th className="px-4 py-3">
                <button
                  type="button"
                  onClick={() => setSort("dateRequested")}
                  className="font-semibold"
                >
                  Date Requested
                </button>
              </th>
              <th className="px-4 py-3 font-semibold">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100 bg-white">
            {pagedRows.length > 0 ? (
              pagedRows.map((row, index) => (
                <tr key={row.id} className="text-slate-700 hover:bg-slate-50/70">
                  <td className="whitespace-nowrap px-4 py-3 font-semibold text-slate-900">
                    {start + index + 1}
                  </td>
                  <td className="px-4 py-3">{row.planName}</td>
                  <td className="whitespace-nowrap px-4 py-3">{row.catalogYear}</td>
                  <td className="whitespace-nowrap px-4 py-3">{row.dateRequested}</td>
                  <td className="whitespace-nowrap px-4 py-3">
                    <div className="flex items-center gap-2">
                      <Link
                        href={{
                          pathname: `/plan/${row.id}`,
                          query: googleUid ? { google_uid: googleUid } : undefined,
                        }}
                        className="rounded-md bg-blue-600 px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-blue-500"
                      >
                        View
                      </Link>
                      <button
                        type="button"
                        onClick={() => {
                          void handleDeletePlan(row.id, row.planName);
                        }}
                        disabled={deletingPlanId === row.id}
                        className="rounded-md bg-red-600 px-3 py-1.5 text-xs font-semibold text-white transition hover:bg-red-500"
                      >
                        {deletingPlanId === row.id ? "Deleting..." : "Delete"}
                      </button>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td className="px-4 py-8 text-center text-slate-500" colSpan={5}>
                  No rows match the current filters.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      <div className="mt-4 flex flex-col gap-3 text-sm text-slate-600 sm:flex-row sm:items-center sm:justify-between">
        <p>
          Showing {pagedRows.length > 0 ? start + 1 : 0}-{Math.min(start + pageSize, sortedRows.length)} of{" "}
          {sortedRows.length}
        </p>

        <div className="flex items-center gap-2">
          <button
            type="button"
            onClick={() => setCurrentPage((page) => Math.max(1, page - 1))}
            disabled={safeCurrentPage <= 1}
            className="rounded-lg border border-slate-300 px-3 py-1.5 font-medium text-slate-700 transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
          >
            Previous
          </button>
          <span className="px-1">
            Page {safeCurrentPage} / {pageCount}
          </span>
          <button
            type="button"
            onClick={() => setCurrentPage((page) => Math.min(pageCount, page + 1))}
            disabled={safeCurrentPage >= pageCount}
            className="rounded-lg border border-slate-300 px-3 py-1.5 font-medium text-slate-700 transition hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
          >
            Next
          </button>
        </div>
      </div>

      {message ? (
        <p className="mt-4 rounded-lg border border-cyan-200 bg-cyan-50 px-3 py-2 text-sm text-cyan-800">
          {message}
        </p>
      ) : null}
    </section>
  );
}
