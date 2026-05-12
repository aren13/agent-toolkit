# Workflow: Analyze Third-Party Impact

<required_reading>
**Read these reference files NOW:**
1. references/third-party-impact.md
2. references/performance.md
</required_reading>

<process>
## Step 1: Identify Third-Party Resources

Use Playwright MCP to load the page and capture network requests:

```
Use mcp__playwright__browser_navigate to [URL]
Use mcp__playwright__browser_network_requests
```

Identify requests to external domains (not the main site domain).

Common third-party categories:
- **Analytics:** Google Analytics, Mixpanel, Hotjar, Heap
- **Tag managers:** Google Tag Manager, Segment
- **Advertising:** Google Ads, Facebook Pixel, ad networks
- **Social:** Facebook, Twitter, LinkedIn widgets
- **Chat:** Intercom, Drift, Zendesk
- **CDNs:** Cloudflare, Akamai, Fastly (usually fine)
- **Fonts:** Google Fonts, Adobe Fonts
- **Video:** YouTube, Vimeo embeds
- **Maps:** Google Maps, Mapbox
- **Payments:** Stripe, PayPal

## Step 2: Measure Total Third-Party Impact

Count and categorize:

```markdown
| Category | Scripts | Total Size | Requests |
|----------|---------|------------|----------|
| Analytics | 3 | 150KB | 8 |
| Advertising | 2 | 200KB | 12 |
| Social | 1 | 80KB | 4 |
| Chat | 1 | 120KB | 6 |
| **Total** | **7** | **550KB** | **30** |
```

Compare to first-party resources.

## Step 3: Analyze Blocking Resources

Check which scripts block rendering:

**Blocking scripts** (in `<head>` without async/defer):
- Block HTML parsing
- Delay First Contentful Paint
- Critical issue if slow to load

**Async scripts:**
- Download in parallel
- Execute when ready
- Can still block if large

**Defer scripts:**
- Download in parallel
- Execute after HTML parsed
- Best for non-critical scripts

## Step 4: Measure Long Tasks

Third-party scripts often cause Long Tasks (>50ms main thread blocking).

In Chrome DevTools Performance panel:
- Record page load
- Look for red Long Task indicators
- Identify which scripts cause blocking

Common culprits:
- Tag manager initialization
- Ad script auctions
- Analytics SDK initialization
- Chat widget loading

## Step 5: Test Without Third Parties

Compare performance with and without third parties:

**Method 1: Block in DevTools**
Use Network tab → Block request domain

**Method 2: Use WebPageTest**
WebPageTest has "Block" feature to exclude domains

Compare metrics:
- LCP difference
- Total Blocking Time difference
- Time to Interactive difference

This reveals the true cost of third parties.

## Step 6: Evaluate Each Third Party

For each significant third party, assess:

| Script | Purpose | Size | Blocking? | Alternatives |
|--------|---------|------|-----------|--------------|
| Google Analytics | Analytics | 45KB | No | Plausible, Fathom |
| Facebook Pixel | Marketing | 80KB | Partially | Server-side |
| Intercom | Chat | 150KB | Yes | Defer loading |

Questions to ask:
- Is this actually used?
- Can it be loaded later (on interaction)?
- Is there a lighter alternative?
- Can it be self-hosted?
- Can it be server-side instead?

## Step 7: Check for Subresource Integrity

External scripts should have SRI hashes:

```html
<!-- Good: Has integrity hash -->
<script src="https://cdn.example.com/lib.js"
        integrity="sha384-..."
        crossorigin="anonymous"></script>

<!-- Bad: No integrity -->
<script src="https://cdn.example.com/lib.js"></script>
```

Without SRI, a compromised CDN could inject malicious code.

## Step 8: Analyze Connection Costs

Each third-party domain requires:
- DNS lookup (~20-100ms)
- TCP connection (~20-100ms)
- TLS handshake (~50-150ms)

Use `<link rel="preconnect">` for critical third parties:
```html
<link rel="preconnect" href="https://analytics.example.com">
```

## Step 9: Check Privacy Impact

Third-party scripts may:
- Set tracking cookies
- Collect user data
- Fingerprint users
- Share data with other parties

Consider:
- GDPR/CCPA compliance
- Cookie consent requirements
- Privacy policy accuracy

## Step 10: Optimization Recommendations

Common optimizations:

**Load later:**
```javascript
// Load chat widget only when user hovers near chat icon
chatIcon.addEventListener('mouseenter', () => {
  loadChatWidget();
}, { once: true });
```

**Self-host when possible:**
- Google Fonts can be self-hosted
- Some analytics can run server-side

**Remove unused:**
- Audit which scripts are actually providing value
- Remove legacy tracking/marketing scripts

**Lighter alternatives:**
| Heavy | Lighter Alternative |
|-------|-------------------|
| Google Analytics (45KB) | Plausible (1KB) |
| Full jQuery | Native DOM APIs |
| Moment.js | date-fns or native |

## Step 11: Document Findings

Report format:
```markdown
## Third-Party Impact Analysis

### Summary
- **Total third-party scripts:** [count]
- **Total third-party size:** [size]
- **Third-party requests:** [count]
- **Estimated performance impact:** [LCP impact]

### Third-Party Inventory
| Script | Category | Size | Impact | Recommendation |
|--------|----------|------|--------|----------------|
| [name] | [cat] | [size] | [high/med/low] | [action] |

### Performance Comparison
| Metric | With 3P | Without 3P | Difference |
|--------|---------|------------|------------|
| LCP | 4.2s | 1.8s | -2.4s |
| TBT | 800ms | 200ms | -600ms |

### Recommendations
1. [Priority 1: Remove/defer/replace X]
2. [Priority 2: Preconnect to Y]
3. [Priority 3: Self-host Z]

### Privacy Considerations
- [Cookie/tracking concerns]
```
</process>

<anti_patterns>
Avoid:
- Loading all third parties in `<head>` (blocks rendering)
- No SRI on CDN scripts (security risk)
- Keeping unused/legacy scripts
- Loading heavy scripts for minor features
- Ignoring privacy implications
- Not measuring actual impact (always test with/without)
</anti_patterns>

<success_criteria>
Third-party analysis complete when:

- [ ] All third-party resources inventoried
- [ ] Resources categorized by type
- [ ] Total size and request count documented
- [ ] Blocking vs async scripts identified
- [ ] Long Tasks attributed to scripts
- [ ] Performance impact measured (with/without comparison)
- [ ] SRI usage checked
- [ ] Privacy implications noted
- [ ] Optimization recommendations provided
- [ ] Priority actions listed
</success_criteria>
