# MTB Wastewater Surveillance — installable PWA

An offline-first Progressive Web App for field collection of wastewater samples for
*Mycobacterium tuberculosis* surveillance in the Hyderabad region. Captures GPS location,
live weather, wastewater flow, water-quality and catchment-population metadata so the MTB
signal can be normalised per capita during analysis.

## Files

```
index.html               the app (UI + logic)
manifest.webmanifest      app name, icons, colours, standalone display
sw.js                     service worker — caches the app for full offline use
icons/                    app icons (192/512 + maskable, Apple touch, favicon)
```

## Why it must be hosted (not opened as a file)

A PWA can only be installed and run its service worker when served over **HTTPS**
(or `http://localhost`). Opening `index.html` directly from the file system will run the
app, but the browser will **not** offer "Install" and offline caching will not activate.

## Deploy on GitHub Pages (recommended — free HTTPS)

You already host a GitHub site, so this is the quickest route:

1. Create a new repository, e.g. `mtb-surveillance`.
2. Upload everything in this folder (keep the `icons/` subfolder intact).
3. Repo **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   branch `main`, folder `/ (root)`. Save.
4. After a minute the app is live at
   `https://umapathyg.github.io/mtb-surveillance/`.
5. Open that URL **on your phone** (Chrome on Android, Safari on iOS).

## Install on the phone

- **Android / Chrome:** open the URL → an "Install app" card appears on the *Export* tab,
  or use the browser menu → *Install app / Add to Home screen*.
- **iPhone / iPad (Safari):** tap **Share** → **Add to Home Screen**. (iOS does not show an
  automatic install button; the *Export* tab shows these steps.)

Once installed it gets its own icon, opens full-screen, and works with no internet —
GPS still works offline; only the weather lookup needs a moment of connectivity and is
skipped gracefully when offline.

## Data & privacy

- All records are stored **locally on the device** (browser storage). Nothing is uploaded.
- Use **Export → Download CSV** for analysis and **Backup JSON** regularly; restore or move
  data to another device with **Restore JSON**.
- Local storage is ample for routine use but is bound to that device/browser. For a
  multi-collector team with a shared live database, the next step is a small backend
  (Firebase / Supabase / CSIR-hosted Postgres) to sync records centrally.

## Alternative hosts

Any static HTTPS host works the same way: Netlify (drag-and-drop the folder),
Cloudflare Pages, or an institutional web server. Keep the file layout unchanged.

## Updating the app

Edit the files and redeploy. Bump the `CACHE` version in `sw.js` (e.g. `mtb-cache-v2`)
so installed devices fetch the new version on next launch.
