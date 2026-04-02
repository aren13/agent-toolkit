# Naming Conventions Reference

Complete rules for naming documentation files and folders.

## Core Rules

### 1. Lowercase Only

**Rule:** All characters must be lowercase.

**Correct:**
- `api-guide.md`
- `installation-guide.md`
- `whatsapp-integration.md`

**Incorrect:**
- `API-Guide.md` ❌ (uppercase)
- `InstallationGuide.md` ❌ (camelCase)
- `WhatsApp-Integration.md` ❌ (mixed case)

**Reasoning:** Prevents issues with case-sensitive filesystems, easier to type, consistent appearance.

---

### 2. Kebab-Case (Hyphens)

**Rule:** Separate words with hyphens, not underscores or spaces.

**Correct:**
- `user-authentication.md`
- `api-reference.md`
- `content-security-policy.md`

**Incorrect:**
- `user_authentication.md` ❌ (underscores)
- `user authentication.md` ❌ (spaces)
- `userauthentication.md` ❌ (no separation)

**Reasoning:** URLs work well with hyphens, easier to read than underscores, no issues with spaces.

---

### 3. Type Suffix

**Rule:** Include document type suffix (except features in `features/` folder).

**Correct:**
- `installation-guide.md`
- `api-reference.md`
- `sql-injection-fix.md`
- `retailer-api-prd.md`
- `webhook-spec.md`
- `project-summary.md`
- `refactoring-roadmap.md`

**Exception:**
- `whatsapp-notifications.md` (feature in features/ folder - no suffix)

**Incorrect:**
- `installation.md` ❌ (missing suffix)
- `api.md` ❌ (missing suffix)
- `troubleshooting.md` ❌ (missing suffix)

**Reasoning:** Immediately identifies document type, helps with organization, prevents confusion.

---

### 4. Maximum 50 Characters

**Rule:** Total filename should not exceed 50 characters (including extension).

**Correct:**
- `production-deployment-guide.md` (32 chars)
- `api-authentication-reference.md` (32 chars)

**Incorrect:**
- `comprehensive-guide-to-production-deployment-procedures.md` ❌ (58 chars)
- `detailed-whatsapp-business-api-integration-documentation.md` ❌ (60 chars)

**Fix by:**
- Removing redundant words: "comprehensive", "detailed", "documentation"
- Using abbreviations: "prod" for production (if clear)
- Focusing on key terms

**Reasoning:** Easier to reference, cleaner in file trees, forces concise naming.

---

### 5. No Spaces or Special Characters

**Rule:** Only lowercase letters, numbers, hyphens, and `.md` extension.

**Correct:**
- `setup-guide.md`
- `api-v2-reference.md`
- `oauth2-guide.md`

**Incorrect:**
- `setup guide.md` ❌ (space)
- `api_reference.md` ❌ (underscore)
- `api@v2.md` ❌ (special char)
- `setup!.md` ❌ (special char)

**Reasoning:** Avoids shell escaping issues, URL-safe, consistent across systems.

---

### 6. Descriptive but Concise

**Rule:** Name should clearly indicate content without being verbose.

**Good:**
- `ssl-tls-guide.md` - Clear, concise
- `docker-deployment-guide.md` - Specific, actionable
- `error-codes-reference.md` - Descriptive

**Poor:**
- `guide.md` ❌ (too vague)
- `doc1.md` ❌ (meaningless)
- `stuff.md` ❌ (useless)
- `comprehensive-detailed-guide-to-ssl-tls.md` ❌ (too verbose)

**Tips:**
- Use specific nouns: "docker", "api", "database"
- Avoid redundant words: "guide to", "documentation for"
- Focus on the key concept

---

## Type Suffix Patterns

| Type | Suffix | Example |
|------|--------|---------|
| Guide | `-guide.md` | `installation-guide.md` |
| Reference | `-reference.md` | `api-reference.md` |
| Fix | `-fix.md` | `sql-injection-fix.md` |
| PRD | `-prd.md` | `retailer-api-prd.md` |
| Spec | `-spec.md` | `webhook-spec.md` |
| Summary | `-summary.md` | `project-summary.md` |
| Roadmap | `-roadmap.md` | `refactoring-roadmap.md` |
| Feature | (none) | `whatsapp-notifications.md` |

---

## Folder Naming

Folders follow similar rules but with slight variations:

### Rules for Folders

1. **Lowercase** - `getting-started/` not `Getting-Started/`
2. **Plural nouns** - `features/` not `feature/`
3. **Kebab-case** - `how-to/` not `how_to/`
4. **Short (1-2 words)** - `api/` not `api-documentation/`
5. **No special chars** - Only letters, numbers, hyphens

### Standard Folders

```
docs/
├── getting-started/      # Setup and onboarding
├── how-to/               # Task guides
├── features/             # Feature docs
├── integrations/         # Third-party integrations
├── api/                  # API documentation
├── development/          # Developer docs
├── security/             # Security docs
│   └── cve/             # CVE-specific fixes
├── operations/           # Ops/deployment docs
└── archive/              # Outdated docs
```

### Folder Naming Patterns

**Use plural nouns:**
- `features/` not `feature/`
- `integrations/` not `integration/`
- `examples/` not `example/`

**Keep short:**
- `api/` not `api-documentation/`
- `ops/` or `operations/` not `operational-procedures/`

**Be specific:**
- `getting-started/` not `start/`
- `how-to/` not `guides/`

---

## Special Cases

### Version Numbers

Include version numbers when needed:

**Correct:**
- `api-v1-spec.md`
- `api-v2-spec.md`
- `migration-v2-to-v3-guide.md`

