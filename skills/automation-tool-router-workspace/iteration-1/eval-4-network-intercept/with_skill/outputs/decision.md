## TOOL_CHOSEN
Playwright CLI

## REASONING
This task requires intercepting live network traffic during a login form submission to inspect response headers — specifically the `Set-Cookie` header with `HttpOnly` and `SameSite` flags. Playwright CLI has first-class network interception (`page.on('response', ...)` and `request.allHeaders()`) and can programmatically inspect cookie attributes after a form submission in a single script. Agent-browser is the default, but it lacks the low-level network response header access needed here; the decision matrix explicitly lists "network intercept" as the Playwright CLI escalation trigger.

## FIRST_COMMANDS
```bash
# Install if needed
npm install -g @playwright/cli && npx playwright install chromium

# Write and run a one-off intercept script
npx playwright codegen https://staging.acme.test/login --output /tmp/login-intercept.js

# Or run a direct script to capture Set-Cookie on login POST:
npx playwright --version   # confirm available

node - <<'EOF'
const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();

  page.on('response', async (response) => {
    if (response.url().includes('/login') && response.request().method() === 'POST') {
      const headers = await response.allHeaders();
      const cookies = headers['set-cookie'];
      console.log('Set-Cookie:', cookies);
    }
  });

  await page.goto('https://staging.acme.test/login');
  await page.fill('[name=username]', 'testuser');
  await page.fill('[name=password]', 'testpass');
  await page.click('[type=submit]');
  await page.waitForTimeout(2000);

  // Also inspect via context cookies API for flag details
  const cookies = await context.cookies('https://staging.acme.test');
  const csrfCookie = cookies.find(c => c.name.toLowerCase().includes('csrf'));
  console.log('CSRF cookie object:', JSON.stringify(csrfCookie, null, 2));

  await browser.close();
})();
EOF
```

## ESCALATION_PATH
If the staging server is behind Cloudflare or similar bot protection that blocks Playwright, escalate to **Stagehand** (anti-detection stealth mode). If the login triggers a native macOS auth dialog or certificate prompt that web automation can't interact with, escalate to **Peekaboo** as the last resort to drive the browser at the OS level.

## NOTES
- Anti-patterns avoided: did not reach for `playwright-mcp` (would cost ~13.7K tokens in schema alone for a task that only needs a CLI script); did not use `agent-browser` even though it is the default — this is a valid escalation because network response header inspection is explicitly listed as a Playwright CLI use case in the matrix.
- `HttpOnly` is not visible in `document.cookie` by design — it must be read from the raw `Set-Cookie` response header or via Playwright's `context.cookies()` API, which surfaces the `httpOnly` boolean directly.
- `SameSite` is available in `context.cookies()` as the `sameSite` field (`"Strict"`, `"Lax"`, or `"None"`).
- Staging URL (`staging.acme.test`) likely requires a hosts entry or VPN — verify network reachability before running.
- No `PLAYWRIGHT_*` env vars or API keys needed; purely local CLI execution.
