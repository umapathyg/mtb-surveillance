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

## Cloud sync (Supabase)

The app is offline-first: every sample saves to the device immediately, then syncs to
your Supabase database when there's a connection. Multiple collectors' devices pool into
one shared dataset.

**One-time database setup**
1. In your Supabase project, open **SQL Editor → New query**.
2. Paste the contents of `supabase_setup.sql` (included) and click **Run**. This creates
   the `samples` table (including the qPCR lab columns) and access policies.

**Connect the app (once per device)**
1. Open the app → **Sync** tab.
2. **Project URL:** `https://lgxmjsfjggxctzydaoje.supabase.co`
3. **Get your key.** Supabase → **Settings → API Keys** → copy the **Publishable key**
   (starts `sb_publishable_…`). If the project is older and shows a **Legacy** tab, the
   **`anon`** key there works too. (Do **not** use the *secret* / *service_role* key in the app.)
4. Tap **Save & test** — you should see "Connected ✓".
5. Leave **Auto-sync** on to push each saved record automatically, or use **Sync now**
   to push everything and pull other collectors' records.

**Adding lab results**
On the **Records** tab, tap any sample to open it, enter the MTB qPCR fields (target gene,
Ct value, result, date, analyst), and **Save lab result**. The edit re-syncs so the Ct
value is linked to that sample's collection metadata everywhere.

**Security note**
The app connects with the Supabase **anon** key, and the policies in the setup SQL let
that key read and write the table. That's convenient for a small trusted team, but anyone
who has the key can access the data — so keep it within your group. For stronger control
(per-collector sign-in), switch to Supabase Auth; the policies in the SQL file note where.

## Sharing with your field team

Because it's a web app, there is nothing to install from an app store — you share a link.

1. **Set up sync on your own phone first** (Sync tab → URL + key → Save & test → Connected ✓).
2. On the Sync tab, tap **Share setup link** to send the link (WhatsApp/SMS/email), or tap
   **Show QR code** → **Print poster** to print a scan-to-set-up sheet for the field office.
3. Each collector opens the link on their phone, taps **Connect** when asked, and the app
   configures itself — no keys to type. They then tap the browser's **Add to Home Screen**
   to install it (Sync tab shows the steps).
4. Each collector sets **Your name (collector)** on their Sync tab so their samples are
   attributed to them.

Now everyone collects on their own phone; samples sync to the shared database and appear on
every device after a **Sync now** (or automatically when online).

**The setup link contains your database key** — send it only to your collectors, never post
it publicly. If a phone is lost or someone leaves the team, rotate the key in Supabase
(Settings → API Keys) and re-share a fresh link.

## Alternative hosts

Any static HTTPS host works the same way: Netlify (drag-and-drop the folder),
Cloudflare Pages, or an institutional web server. Keep the file layout unchanged.

## Updating the app

Edit the files and redeploy. Bump the `CACHE` version in `sw.js` (e.g. `mtb-cache-v2`)
so installed devices fetch the new version on next launch.
