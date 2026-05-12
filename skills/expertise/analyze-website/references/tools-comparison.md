<overview>
This reference helps choose the right tool for each analysis task. Different tools have different strengths - understanding when to use each leads to more effective testing.
</overview>

<performance_tools>
## Performance Testing Tools

| Tool | Best For | Cost | Lab/Field |
|------|----------|------|-----------|
| PageSpeed Insights | Quick check, both lab and field | Free | Both |
| Lighthouse | Development, CI/CD | Free | Lab |
| WebPageTest | Deep analysis, multi-location | Free/Paid | Lab |
| GTmetrix | Monitoring, reports | Free/Paid | Lab |
| Chrome DevTools | Real-time debugging | Free | Lab |
| CrUX Dashboard | Field data trends | Free | Field |

**Decision tree:**
- Quick check? → PageSpeed Insights
- Development workflow? → Lighthouse
- Deep waterfall analysis? → WebPageTest
- Need real user data? → CrUX/Analytics
- Ongoing monitoring? → GTmetrix or SpeedCurve
</performance_tools>

<accessibility_tools>
## Accessibility Testing Tools

| Tool | Best For | Cost | Coverage |
|------|----------|------|----------|
| axe DevTools | Zero false positives | Free/Paid | ~30% issues |
| WAVE | Visual overlay | Free | ~30% issues |
| Lighthouse | Basic checks | Free | ~20% issues |
| Screen readers | Real testing | Free | Manual |
| Keyboard testing | Keyboard access | Free | Manual |

**Decision tree:**
- Automated scan? → axe DevTools (most accurate)
- Visual review? → WAVE (shows issues in context)
- Combined audit? → Lighthouse (with performance/SEO)
- Real experience? → VoiceOver/NVDA + keyboard testing

**Remember:** Automated tools catch only 20-50% of issues. Manual testing essential.
</accessibility_tools>

<security_tools>
## Security Testing Tools

| Tool | Best For | Cost |
|------|----------|------|
| SecurityHeaders.com | Header analysis | Free |
| Mozilla Observatory | Comprehensive scan | Free |
| CSP Evaluator | CSP validation | Free |
| SSL Labs | TLS configuration | Free |

**Decision tree:**
- Quick header check? → SecurityHeaders.com
- Full security audit? → Mozilla Observatory
- CSP specifically? → CSP Evaluator
- SSL/TLS config? → SSL Labs
</security_tools>

<seo_tools>
## SEO Testing Tools

| Tool | Best For | Cost |
|------|----------|------|
| Lighthouse SEO | Basic technical SEO | Free |
| Google Search Console | Indexing, real rankings | Free |
| Rich Results Test | Structured data | Free |
| Screaming Frog | Site crawl | Free (500 URLs)/Paid |
| Ahrefs/Semrush | Comprehensive SEO | Paid |

**Decision tree:**
- Quick technical check? → Lighthouse SEO
- Structured data? → Rich Results Test
- Full crawl analysis? → Screaming Frog
- Competitor analysis? → Ahrefs/Semrush
- Track actual rankings? → Search Console
</seo_tools>

<browser_testing_tools>
## Browser Testing Tools

| Tool | Best For | Cost |
|------|----------|------|
| Local browsers | Quick testing | Free |
| Chrome DevTools | Device simulation | Free |
| Responsively App | Multi-viewport | Free |
| BrowserStack | Real devices, many browsers | Paid |
| LambdaTest | Budget real device testing | Paid |
| Playwright MCP | Automated interactive | Free |

**Decision tree:**
- Quick responsive check? → Chrome DevTools device mode
- Multiple viewports at once? → Responsively App
- Real Safari/iOS testing? → BrowserStack or real device
- Automated testing? → Playwright
- Budget cross-browser? → LambdaTest
</browser_testing_tools>

<content_tools>
## Content Analysis Tools

| Tool | Best For | Cost |
|------|----------|------|
| Screaming Frog | Broken links, crawl | Free (500)/Paid |
| Squoosh | Image optimization | Free |
| Google Fonts | Font selection | Free |
| Playwright MCP | Manual content check | Free |

**Decision tree:**
- Find broken links? → Screaming Frog
- Optimize images? → Squoosh
- Check content manually? → Playwright MCP
</content_tools>

<all_in_one>
## All-in-One Solutions

| Tool | Covers | Cost |
|------|--------|------|
| Lighthouse | Performance, a11y, SEO, Best Practices | Free |
| WebPageTest + Lighthouse | Performance + deep analysis | Free |
| Playwright MCP | Interactive testing all areas | Free |

**Recommended workflow:**
1. Lighthouse for automated scores
2. Specific tools for deep dives
3. Playwright MCP for manual verification
</all_in_one>

<when_to_use_playwright>
## When to Use Playwright MCP

**Use Playwright MCP when:**
- Testing user flows (forms, checkout)
- Verifying visual rendering
- Testing interactive elements
- Checking responsive behavior
- Keyboard/focus testing
- Getting screenshots for evidence
- Testing that requires interaction

**Use other tools when:**
- Need quantitative metrics (Lighthouse)
- Need historical data (GSC, GTmetrix)
- Need real device testing (BrowserStack)
- Need site-wide crawl (Screaming Frog)
</when_to_use_playwright>

<quick_reference>
## Quick Reference

| I need to... | Use |
|-------------|-----|
| Check Core Web Vitals | PageSpeed Insights |
| Find accessibility issues | axe + manual testing |
| Check security headers | SecurityHeaders.com |
| Validate structured data | Rich Results Test |
| Test mobile layout | Playwright resize + Chrome DevTools |
| Find broken links | Screaming Frog |
| Test Safari | Real Safari or BrowserStack |
| Test user flow | Playwright MCP |
| Check JS errors | Playwright console_messages |
| Analyze third parties | Lighthouse + DevTools Network |
</quick_reference>
