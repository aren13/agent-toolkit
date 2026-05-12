## TOOL_CHOSEN
mcp__playwright__browser_navigate

## REASONING
Amazon.com.tr is a dynamic, JavaScript-heavy e-commerce site that requires a real browser to render product listings, prices, and seller information correctly. Playwright provides full browser automation with screenshot and snapshot capabilities, making it ideal for navigating, searching, and extracting rendered DOM content from a live page. A simple HTTP fetch would miss dynamically loaded price/seller data and would likely be blocked by anti-bot measures.

## FIRST_COMMANDS
```
1. mcp__playwright__browser_navigate({ url: "https://www.amazon.com.tr" })
2. mcp__playwright__browser_snapshot()  // inspect the page structure to locate the search bar
3. mcp__playwright__browser_fill_form({ selector: "input#twotabsearchtextbox", value: "iPhone 17 Pro Max 256GB" })
4. mcp__playwright__browser_press_key({ key: "Enter" })
5. mcp__playwright__browser_snapshot()  // capture search results to identify the correct product listing and extract price + seller
```

## ESCALATION_PATH
If Playwright is blocked by a CAPTCHA or bot-detection wall, escalate to mcp__fetch__fetch with a spoofed User-Agent as a lightweight fallback — though this risks incomplete data. If the product is not found via search, try navigating directly to a known ASIN URL for the iPhone 17 Pro Max on amazon.com.tr. If price/seller data is still not visible in the snapshot, use mcp__playwright__browser_evaluate to query the DOM directly for structured price/offer metadata.

## NOTES
- Amazon.com.tr may display a cookie-consent or location overlay on first load — a snapshot after navigation will reveal this, and it may need to be dismissed before searching.
- Prices on Amazon can vary by seller; the snapshot should capture both the "featured" (Buy Box) price and seller name, as well as any "other sellers" section.
- The page may require scrolling to reveal the full offer listing — mcp__playwright__browser_snapshot captures the current viewport only, so a scroll step may be needed.
- No special environment setup required beyond Playwright being available in the MCP toolchain.
