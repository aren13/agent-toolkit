## TOOL_CHOSEN
agent-browser

## REASONING
This task requires interactive web browsing — navigating to amazon.com.tr, performing a search, and reading a product page for price and seller information. The skill's decision matrix specifies `agent-browser` as the default for web automation, and this is a straightforward browse-and-read task with no known bot-detection wall, no need for network interception, PDF generation, or performance profiling. At ~200–400 tokens per page, agent-browser is the most efficient choice for a single product lookup that involves a few clicks and a snapshot read.

## FIRST_COMMANDS
```
agent-browser open https://www.amazon.com.tr
agent-browser snapshot -i
agent-browser fill @e<search-box-ref> "iPhone 17 Pro Max 256GB"
agent-browser press @e<search-box-ref> Enter
agent-browser snapshot -i
```

## ESCALATION_PATH
If amazon.com.tr returns a CAPTCHA or Cloudflare challenge that agent-browser cannot pass, escalate to **Stagehand** (anti-detection built-in). If Stagehand is also blocked, fall back to **Peekaboo** driving Safari via OS-level events, which is indistinguishable from a human user. If the page loads but only requires reading structured product data with no further interaction, **Firecrawl** could be used as an extraction-only alternative once the product URL is known.

## NOTES
- Anti-pattern avoided: did not reach for `playwright-mcp` as default — its schema alone costs ~13.7K tokens before any work begins.
- Anti-pattern avoided: did not use Firecrawl for this task — the task requires interaction (search navigation) before extraction, so extraction-only tools are not appropriate at the start.
- Anti-pattern avoided: did not use Peekaboo preemptively — it is reserved as a last resort for bot-blocked or native-dialog scenarios.
- Amazon.com.tr may display prices in TL (Turkish Lira, ₺) natively; no currency conversion step is needed.
- The `--headed` flag can be added if visual debugging of the session is needed.
- No special env vars or API keys are required for agent-browser on public pages.
