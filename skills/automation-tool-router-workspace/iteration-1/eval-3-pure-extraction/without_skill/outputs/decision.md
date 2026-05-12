## TOOL_CHOSEN
mcp__fetch__fetch

## REASONING
Hacker News serves its front page as plain HTML with a well-known, stable structure — no JavaScript rendering required. `mcp__fetch__fetch` can retrieve the raw HTML in a single call and return it as markdown, making it the lightest, fastest path for a pure read-only extraction with no interaction needed. No browser automation overhead is warranted when the page is static and publicly accessible.

## FIRST_COMMANDS
```
1. mcp__fetch__fetch(url="https://news.ycombinator.com/", max_length=50000)
   # Retrieve the front page; capture raw HTML or auto-converted markdown

2. # Parse the returned content for the repeating row pattern:
   #   <tr class="athing"> → title + submission link
   #   next <tr>           → score span + comments anchor
   # Extract: rank, title, href, score, comments URL

3. # Build markdown output, one entry per story, e.g.:
   #   ## 1. <Title>
   #   Score: 312 | [Discussion](https://news.ycombinator.com/item?id=XXXXX)

4. Write assembled markdown to a local file, e.g.:
   /Users/ae/Downloads/hn-frontpage-<YYYY-MM-DD>.md

5. (optional) Verify: count lines / entries to confirm ~30 stories captured
```

## ESCALATION_PATH
If `mcp__fetch__fetch` returns truncated content or fails (network error, rate-limit):
1. Fall back to `WebFetch` tool — same single-request approach, different underlying client.
2. If the page requires cookie acceptance or JS rendering in the future, escalate to `mcp__playwright__browser_navigate` + `mcp__playwright__browser_snapshot` to get a rendered DOM snapshot, then extract from that.

## NOTES
- Hacker News HTML is famously minimal and stable; no JS execution is needed for the front page.
- The fetch result may already be converted to markdown by the tool; if so, a light regex pass is enough to strip non-story content (nav, footer, ads).
- `max_length` may need tuning — 30 stories × ~200 chars each is well under typical limits.
- No authentication, cookies, or session state required.
- Offline reading is the goal, so saving the output as a local `.md` file completes the task.
