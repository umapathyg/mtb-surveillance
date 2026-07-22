-- ============================================================
--  MTB Wastewater Surveillance — Indian Standard Time (IST) view
--  Run in Supabase → SQL Editor → Run.  Safe to re-run.
--
--  WHY: Postgres 'timestamptz' always stores the instant in UTC and
--  displays it in UTC in the dashboard. Nothing is wrong with the data —
--  this view simply presents the same instants converted to IST
--  (Asia/Kolkata, UTC+5:30) so the table reads in local time.
--
--  AFTER RUNNING: open Table Editor → v_samples_ist   (use this instead
--  of 'samples' for day-to-day viewing and CSV download).
-- ============================================================

create or replace view public.v_samples_ist as
select
  sample_id,
  -- IST versions (what you read)
  (saved_at  at time zone 'Asia/Kolkata') as collected_ist,
  (fix_time  at time zone 'Asia/Kolkata') as gps_fix_ist,
  (updated_at at time zone 'Asia/Kolkata') as updated_ist,
  to_char(saved_at at time zone 'Asia/Kolkata', 'DD-Mon-YYYY HH24:MI') as collected_ist_text,
  (saved_at at time zone 'Asia/Kolkata')::date as collection_date_ist,
  -- site / catchment
  zone_ward   as zone,
  site_name,
  site_type,
  catchment_population,
  -- location
  latitude, longitude, gps_accuracy_m, altitude_m,
  -- weather
  air_temp_c, humidity_pct, precip_mm, wind_kmh,
  -- wastewater
  flow_speed_ms, flow_depth_cm, channel_width_cm, flow_rate_lps,
  water_temp_c, ph, turbidity_ntu,
  -- collection
  method, volume_ml, collector, notes,
  -- lab: IS6110
  is6110_result, is6110_ct, is6110_copies_ml,
  -- lab: RD9
  rd9_result, rd9_ct, rd9_copies_ml,
  lab_sample_id, lab_date, analyst, lab_notes,
  -- originals kept for reference
  saved_at as saved_at_utc,
  id
from public.samples;

-- Let signed-in collectors read the view (matches the samples table policy)
grant select on public.v_samples_ist to authenticated;

-- Optional: make YOUR OWN dashboard sessions display IST by default.
-- (Affects only this database role's display, not the stored data.)
-- alter role authenticator set timezone to 'Asia/Kolkata';
