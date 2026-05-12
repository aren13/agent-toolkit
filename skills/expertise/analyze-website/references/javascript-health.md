<overview>
JavaScript health encompasses console errors, runtime performance, memory management, and code quality. Healthy JavaScript leads to better performance, fewer bugs, and improved user experience.
</overview>

<console_errors>
## Console Errors

**Types:**
- **Errors (red):** Breaking issues, execution stopped
- **Warnings (yellow):** Potential problems, deprecated features
- **Info/Log (gray):** Debug output

**Common error types:**
```
Uncaught TypeError: Cannot read property 'x' of undefined
Uncaught ReferenceError: x is not defined
Uncaught SyntaxError: Unexpected token
NetworkError: Failed to fetch
```

**Impact:**
- Features may not work
- Poor user experience
- SEO impact (Google renders pages)
- Indicates code quality issues

**Using Playwright:**
```
browser_console_messages level: "error"
```
</console_errors>

<memory_leaks>
## Memory Leaks

**Symptoms:**
- Page becomes slow over time
- Memory usage grows continuously
- Eventually crashes/freezes

**Common causes:**

<cause name="Detached DOM nodes">
```javascript
// Bad: Reference to removed element
let element = document.getElementById('item');
document.body.removeChild(element.parentNode);
// 'element' still references the detached node
```

**Fix:** Set references to null when done.
</cause>

<cause name="Event listeners not cleaned up">
```javascript
// Bad: Adding listeners without removing
window.addEventListener('scroll', handler);

// Good: Clean up
const controller = new AbortController();
window.addEventListener('scroll', handler, { signal: controller.signal });
// Later:
controller.abort(); // Removes listener
```
</cause>

<cause name="Closures holding references">
```javascript
// Bad: Closure keeps large object alive
function setup() {
  const largeData = fetchLargeData();
  return function handler() {
    console.log(largeData.length); // Keeps largeData in memory
  };
}
```

**Fix:** Only close over what's needed.
</cause>

<cause name="Timers and intervals">
```javascript
// Bad: Interval never cleared
setInterval(() => updateData(), 1000);

// Good: Clear when done
const intervalId = setInterval(() => updateData(), 1000);
// Later:
clearInterval(intervalId);
```
</cause>
</memory_leaks>

<profiling>
## Chrome DevTools Profiling

<tool name="Memory Panel">
**Heap Snapshot:**
1. Take initial snapshot
2. Perform action suspected of leaking
3. Take second snapshot
4. Compare (look for growing objects)

**Allocation Timeline:**
- Shows memory allocation over time
- Blue bars = allocated
- Gray bars = freed
- Remaining blue = potential leaks
</tool>

<tool name="Performance Panel">
**Recording:**
1. Click Record
2. Perform actions
3. Stop recording
4. Analyze results

**Look for:**
- Long Tasks (>50ms) - red indicator
- Main thread blocking
- Excessive scripting time
- Layout thrashing
</tool>
</profiling>

<long_tasks>
## Long Tasks

**Definition:** Any JavaScript task taking >50ms on main thread.

**Impact:**
- Blocks user interaction
- Causes poor INP scores
- Makes page feel slow

**Identifying:**
- Performance panel shows red bars
- Use Long Tasks API:

```javascript
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('Long Task:', entry.duration, 'ms');
  }
});
observer.observe({ entryTypes: ['longtask'] });
```

**Fixing:**
```javascript
// Break up long task
async function processItems(items) {
  for (const item of items) {
    processItem(item);
    // Yield to main thread periodically
    if (performance.now() - lastYield > 50) {
      await new Promise(r => setTimeout(r, 0));
      lastYield = performance.now();
    }
  }
}
```
</long_tasks>

<bundle_analysis>
## Bundle Analysis

**Target:** <300KB total JavaScript (compressed)

**Analyze bundle:**
```bash
# Webpack
npx webpack-bundle-analyzer stats.json

# Vite
npx vite-bundle-visualizer
```

**Common issues:**
- Importing entire libraries (import entire lodash)
- Duplicate dependencies
- Unused code (tree-shaking not working)
- Large dependencies

**Solutions:**
```javascript
// Bad: Import entire library
import _ from 'lodash';

// Good: Import specific function
import debounce from 'lodash/debounce';

// Better: Use native or smaller alternative
const debounce = (fn, ms) => {
  let timeout;
  return (...args) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => fn(...args), ms);
  };
};
```
</bundle_analysis>

<code_coverage>
## Code Coverage

**Chrome DevTools:**
1. Open DevTools
2. Cmd/Ctrl + Shift + P
3. "Show Coverage"
4. Click record
5. Interact with page
6. See unused code (red bars)

**Impact:**
- Unused code adds to bundle size
- Downloaded but never executed
- Tree-shaking should remove, but doesn't always

**Actions:**
- Code split unused features
- Lazy load non-critical code
- Remove dead code
</code_coverage>

<js_health_checklist>
## JavaScript Health Checklist

**Errors:**
- [ ] No console errors
- [ ] No unhandled promise rejections
- [ ] Graceful error handling

**Memory:**
- [ ] No memory leaks
- [ ] Event listeners cleaned up
- [ ] Detached DOM nodes cleared

**Performance:**
- [ ] No Long Tasks >50ms (or minimal)
- [ ] Bundle size <300KB
- [ ] Unused code removed
- [ ] Code splitting implemented

**Quality:**
- [ ] No deprecated API usage
- [ ] Modern JS features (with transpilation if needed)
- [ ] Error boundaries for React/Vue
</js_health_checklist>
