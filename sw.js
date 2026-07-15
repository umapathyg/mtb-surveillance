-- ============================================================
--  MTB Wastewater Surveillance — Supabase table setup
--  Run this in your Supabase project:  SQL Editor → New query → paste → Run
-- ============================================================

create table if not exists public.samples (
  id                    uuid primary key,
  sample_id             text,
  saved_at              timestamptz,
  updated_at            timestamptz,
  fix_time              timestamptz,
  -- site / catchment
  site_name             text,
  site_type             text,
  arm                   text,
  zone_ward             text,
  catchment_population  integer,
  -- location
  latitude              double precision,
  longitude             double precision,
  gps_accuracy_m        double precision,
  altitude_m            double precision,
  -- weather
  air_temp_c            double precision,
  humidity_pct          double precision,
  precip_mm             double precision,
  wind_kmh              double precision,
  -- wastewater
  flow_speed_ms         double precision,
  flow_depth_cm         double precision,
  channel_width_cm      double precision,
  flow_rate_lps         double precision,
  water_temp_c          double precision,
  ph                    double precision,
  turbidity_ntu         double precision,
  -- collection
  method                text,
  volume_ml             double precision,
  collector             text,
  notes                 text,
  -- lab (MTB qPCR)
  lab_sample_id         text,
  qpcr_target           text,
  qpcr_ct               double precision,
  qpcr_result           text,
  lab_date              date,
  analyst               text,
  lab_notes             text,
  -- provenance
  device_id             text,
  inserted_at           timestamptz default now()
);

create index if not exists samples_site_idx    on public.samples (site_name);
create index if not exists samples_saved_idx   on public.samples (saved_at);
create index if not exists samples_result_idx  on public.samples (qpcr_result);

-- Safe to re-run: adds the arm column if the table already existed without it.
alter table public.samples add column if not exists arm text;

-- ------------------------------------------------------------
--  Row Level Security
--  The app connects with the ANON public key. The policies below
--  let that key read/insert/update rows. This is fine for a small
--  trusted team, BUT anyone who has the key can read/write. Keep the
--  key private to your collectors. For stronger control, switch to
--  Supabase Auth (each collector signs in) and scope policies to
--  auth.uid(); ask and this can be provided.
-- ------------------------------------------------------------
alter table public.samples enable row level security;

drop policy if exists "team read"   on public.samples;
drop policy if exists "team insert" on public.samples;
drop policy if exists "team update" on public.samples;

create policy "team read"   on public.samples for select to anon using (true);
create policy "team insert" on public.samples for insert to anon with check (true);
create policy "team update" on public.samples for update to anon using (true) with check (true);

-- Optional: allow deletes from the app (off by default for safety).
-- create policy "team delete" on public.samples for delete to anon using (true);
