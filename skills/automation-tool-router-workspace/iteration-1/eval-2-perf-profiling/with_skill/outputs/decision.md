## TOOL_CHOSEN
chrome-devtools-mcp

## REASONING
The task explicitly asks for a performance trace, LCP diagnosis, and Core Web Vitals analysis — this maps directly to the "Perf profiling, Core Web Vitals, heap snapshots, Lighthouse" row in the decision matrix, which names `chrome-devtools-mcp` as the correct tool. It has DevTools Protocol access, which is required to capture timeline traces, measure paint timings, and surface LCP candidates that general browser automation tools cannot expose. No other tool in the escalation order reaches this level of profiling depth.

## FIRST_COMMANDS
```
# 1. Launch Chrome with remote debugging enabled, targeting the mobile viewport
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --window-size=390,844 \
  --user-agent="Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

# 2. Add chrome-devtools-mcp to the MCP server list (if not already present)
claude mcp add chrome-devtools npx -- chrome-devtools-mcp@latest

# 3. Navigate to fazla.com and start a performance trace (via chrome-devtools-mcp tool calls)
# — open page, begin tracing, capture network + rendering events
DevTools: navigate to https://fazla.com

# 4. Capture a full Lighthouse / CWV audit for mobile
DevTools: run Lighthouse audit --preset mobile --categories performance

# 5. Extract the trace and surface the top LCP candidate, TBT, CLS, FCP timings
DevTools: get performance trace --metrics LCP,FCP,TBT,CLS,INP --export /tmp/fazla-trace.json
```

## ESCALATION_PATH
If `chrome-devtools-mcp` cannot connect (Chrome not running on port 9222, or MCP server fails to initialize): fall back to `agent-browser` with `--headed` to open the page, then use the `screenshot` and `snapshot` commands to manually inspect render order as a rough proxy. If the site blocks headless Chrome entirely (Cloudflare, bot detection): escalate to `Stagehand` (Browserbase cloud) which runs in a real browser environment — Lighthouse-level metrics won't be available there, but resource waterfall and timing headers can still be inspected via network intercept.

## NOTES
- Anti-patterns avoided: did not reach for `playwright-mcp` by default (would cost ~13.7K tokens in schema before any work); did not use `agent-browser` (it has no DevTools Protocol access and cannot capture CWV metrics); did not use `Peekaboo` (OS-level events are opaque to performance tooling).
- Env requirement: Chrome must be launched with `--remote-debugging-port=9222` before `chrome-devtools-mcp` can connect — it does not launch Chrome itself.
- Mobile simulation is done via user-agent string and viewport flags on Chrome launch, not a real device; results approximate mobile conditions (CPU throttling can be added with `--js-flags` or via DevTools throttling API for more realism).
- Lighthouse in mobile preset applies 4x CPU slowdown and Slow 4G network throttling automatically, which will surface LCP regressions that only appear on low-end hardware.
