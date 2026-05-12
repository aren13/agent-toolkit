<overview>
Third-party scripts (analytics, ads, chat widgets, social embeds) can significantly impact website performance, security, and privacy. Understanding and managing their impact is crucial for optimization.
</overview>

<impact_statistics>
## Performance Impact

**Average website loads ~20 external scripts.**

Typical impact:
- 500-1500ms added to load time
- 30-50% of total page weight
- Long Tasks blocking main thread

**Real example:** Sites often see LCP improve by 2+ seconds when third parties are blocked.
</impact_statistics>

<common_third_parties>
## Common Third-Party Categories

<category name="Analytics">
**Examples:** Google Analytics, Mixpanel, Hotjar, Heap, Segment

**Typical impact:** Low-Medium (45-150KB, async loading)

**Optimization:**
- Use `async` loading
- Consider lighter alternatives (Plausible ~1KB)
- Server-side tracking when possible
</category>

<category name="Tag Managers">
**Examples:** Google Tag Manager, Segment, Tealium

**Typical impact:** Medium-High (can load many other scripts)

**Optimization:**
- Audit what's actually loaded via GTM
- Remove unused tags
- Load non-critical tags on interaction
</category>

<category name="Advertising">
**Examples:** Google Ads, Facebook Pixel, ad networks

**Typical impact:** High (can add 1000ms+ to load)

**Optimization:**
- Lazy load ads below fold
- Limit number of ad networks
- Consider ad impact on UX/performance trade-off
</category>

<category name="Social Widgets">
**Examples:** Facebook Like, Twitter embed, share buttons

**Typical impact:** Medium (load entire SDK for simple features)

**Optimization:**
- Use static share links (no SDK)
- Lazy load widgets on interaction
- Consider if truly needed
</category>

<category name="Chat Widgets">
**Examples:** Intercom, Drift, Zendesk Chat, Crisp

**Typical impact:** High (100-300KB, often blocking)

**Optimization:**
- Load only on specific pages
- Lazy load on scroll or interaction
- Use lighter alternatives
</category>

<category name="Fonts">
**Examples:** Google Fonts, Adobe Fonts, Typekit

**Typical impact:** Medium (affects CLS and FCP)

**Optimization:**
- Self-host fonts
- Subset fonts to needed characters
- Use `font-display: swap` or `optional`
- Preconnect to font CDN
</category>

<category name="Embeds">
**Examples:** YouTube, Vimeo, Google Maps, Twitter embeds

**Typical impact:** High (entire iframe + resources)

**Optimization:**
- Use lite-youtube-embed (facade pattern)
- Lazy load below fold
- Load on click instead of page load
</category>
</common_third_parties>

<measuring_impact>
## Measuring Third-Party Impact

<method name="WebPageTest Block">
1. Run test with third parties
2. Run test blocking third-party domains
3. Compare metrics

**Result shows true cost of third parties.**
</method>

<method name="Chrome DevTools">
1. Open Network panel
2. Filter by domain (third-party)
3. Check size and timing
4. Use Performance panel to see Long Tasks
</method>

<method name="Lighthouse">
Check "Reduce the impact of third-party code" audit.

Shows:
- Third-party domains
- Transfer size
- Main thread blocking time
</method>

<method name="SpeedCurve">
Built-in third-party blocking for comparison testing.
</method>
</measuring_impact>

<optimization_strategies>
## Optimization Strategies

<strategy name="Async/Defer Loading">
```html
<!-- Bad: Blocking -->
<script src="analytics.js"></script>

<!-- Better: Async (downloads parallel, executes when ready) -->
<script src="analytics.js" async></script>

<!-- Best for non-critical: Defer (executes after HTML parsed) -->
<script src="widget.js" defer></script>
```
</strategy>

<strategy name="Lazy Loading">
Load third parties only when needed:

```javascript
// Load chat widget on user interaction
const chatButton = document.querySelector('.chat-launcher');
chatButton.addEventListener('click', () => {
  loadChatWidget();
}, { once: true });

// Load below-fold content on scroll
const observer = new IntersectionObserver((entries) => {
  if (entries[0].isIntersecting) {
    loadEmbed();
    observer.disconnect();
  }
});
observer.observe(embedPlaceholder);
```
</strategy>

<strategy name="Facade Pattern">
Show static placeholder, load real widget on interaction:

```html
<!-- YouTube facade -->
<lite-youtube videoid="VIDEO_ID" playlabel="Play">
  <!-- Static thumbnail shown first -->
  <!-- Real player loads on click -->
</lite-youtube>
```

Libraries:
- lite-youtube-embed
- lite-vimeo-embed
</strategy>

<strategy name="Self-Hosting">
Some resources can be self-hosted for better control:

**Can self-host:**
- Google Fonts
- Simple analytics scripts
- CSS libraries

**Usually can't self-host:**
- Analytics with real-time features
- Chat widgets (need backend)
- Payment processors
</strategy>

<strategy name="Preconnect">
If third party is critical, speed up connection:

```html
<link rel="preconnect" href="https://www.google-analytics.com">
<link rel="preconnect" href="https://fonts.googleapis.com">
```
</strategy>
</optimization_strategies>

<security_considerations>
## Security Considerations

**Subresource Integrity (SRI):**
```html
<script src="https://cdn.example.com/lib.js"
        integrity="sha384-..."
        crossorigin="anonymous"></script>
```

**Risks of third parties:**
- Can inject malicious code
- Data collection/privacy concerns
- Supply chain attacks
- Performance degradation

**Mitigation:**
- Use SRI for all external scripts
- Audit third parties regularly
- Limit to necessary services
- Monitor for changes
- Have CSP that restricts sources
</security_considerations>

<privacy_considerations>
## Privacy Considerations

Third parties often:
- Set tracking cookies
- Collect user data
- Share with other parties
- Fingerprint users

**GDPR/CCPA implications:**
- May need consent before loading
- Must disclose in privacy policy
- Data processing agreements needed

**Cookie-less alternatives:**
- Plausible (privacy-focused analytics)
- Fathom (privacy-focused analytics)
- Self-hosted solutions
</privacy_considerations>

<audit_template>
## Third-Party Audit Template

| Script | Category | Size | Blocking? | Needed? | Action |
|--------|----------|------|-----------|---------|--------|
| [name] | Analytics | 45KB | No | Yes | Keep |
| [name] | Chat | 200KB | Yes | Maybe | Lazy load |
| [name] | Social | 150KB | No | No | Remove |

**Questions for each:**
1. Is this actively used?
2. Can it load later?
3. Is there a lighter alternative?
4. What's the business value vs performance cost?
</audit_template>
