## TOOL_CHOSEN
mcp__playwright__browser_network_requests

## REASONING
Playwright's built-in network interception tools (`browser_network_requests` and `browser_navigate`) provide direct access to response headers and Set-Cookie values without requiring any external proxy setup. Since the task is specifically about inspecting response cookies set during a login form submission — including HttpOnly and SameSite flags — Playwright's network layer captures the full HTTP exchange including response headers where `Set-Cookie` headers appear. This is more reliable than trying to read cookies from the browser's JS context (which would fail for HttpOnly cookies by design).

## FIRST_COMMANDS
```
1. mcp__playwright__browser_navigate({ url: "https://staging.acme.test/login" })

2. mcp__playwright__browser_fill_form({ fields: { "#username": "testuser", "#password": "testpassword" } })

3. mcp__playwright__browser_network_request({ url: "https://staging.acme.test/login", method: "POST" })
   # OR capture all requests around the submit action:

4. mcp__playwright__browser_click({ selector: "[type=submit]" })

5. mcp__playwright__browser_network_requests({})
   # Review captured requests for the POST /login response; inspect Set-Cookie headers for csrftoken/CSRF cookie flags
```

## ESCALATION_PATH
If `browser_network_requests` does not expose raw `Set-Cookie` response headers (some implementations only expose request headers or parsed cookie state), escalate to using `mcp__playwright__browser_evaluate` to read `document.cookie` for non-HttpOnly cookies and cross-reference, or use `mcp__playwright__browser_snapshot` to read any server-side error/debug output on the page. If the staging environment is unreachable (DNS not resolving for `.test` TLD), switch to running the test against a locally mapped host by using a system-level hosts file entry or confirming VPN/tunnel access before re-running. As a last resort, use `mcp__fetch__fetch` to POST credentials directly and inspect the raw response headers including `Set-Cookie` lines without a browser at all.

## NOTES
- The `.test` TLD is a reserved local/private domain (RFC 2606) — the machine running the automation must have a hosts file entry or local DNS resolver pointing `staging.acme.test` to the actual staging server IP, or be on a VPN/network where that name resolves.
- HttpOnly cookies will NOT be visible via `document.cookie` in JS — the only way to verify the HttpOnly flag is through the raw `Set-Cookie` response header, which is why network-level inspection (not DOM inspection) is required.
- SameSite flag verification also requires reading the raw `Set-Cookie` header value (e.g., `SameSite=Strict` or `SameSite=Lax`).
- If the login form uses a separate GET request first to load the CSRF token before the POST, the relevant `Set-Cookie` may appear on the initial page load, not on the POST response — check both.
- Credentials used in the plan above (`testuser` / `testpassword`) are placeholders; real staging credentials must be substituted.
