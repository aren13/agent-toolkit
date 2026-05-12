# Workflow: Audit Security

<required_reading>
**Read these reference files NOW:**
1. references/security.md
</required_reading>

<process>
## Step 1: HTTPS Verification

Check TLS/SSL configuration:

1. **HTTPS enforced** - HTTP redirects to HTTPS
2. **Valid certificate** - Not expired, correct domain
3. **No mixed content** - All resources loaded over HTTPS

Use Playwright MCP to verify:
- Navigate to HTTP version, confirm redirect to HTTPS
- Check for mixed content warnings in console

## Step 2: Security Headers Scan

Use SecurityHeaders.com:

```
WebFetch: https://securityheaders.com/?q=[URL]
```

Or Mozilla Observatory:

```
WebFetch: https://developer.mozilla.org/en-US/observatory
```

Required headers and recommended values:

| Header | Recommendation | Purpose |
|--------|---------------|---------|
| Content-Security-Policy | `default-src 'self'; script-src 'self'` | Prevent XSS |
| Strict-Transport-Security | `max-age=31536000; includeSubDomains` | Force HTTPS |
| X-Content-Type-Options | `nosniff` | Prevent MIME sniffing |
| X-Frame-Options | `DENY` or `SAMEORIGIN` | Prevent clickjacking |
| Referrer-Policy | `strict-origin-when-cross-origin` | Control referrer info |
| Permissions-Policy | `geolocation=(), camera=()` | Limit browser features |

## Step 3: CSP Analysis

Evaluate Content-Security-Policy:

Use Google CSP Evaluator:
```
WebFetch: https://csp-evaluator.withgoogle.com/
```

Check for unsafe directives:
- ❌ `unsafe-inline` (allows inline scripts)
- ❌ `unsafe-eval` (allows eval())
- ❌ `*` wildcards (too permissive)
- ❌ `data:` in script-src (XSS risk)

Better CSP pattern:
```
Content-Security-Policy:
  default-src 'self';
  script-src 'self' 'nonce-{random}';
  style-src 'self' 'nonce-{random}';
  img-src 'self' data: https:;
  font-src 'self';
  connect-src 'self' https://api.example.com;
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
```

## Step 4: Cookie Security

Check cookie attributes:

```
Set-Cookie: session=abc123; Secure; HttpOnly; SameSite=Strict
```

Required attributes:
- **Secure** - Only sent over HTTPS
- **HttpOnly** - Not accessible to JavaScript
- **SameSite** - `Strict` or `Lax` to prevent CSRF

Use Playwright MCP to inspect cookies in Application panel.

## Step 5: Authentication Security (if applicable)

Check login forms:

1. **HTTPS only** - Login page and form action use HTTPS
2. **CSRF protection** - Token in form
3. **Password requirements** - Visible to users
4. **Rate limiting** - Multiple failed attempts handled

## Step 6: Input Handling

Check for potential injection points:

1. **URL parameters** - Test with special characters
2. **Form inputs** - Test with HTML/JS payloads
3. **Search forms** - Check for reflected XSS

Safe test payloads (non-destructive):
```
<script>alert('test')</script>
"><img src=x onerror=alert('test')>
{{7*7}}
```

Look for:
- Unescaped output
- Error messages revealing system info
- Stack traces exposed

## Step 7: Information Disclosure

Check for leaked information:

1. **Server headers** - Remove version numbers
   - ❌ `Server: Apache/2.4.41`
   - ✅ `Server: Apache` or removed

2. **Error pages** - Custom 404/500, no stack traces

3. **Source comments** - No sensitive info in HTML comments

4. **robots.txt/sitemap** - Don't reveal admin paths

5. **.git or .env exposed** - Check common paths

## Step 8: Third-Party Security

Review external resources:

1. **Subresource Integrity (SRI)** - External scripts/styles should have integrity hashes
   ```html
   <script src="https://cdn.example.com/lib.js"
           integrity="sha384-..."
           crossorigin="anonymous"></script>
   ```

2. **Third-party domains** - Are they trusted? Necessary?

3. **Sandboxed iframes** - External content in sandboxed iframes

## Step 9: Document Findings

Rate by severity:

**Critical:**
- Missing HTTPS
- CSP allows unsafe-inline with XSS vectors
- Exposed credentials/secrets

**High:**
- Missing CSP
- Missing HSTS
- Insecure cookies

**Medium:**
- CSP improvements needed
- Missing recommended headers
- Information disclosure

**Low:**
- Best practice suggestions
- Header optimizations

Report format:
```markdown
## Security Audit

**Overall Grade:** [A-F from SecurityHeaders.com]

### Headers Status
| Header | Status | Current Value | Recommendation |
|--------|--------|---------------|----------------|
| CSP | ❌/✅ | [value] | [recommendation] |
| HSTS | ❌/✅ | [value] | [recommendation] |
| ... | | | |

### Critical Issues
- [Issue]: [Risk] - [Fix]

### Recommendations
1. [Priority fix]
2. [Priority fix]
```
</process>

<anti_patterns>
Avoid:
- Deploying CSP in enforce mode without testing (use Report-Only first)
- Using `unsafe-inline` without nonces (defeats CSP purpose)
- Setting overly permissive CORS (`Access-Control-Allow-Origin: *` with credentials)
- Exposing detailed error messages in production
- Trusting client-side validation alone
</anti_patterns>

<success_criteria>
Security audit complete when:

- [ ] HTTPS properly enforced
- [ ] TLS certificate valid
- [ ] Security headers analyzed and graded
- [ ] CSP evaluated for unsafe directives
- [ ] Cookie security verified
- [ ] No mixed content
- [ ] No obvious information disclosure
- [ ] Third-party resources reviewed
- [ ] Findings rated by severity
- [ ] Actionable recommendations provided
</success_criteria>
