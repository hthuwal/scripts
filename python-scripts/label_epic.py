#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["requests", "rich", "ratelimit"]
# ///
"""
Recursively add labels to all issues under a Jira epic.

Usage:
    label_epic --url URL --email EMAIL --token-file PATH [--preview-file PATH] EPIC-KEY label1 [label2 ...]
"""

import argparse
import json
import os
import sys
import time

import requests
from ratelimit import limits, sleep_and_retry
from requests.auth import HTTPBasicAuth
from rich.console import Console
from rich.progress import (
    BarColumn,
    MofNCompleteColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
)
from rich.table import Table

console = Console()

HEADERS = {"Accept": "application/json", "Content-Type": "application/json"}
BULK_CHUNK_SIZE = 100


# ---------------------------------------------------------------------------
# Jira API helpers
# ---------------------------------------------------------------------------


@sleep_and_retry
@limits(calls=30, period=60)
def _jira_request(method, url, **kwargs):
    """Rate-limited HTTP request: at most 30 calls per minute to the Jira API.

    Blocks automatically when the limit is reached and retries once the window
    resets. All Jira API calls must go through this function.
    """
    return requests.request(method, url, **kwargs)


def get_issue(key, jira_url, auth):
    """Fetch a single issue by key and return its full JSON representation."""
    r = _jira_request(
        "GET", f"{jira_url}/rest/api/3/issue/{key}", auth=auth, headers=HEADERS
    )
    r.raise_for_status()
    return r.json()


def search_issues(jql, jira_url, auth):
    """Run a JQL search and return all matching issues, handling cursor-based pagination."""
    issues = []
    next_page_token = None
    while True:
        body = {
            "jql": jql,
            "maxResults": 100,
            "fields": ["key", "summary", "issuetype"],
        }
        if next_page_token:
            body["nextPageToken"] = next_page_token

        r = _jira_request(
            "POST",
            f"{jira_url}/rest/api/3/search/jql",
            auth=auth,
            headers=HEADERS,
            data=json.dumps(body),
        )
        if not r.ok:
            raise requests.HTTPError(
                f"{r.status_code} for JQL [{jql}]: {r.text[:300]}", response=r
            )
        data = r.json()
        issues.extend(data["issues"])
        if data.get("isLast", True) or not data["issues"]:
            break
        next_page_token = data.get("nextPageToken")
        if not next_page_token:
            break
    return issues


def bulk_label_batch(keys, labels, jira_url, auth):
    """POST a single bulk-edit request adding labels to up to 1000 issues.

    Uses the ADD action so existing labels are preserved. Returns the Jira
    taskId string on success, or None if the request was rejected.
    """
    payload = {
        "selectedIssueIdsOrKeys": keys,
        "selectedActions": ["labels"],
        "editedFieldsInput": {
            "labelsFields": [
                {
                    "fieldId": "labels",
                    "bulkEditMultiSelectFieldOption": "ADD",
                    "labels": [{"name": label} for label in labels],
                }
            ]
        },
        "sendBulkNotification": True,
    }
    r = _jira_request(
        "POST",
        f"{jira_url}/rest/api/3/bulk/issues/fields",
        auth=auth,
        headers=HEADERS,
        data=json.dumps(payload),
    )
    if r.status_code != 201:
        console.print(
            f"  [red]Bulk edit submission failed:[/red] {r.status_code} {r.text[:200]}"
        )
        return None
    return r.json()["taskId"]


def poll_task(task_id, jira_url, auth, progress, poll_task_id):
    """Poll GET /bulk/queue/{taskId} every 2 s until the task reaches a terminal state.

    Updates the rich progress row identified by poll_task_id with live status.
    Returns the final task response dict.
    """
    while True:
        r = _jira_request(
            "GET",
            f"{jira_url}/rest/api/3/bulk/queue/{task_id}",
            auth=auth,
            headers=HEADERS,
        )
        r.raise_for_status()
        data = r.json()
        status = data.get("status", "UNKNOWN")
        pct = data.get("progressPercent", 0)
        progress.update(poll_task_id, description=f"  [cyan]{status}[/cyan] ({pct}%)")
        if status in ("COMPLETE", "FAILED", "CANCEL_REQUESTED", "CANCELLED"):
            return data
        time.sleep(2)


