## TOOL_CHOSEN
Firecrawl

## REASONING
The task is pure read-only data extraction — no clicks, form fills, logins, or interaction of any kind are required. Firecrawl is explicitly listed in the decision matrix for "Pure data extraction, markdown/JSON output" as the right tool precisely because it has no interaction overhead. HackerNews is a public, bot-friendly site with no Cloudflare wall or auth gate, so there is no reason to escalate to a browser tool.

## FIRST_COMMANDS
```
# 1. Scrape the front page as markdown, targeting only the relevant content
firecrawl scrape https://news.ycombinator.com --format markdown --output /tmp/hn-frontpage.md

# 2. Optionally extract only the structured fields (title, score, discussion link)
firecrawl extract https://news.ycombinator.com \
  --prompt "Extract each story as an object with: title (string), score (number), discussion_url (string pointing to the item page on news.ycombinator.com)" \
  --output /tmp/hn-stories.json

# 3. If using the Firecrawl MCP server instead of CLI, the equivalent call is:
#    firecrawl_scrape({ url: "https://news.ycombinator.com", formats: ["markdown"] })

# 4. Verify output looks right
cat /tmp/hn-frontpage.md | head -80

# 5. Save for offline reading
cp /tmp/hn-frontpage.md ~/Downloads/hn-$(date +%Y%m%d).md
```

## ESCALATION_PATH
If Firecrawl fails (API key missing, rate limit, or the page returns a bot-redirect in future), escalate to **agent-browser**: `agent-browser open https://news.ycombinator.com` then `agent-browser snapshot` to grab the rendered DOM as compact markdown. No further escalation should be needed for this site — it has no bot detection and requires no authentication.

## NOTES
- Anti-patterns avoided: did NOT default to `playwright-mcp` (13.7K token schema cost for a zero-interaction task), did NOT use `agent-browser` when Firecrawl is the correct extraction-only tool, did NOT load multiple browser MCPs.
- Firecrawl requires a `FIRECRAWL_API_KEY` env var; the MCP server must be added via `claude mcp add firecrawl npx -- -y firecrawl-mcp` if not already configured.
- HackerNews is a public, static-ish page — no JS hydration required for titles/scores, so Firecrawl's fetch-based approach will succeed without a headless browser.
- The offline use case means output should be saved to disk, not just returned in-context.
