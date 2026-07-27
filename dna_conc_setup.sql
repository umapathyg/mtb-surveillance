-- ============================================================
--  MTB Wastewater Surveillance — add DNA concentration column
--  Run in Supabase → SQL Editor → Run.  Safe to re-run.
--  Records extracted-DNA concentration (ng/µL) per sample.
-- ============================================================

alter table public.samples add column if not exists dna_conc_ng_ul double precision;  -- DNA concentration (ng/µL)

-- If you use the IST view, refresh it so the new column appears there too:
-- (re-run ist_view_setup.sql after this, or add dna_conc_ng_ul to that view).