# ---------------------------------------------------------------------------
# Issue collection
# ---------------------------------------------------------------------------


def collect_all_issues(epic_key, jira_url, auth):
    """Collect the epic and all its descendants using iterative BFS.

    Algorithm:
        1. Seed the queue with the root epic (fetched via get_issue).
        2. Pop an issue from the queue. Skip if already visited.
        3. Record the issue and mark it visited.
        4. If the issue type is a sub-task (issuetype.subtask == True), it is a
           leaf node by definition — sub-tasks cannot have children in Jira —
           so skip the children search entirely.
        5. Otherwise, query `parent = KEY` to fetch direct children. Push any
           unseen children (as full issue dicts) onto the queue.
        6. Repeat from step 2 until the queue is empty.

    Storing full issue dicts (not just keys) avoids an extra get_issue API call
    for every non-root node, since the search response already contains the
    fields we need (key, summary, issuetype).
    """
    visited = set()
    issues = []

    root = get_issue(epic_key, jira_url, auth)
    queue = [root]

    with Progress(
        SpinnerColumn(),
        TextColumn("{task.description}"),
        console=console,
        transient=True,
    ) as progress:
        task = progress.add_task("Collecting issues... 0 found", total=None)

        while queue:
            issue = queue.pop()
            key = issue["key"]
            if key in visited:
                continue
            visited.add(key)

            itype = issue["fields"].get("issuetype", {})
            type_name = itype.get("name", "?")
            is_leaf = itype.get("subtask", False)

            issues.append(
                {
                    "key": key,
                    "type": type_name,
                    "summary": issue["fields"].get("summary", ""),
                }
            )
            progress.update(
                task, description=f"Collecting issues... {len(issues)} found"
            )

            if not is_leaf:
                children = search_issues(f'parent = "{key}"', jira_url, auth)
                for child in children:
                    if child["key"] not in visited:
                        queue.append(child)

    return issues


# ---------------------------------------------------------------------------
# Preview file (JSON)
# ---------------------------------------------------------------------------


def write_preview(issues, epic_key, labels, path):
    """Persist the collected issue list to a JSON file for later reuse."""
    with open(path, "w") as f:
        json.dump({"epic": epic_key, "labels": labels, "issues": issues}, f, indent=2)


def load_preview(path):
    """Load and return the preview JSON file as a dict."""
    with open(path) as f:
        return json.load(f)


def print_preview(data):
    """Render the issue list as a rich table in the terminal."""
    table = Table(title=f"Epic: {data['epic']}  |  Labels: {', '.join(data['labels'])}")
    table.add_column("Key", style="cyan", no_wrap=True)
    table.add_column("Type", style="magenta")
    table.add_column("Summary")
    for issue in data["issues"]:
        table.add_row(issue["key"], issue["type"], issue["summary"])
    console.print(table)
    console.print(f"[dim]Total: {len(data['issues'])} issue(s)[/dim]\n")


# ---------------------------------------------------------------------------
# Bulk labeling
# ---------------------------------------------------------------------------