**Format:** `v[number]` (lowercase v, no dots)

### CVEs

For CVE-specific docs:

**Correct:**
- `cve-2024-1234-fix.md`
- `cve-2024-1234-summary.md`

**Format:** `cve-YYYY-NNNN-[type].md`

### Dates in Names

Generally avoid dates in names (use metadata instead), but if needed:

**Correct:**
- `2024-01-15-incident-summary.md` (ISO format)

**Format:** `YYYY-MM-DD-[name].md`

### Acronyms

Keep acronyms lowercase in filenames:

**Correct:**
- `ssl-tls-guide.md`
- `oauth2-authentication-guide.md`
- `csp-fix.md`

**Incorrect:**
- `SSL-TLS-guide.md` ❌
- `OAuth2-authentication-guide.md` ❌
- `CSP-fix.md` ❌

### Numbers

Use numbers when they add meaning:

**Correct:**
- `oauth2-guide.md` (part of the name)
- `api-v2-reference.md` (version)
- `top-10-tips.md` (quantity)

**Use sparingly:**
- Avoid `part1.md`, `part2.md` - use descriptive names instead

---

## Folder-Specific Naming Requirements

Some folders have specific naming requirements:

| Folder | Required Suffix | Example |
|--------|-----------------|---------|
| `getting-started/` | `-guide.md` | `installation-guide.md` |
| `how-to/` | `-guide.md` | `deployment-guide.md` |
| `features/` | (none) | `whatsapp-notifications.md` |
| `integrations/` | varies | `migros-integration.md` or `api-spec.md` |
| `security/` | `-fix.md` or `-reference.md` | `csp-fix.md` |
| `security/cve/` | `-fix.md` or `-summary.md` | `cve-2024-1234-fix.md` |
| `development/` | `-guide.md` or `-roadmap.md` | `refactoring-roadmap.md` |
| `archive/` | `-summary.md` | `sms-6382-summary.md` |

---

## Common Naming Mistakes

### 1. Too Generic

❌ `guide.md`
✅ `installation-guide.md`

❌ `api.md`
✅ `api-reference.md`

❌ `docs.md`
✅ `documentation-guideline.md`

### 2. Too Specific/Verbose

❌ `comprehensive-step-by-step-guide-for-production-deployment.md`
✅ `production-deployment-guide.md`

❌ `detailed-whatsapp-business-api-integration-documentation.md`
✅ `whatsapp-integration.md` or `whatsapp-api-spec.md`

### 3. Wrong Case

❌ `API-Guide.md`
✅ `api-guide.md`

❌ `UserAuthentication.md`
✅ `user-authentication.md`

### 4. Wrong Separator

❌ `user_authentication.md`
✅ `user-authentication.md`

❌ `user authentication.md`
✅ `user-authentication.md`

### 5. Missing Suffix

❌ `installation.md`
✅ `installation-guide.md`

❌ `api-endpoints.md`
✅ `api-endpoints-reference.md`

### 6. Wrong Suffix

❌ `whatsapp-feature.md` (in features/ folder)
✅ `whatsapp-notifications.md`

❌ `setup-reference.md` (it's instructional)
✅ `setup-guide.md`

---

## Validation Checklist

Use this checklist to validate a filename:

- [ ] All lowercase
- [ ] Uses hyphens (kebab-case)
- [ ] Has appropriate type suffix (or none for features)
- [ ] 50 characters or less
- [ ] No spaces or special characters
- [ ] Descriptive and specific
- [ ] Matches folder requirements (if applicable)

---

## Examples by Document Type

### Guides
✅ `installation-guide.md`
✅ `quickstart-guide.md`
✅ `deployment-guide.md`
✅ `migration-guide.md`
✅ `troubleshooting-guide.md`

### References
✅ `api-reference.md`
✅ `configuration-reference.md`
✅ `cli-reference.md`
✅ `error-codes-reference.md`
✅ `environment-variables-reference.md`

### Fixes
✅ `sql-injection-fix.md`
✅ `csp-fix.md`
✅ `memory-leak-fix.md`
✅ `cve-2024-1234-fix.md`
✅ `xss-vulnerability-fix.md`

### PRDs
✅ `retailer-api-prd.md`
✅ `mobile-app-prd.md`
✅ `notification-system-prd.md`
✅ `payment-integration-prd.md`

### Specs
✅ `webhook-spec.md`
✅ `api-v2-spec.md`
✅ `data-format-spec.md`
✅ `oauth2-spec.md`

### Summaries
✅ `project-summary.md`
✅ `incident-summary.md`
✅ `sms-6382-summary.md`
✅ `cve-summary.md`
✅ `q4-2024-summary.md`

### Roadmaps
✅ `refactoring-roadmap.md`
✅ `feature-roadmap.md`
✅ `migration-roadmap.md`
✅ `api-v2-roadmap.md`

### Features
✅ `whatsapp-notifications.md`
✅ `donation-tracking.md`
✅ `smart-scale-integration.md`
✅ `multi-tenant-support.md`

---

## Renaming Guidelines

If you need to rename a file:

1. **Check current name** against rules
2. **Identify violations**
3. **Construct correct name**
4. **Update all references:**
   - Internal links in other docs
   - README indexes
   - Code comments
   - External documentation
5. **Rename the file**
6. **Verify links still work**
7. **Add redirect if needed** (for public docs)

**Example:**
```
Old: docs/API_Guide.md
Issues: Uppercase, underscore, missing suffix
New: docs/api-reference-guide.md (or api-reference.md if it's a reference)

Must update:
- docs/README.md (link)
- Other docs linking to it (grep search)
- Code comments with path
```
