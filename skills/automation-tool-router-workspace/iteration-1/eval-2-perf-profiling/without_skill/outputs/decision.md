## TOOL_CHOSEN
mcp__playwright__browser_navigate (Playwright MCP)

## REASONING
Playwright provides direct browser control with built-in support for Chrome DevTools Protocol (CDP), which is the foundation for performance tracing and Lighthouse-style metrics. It can emulate mobile device profiles (viewport, CPU throttling, network conditions) and capture performance entries, LCP timing, and resource waterfalls natively via `browser_evaluate` and `browser_network_requests`. No external CLI install is required since the MCP tool is already available in the toolbox.

## FIRST_COMMANDS
```
1. mcp__playwright__browser_navigate
   url: "https://fazla.com"
   -- Navigate to the target with default desktop profile to establish a baseline

2. mcp__playwright__browser_resize
   width: 390, height: 844
   -- Switch to iPhone 14 Pro viewport to simulate mobile

3. mcp__playwright__browser_evaluate
   script: |
     JSON.stringify({
       lcp: performance.getEntriesByType('largest-contentful-paint').map(e => ({startTime: e.startTime, size: e.size, element: e.element?.tagName, url: e.url})),
       cls: performance.getEntriesByType('layout-shift').reduce((sum, e) => sum + e.value, 0),
       fid_inp: performance.getEntriesByType('event').filter(e => e.processingStart).map(e => ({name: e.name, delay: e.processingStart - e.startTime})),
       navigation: performance.getEntriesByType('navigation')[0],
       resources: performance.getEntriesByType('resource').map(e => ({name: e.name, duration: e.duration, transferSize: e.transferSize, initiatorType: e.initiatorType})).sort((a,b)=>b.duration-a.duration).slice(0,20)
     })
   -- Dump Core Web Vitals and top 20 slowest resources from Performance API

4. mcp__playwright__browser_network_requests
   -- Capture full network waterfall: status codes, sizes, timing for all requests

5. mcp__playwright__browser_take_screenshot
   -- Visual confirmation of what loaded (detect render-blocking, missing images, layout issues)
```

## ESCALATION_PATH
If Playwright's in-page Performance API is insufficient (e.g., LCP observer fires too late or the page uses heavy SSR hydration that masks real bottlenecks), escalate to a WebFetch-based approach: use `mcp__fetch__fetch` to pull the raw HTML and headers, inspect `Cache-Control`, `Transfer-Encoding`, and resource hints (preload/preconnect) to identify server-side issues. As a further fallback, use `WebSearch` to retrieve a public PageSpeed Insights / CrUX report for fazla.com (Google's API returns field data that captures real-user LCP/INP/CLS without requiring a live browser trace).

## NOTES
- CPU throttling (4x slowdown typical for mid-range mobile) cannot be set via Playwright MCP's exposed tools alone — the `browser_evaluate` CDP call `chrome.gpuBenchmarking.smoothScrollBy` workaround is fragile. Real throttling requires the CDP `Emulation.setCPUThrottlingRate` method, which is only available if the MCP server exposes `browser_run_code_unsafe` with CDP access. This is worth attempting but may not be available.
- The Performance API's `largest-contentful-paint` entries are only populated after the page settles; a `browser_wait_for` step (waiting for `load` or a 3-second idle) should precede the evaluate call.
- fazla.com may have bot-detection (Cloudflare, etc.) that serves a challenge page to headless browsers — the screenshot will reveal this immediately.
- If the site requires authentication or has a cookie consent wall, interaction steps via `browser_click` will be needed before meaningful metrics can be gathered.
