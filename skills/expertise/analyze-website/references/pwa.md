<overview>
Progressive Web Apps (PWAs) combine web and native app features. They require HTTPS, a web app manifest, and a service worker. PWAs enable offline functionality, push notifications, and app-like experiences.
</overview>

<pwa_requirements>
## PWA Core Requirements

**Three pillars:**
1. **HTTPS** - Secure context required
2. **Web App Manifest** - App metadata
3. **Service Worker** - Offline/caching functionality

**Lighthouse PWA audit checks:**
- Installable
- Optimized for performance
- Works offline
- Secure context (HTTPS)
</pwa_requirements>

<manifest>
## Web App Manifest

**Location:** `/manifest.json` or `/site.webmanifest`

**Link in HTML:**
```html
<link rel="manifest" href="/manifest.json">
```

**Required properties:**
```json
{
  "name": "My App Name",
  "short_name": "MyApp",
  "start_url": "/",
  "display": "standalone",
  "icons": [
    {
      "src": "/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

**Recommended properties:**
```json
{
  "name": "My Full App Name",
  "short_name": "MyApp",
  "description": "Description of the app",
  "start_url": "/?source=pwa",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#007bff",
  "orientation": "portrait",
  "scope": "/",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/icons/maskable-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ]
}
```

**Display modes:**
- `fullscreen` - No browser UI
- `standalone` - Like native app
- `minimal-ui` - Minimal browser controls
- `browser` - Normal browser tab
</manifest>

<service_worker>
## Service Worker

**Registration:**
```javascript
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js')
    .then(reg => console.log('SW registered'))
    .catch(err => console.log('SW failed', err));
}
```

**Basic caching strategy:**
```javascript
// sw.js
const CACHE_NAME = 'v1';
const URLS_TO_CACHE = ['/', '/styles.css', '/app.js'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(URLS_TO_CACHE))
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});
```

**Caching strategies:**
| Strategy | Use Case |
|----------|----------|
| Cache first | Static assets (CSS, JS, images) |
| Network first | API calls, dynamic content |
| Stale while revalidate | Frequently updated content |
| Cache only | Offline-critical resources |
| Network only | Real-time data |
</service_worker>

<testing_pwa>
## Testing PWAs

**Chrome DevTools Application Panel:**
- Manifest tab: Check manifest parsing
- Service Workers tab: Check registration, status
- Cache Storage: View cached resources

**Lighthouse PWA Audit:**
- Installable criteria
- PWA optimized
- Works offline

**Key tests:**
1. Manifest validates correctly
2. Service worker registers
3. App works offline
4. Install prompt appears
5. Installed app functions correctly

**Using Playwright:**
```
browser_navigate to PWA
Check Application panel equivalent via DevTools
Test offline by enabling offline mode
```
</testing_pwa>

<ios_limitations>
## iOS/Safari Limitations (2024-2025)

| Feature | iOS Status |
|---------|------------|
| Install to home screen | ✅ Yes |
| Offline caching | ✅ Yes |
| Push notifications | ✅ Yes (iOS 16.4+) |
| Background sync | ❌ No |
| Web Bluetooth | ❌ No |
| Badging API | ✅ Partial |
| Share Target | ❌ No |

**iOS-specific considerations:**
- Must add to home screen from Safari
- 50MB cache limit (vs 6GB+ on desktop)
- No persistent storage guarantee
- Different icon requirements

**iOS meta tags:**
```html
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="App Name">
<link rel="apple-touch-icon" href="/icons/apple-icon.png">
```
</ios_limitations>

<pwa_checklist>
## PWA Checklist

**Basic requirements:**
- [ ] HTTPS enabled
- [ ] Manifest file present and linked
- [ ] Manifest has name and short_name
- [ ] Manifest has start_url
- [ ] Manifest has display mode
- [ ] Icons: 192px and 512px
- [ ] Service worker registered
- [ ] Works offline (at minimum, shows offline page)

**Enhanced features:**
- [ ] Maskable icon for Android
- [ ] Apple touch icon for iOS
- [ ] Theme color set
- [ ] Background color set
- [ ] Splash screen works
- [ ] Install prompt handled
- [ ] Push notifications (if needed)

**Performance:**
- [ ] Fast initial load
- [ ] Smooth transitions
- [ ] Responsive to interactions
</pwa_checklist>

<tools>
## PWA Tools

**PWA Builder:** https://www.pwabuilder.com/
- Validates existing PWA
- Generates manifest and service worker
- Provides store packages

**Workbox:** https://developers.google.com/web/tools/workbox
- Service worker library from Google
- Pre-built caching strategies
- Easy offline support
</tools>
