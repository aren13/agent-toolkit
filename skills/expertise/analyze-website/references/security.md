<overview>
Website security involves proper HTTPS configuration, security headers, and protection against common vulnerabilities. Tools like SecurityHeaders.com and Mozilla Observatory provide quick security assessments.
</overview>

<security_headers>
## Essential Security Headers

<header name="Content-Security-Policy">
**Purpose:** Prevents XSS and data injection attacks by controlling which resources can load.

**Recommended value:**
```
Content-Security-Policy:
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: https:;
  font-src 'self';
  connect-src 'self';
  frame-ancestors 'none';
  base-uri 'self';
  form-action 'self';
```

**Critical:** Avoid `unsafe-inline` and `unsafe-eval` for scripts if possible.

**Implementation approach:**
1. Start with `Content-Security-Policy-Report-Only`
2. Monitor violation reports
3. Adjust policy
4. Switch to enforcing mode
</header>

<header name="Strict-Transport-Security">
**Purpose:** Forces HTTPS connections, prevents downgrade attacks.

**Recommended value:**
```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

**Parameters:**
- `max-age=31536000`: Cache for 1 year
- `includeSubDomains`: Apply to all subdomains
- `preload`: Submit to browser preload list
</header>

<header name="X-Content-Type-Options">
**Purpose:** Prevents MIME type sniffing.

**Recommended value:**
```
X-Content-Type-Options: nosniff
```
</header>

<header name="X-Frame-Options">
**Purpose:** Prevents clickjacking by controlling iframe embedding.

**Recommended value:**
```
X-Frame-Options: DENY
```

Or if embedding on same origin needed:
```
X-Frame-Options: SAMEORIGIN
```

**Note:** Being replaced by CSP `frame-ancestors` but still useful for older browsers.
</header>

<header name="Referrer-Policy">
**Purpose:** Controls referrer information sent with requests.

**Recommended value:**
```
Referrer-Policy: strict-origin-when-cross-origin
```

**Options:**
- `no-referrer`: Never send referrer
- `same-origin`: Send for same-origin only
- `strict-origin-when-cross-origin`: Full URL same-origin, origin only cross-origin (recommended)
</header>

<header name="Permissions-Policy">
**Purpose:** Controls browser feature access (camera, mic, geolocation, etc.).

**Recommended value:**
```
Permissions-Policy:
  geolocation=(),
  camera=(),
  microphone=(),
  payment=()
```

Disable features not needed. Allow specific origins if required:
```
Permissions-Policy: geolocation=(self "https://maps.example.com")
```
</header>
</security_headers>

<testing_tools>
## Security Testing Tools

<tool name="SecurityHeaders.com">
**URL:** https://securityheaders.com/

**What it checks:**
- All security headers
- Grades A+ to F
- Recommendations for missing headers

**Grading:**
- A+ : All headers present and optimal
- A : All headers present
- B-F : Missing or misconfigured headers
</tool>

<tool name="Mozilla Observatory">
**URL:** https://developer.mozilla.org/en-US/observatory

**What it checks:**
- Security headers
- Cookie security
- Redirection behavior
- More comprehensive than SecurityHeaders

**Score:** 0-100+
</tool>

<tool name="CSP Evaluator">
**URL:** https://csp-evaluator.withgoogle.com/

**What it checks:**
- CSP policy strength
- Bypass vulnerabilities
- Unsafe directives
</tool>

<tool name="SSL Labs">
**URL:** https://www.ssllabs.com/ssltest/

**What it checks:**
- TLS configuration
- Certificate validity
- Protocol support
- Cipher strength
</tool>
</testing_tools>

<https_configuration>
## HTTPS Configuration

**Requirements:**
1. Valid SSL/TLS certificate
2. HTTP → HTTPS redirect
3. HSTS header
4. No mixed content

**Redirect pattern:**
```
# Nginx
server {
    listen 80;
    return 301 https://$host$request_uri;
}

# Apache
RewriteEngine On
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

**Mixed content:** All resources (images, scripts, styles) must load over HTTPS.
</https_configuration>

<cookie_security>
## Cookie Security

**Secure attributes:**
```
Set-Cookie: session=abc123; Secure; HttpOnly; SameSite=Strict
```

| Attribute | Purpose |
|-----------|---------|
| `Secure` | Only sent over HTTPS |
| `HttpOnly` | Not accessible to JavaScript |
| `SameSite=Strict` | Not sent with cross-site requests |
| `SameSite=Lax` | Sent with top-level navigation |

**Session cookies:** Use all three attributes.
**Preference cookies:** Secure and SameSite may be sufficient.
</cookie_security>

<common_vulnerabilities>
## Common Vulnerabilities to Check

<vulnerability name="XSS (Cross-Site Scripting)">
**Risk:** Attackers inject malicious scripts.

**Check:**
- User input reflected in page
- Search forms
- URL parameters

**Prevention:**
- Content Security Policy
- Output encoding
- Input validation
</vulnerability>

<vulnerability name="CSRF (Cross-Site Request Forgery)">
**Risk:** Attackers perform actions as authenticated users.

**Check:**
- Forms without CSRF tokens
- State-changing GET requests

**Prevention:**
- CSRF tokens in forms
- SameSite cookies
- Verify Origin header
</vulnerability>

<vulnerability name="Clickjacking">
**Risk:** Hidden overlays trick users into clicking.

**Prevention:**
- X-Frame-Options: DENY
- CSP frame-ancestors 'none'
</vulnerability>

<vulnerability name="Information Disclosure">
**Check for:**
- Server version in headers
- Stack traces in errors
- Comments with sensitive data
- .git or .env accessible
- Debug mode enabled

**Prevention:**
- Custom error pages
- Remove version headers
- Disable debug in production
</vulnerability>
</common_vulnerabilities>

<subresource_integrity>
## Subresource Integrity (SRI)

**Purpose:** Verify external resources haven't been tampered with.

**Implementation:**
```html
<script src="https://cdn.example.com/lib.js"
        integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"
        crossorigin="anonymous"></script>
```

**Generate hash:**
```bash
openssl dgst -sha384 -binary file.js | openssl base64 -A
```

**When to use:** All third-party scripts and stylesheets from CDNs.
</subresource_integrity>

<security_checklist>
## Quick Security Checklist

**HTTPS:**
- [ ] Valid certificate
- [ ] HTTP redirects to HTTPS
- [ ] No mixed content
- [ ] HSTS header present

**Headers:**
- [ ] Content-Security-Policy
- [ ] Strict-Transport-Security
- [ ] X-Content-Type-Options: nosniff
- [ ] X-Frame-Options
- [ ] Referrer-Policy
- [ ] Permissions-Policy

**Cookies:**
- [ ] Secure flag
- [ ] HttpOnly flag
- [ ] SameSite attribute

**General:**
- [ ] No sensitive data in URLs
- [ ] Custom error pages
- [ ] Server version hidden
- [ ] Debug mode disabled
- [ ] SRI on external resources
</security_checklist>