def label_all(issues, labels, jira_url, auth):
    """Split issues into BULK_CHUNK_SIZE batches, submit each as a bulk label request,
    and poll until every batch completes. Displays a live progress bar.
    """
    keys = [i["key"] for i in issues]
    chunks = [
        keys[i : i + BULK_CHUNK_SIZE] for i in range(0, len(keys), BULK_CHUNK_SIZE)
    ]

    with Progress(
        SpinnerColumn(),
        TextColumn("{task.description}"),
        BarColumn(),
        MofNCompleteColumn(),
        console=console,
    ) as progress:
        batch_task = progress.add_task("Labeling batches", total=len(chunks))
        poll_task_id = progress.add_task("", total=None)

        for idx, chunk in enumerate(chunks, 1):
            progress.update(
                batch_task,
                description=f"Batch {idx}/{len(chunks)} — submitting {len(chunk)} issues",
            )
            task_id = bulk_label_batch(chunk, labels, jira_url, auth)
            if task_id is None:
                progress.update(
                    poll_task_id, description="  [red]Skipped — submission error[/red]"
                )
                progress.advance(batch_task)
                continue

            progress.update(poll_task_id, description=f"  Batch {idx}: waiting...")
            result = poll_task(task_id, jira_url, auth, progress, poll_task_id)
            processed = len(result.get("processedAccessibleIssues", []))
            invalid = result.get("invalidOrInaccessibleIssueCount", 0)
            progress.update(
                poll_task_id,
                description=f"  Batch {idx}: [green]DONE[/green] — labeled {processed}, invalid {invalid}",
            )
            progress.advance(batch_task)


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def parse_args():
    """Define and parse CLI arguments. Returns the populated Namespace."""
    parser = argparse.ArgumentParser(
        description="Recursively add labels to all issues under a Jira epic."
    )
    parser.add_argument(
        "--url",
        metavar="URL",
        required=True,
        help="Jira base URL (e.g. https://yourorg.atlassian.net)",
    )
    parser.add_argument(
        "--email", metavar="EMAIL", required=True, help="Atlassian account email"
    )
    parser.add_argument(
        "--token-file",
        metavar="PATH",
        required=True,
        help="Path to a file containing the Jira API token",
    )
    parser.add_argument(
        "--preview-file",
        metavar="PATH",
        default="issues_preview.json",
        help="JSON file to cache the issue list (default: issues_preview.json)",
    )
    parser.add_argument("epic_key", help="Jira epic key (e.g. PROJ-123)")
    parser.add_argument("labels", nargs="+", help="One or more labels to apply")
    return parser.parse_args()


def resolve_config(args):
    """Resolve and validate Jira credentials. Returns (jira_url, auth) or exits."""
    jira_url = args.url.rstrip("/")

    try:
        with open(args.token_file) as f:
            lines = [line.strip() for line in f if line.strip()]
    except OSError as e:
        console.print(f"[red]Error reading token file:[/red] {e}")
        sys.exit(1)
    if not lines:
        console.print("[red]Error:[/red] token file is empty.")
        sys.exit(1)
    if len(lines) > 1:
        console.print(
            f"[yellow]Warning:[/yellow] token file has {len(lines)} lines; using the first line only."
        )
    jira_api_token = lines[0]

    return jira_url, HTTPBasicAuth(args.email, jira_api_token)


def main():
    """Entry point: parse args, optionally reuse a cached preview, collect issues,
    confirm with the user, then apply labels via the Jira bulk edit API.
    """
    args = parse_args()
    jira_url, auth = resolve_config(args)

    issues = None

    if os.path.exists(args.preview_file):
        try:
            data = load_preview(args.preview_file)
            console.print(f"\n[bold]Preview file found:[/bold] {args.preview_file}\n")
            print_preview(data)
            answer = (
                console.input(
                    "\\[[bold]a[/bold]]pply  \\[[bold]r[/bold]]ecollect  \\[[bold]N[/bold]] abort: "
                )
                .strip()
                .lower()
            )
            if answer == "a":
                issues = data["issues"]
            elif answer == "r":
                pass  # fall through to collection
            else:
                console.print("Aborted.")
                sys.exit(0)
        except (json.JSONDecodeError, KeyError):
            console.print(
                "[yellow]Warning:[/yellow] preview file is malformed, re-collecting."
            )

    if issues is None:
        console.print(f"\nEpic:   [cyan]{args.epic_key}[/cyan]")
        console.print(f"Labels: [cyan]{args.labels}[/cyan]\n")
        issues = collect_all_issues(args.epic_key, jira_url, auth)
        console.print(f"[green]✓[/green] Found {len(issues)} issue(s).")

        write_preview(issues, args.epic_key, args.labels, args.preview_file)
        console.print(f"Issue list saved to: [dim]{args.preview_file}[/dim]\n")
        print_preview({"epic": args.epic_key, "labels": args.labels, "issues": issues})

        answer = (
            console.input("[bold]Proceed with labeling?[/bold] [[bold]y[/bold]/N]: ")
            .strip()
            .lower()
        )
        if answer != "y":
            console.print("Aborted.")
            sys.exit(0)

    label_all(issues, args.labels, jira_url, auth)
    console.print("\n[bold green]Done.[/bold green]")


if __name__ == "__main__":
    main()
