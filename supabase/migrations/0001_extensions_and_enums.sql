-- ============================================================================
-- Rota Plus · 0001 · Extensões, enums e utilidades
-- ============================================================================

create extension if not exists "pgcrypto";             -- gen_random_uuid()
create extension if not exists "pg_cron";              -- jobs de retenção/agregação
create extension if not exists "pg_stat_statements";   -- diagnóstico de query lenta
-- create extension if not exists "postgis";           -- Fase 5: heatmap de regiões

-- ---------------------------------------------------------------- enums ----
create type public.fuel_type as enum (
  'gasoline', 'ethanol', 'flex', 'cng', 'diesel', 'electric'
);

create type public.ride_platform as enum (
  'uber', 'ninety_nine', 'indrive', 'other'
);

create type public.ride_verdict as enum ('accept', 'think', 'reject');

create type public.ride_outcome as enum (
  'accepted', 'rejected', 'expired', 'unknown'
);

create type public.expense_category as enum (
  'fuel', 'food', 'car_wash', 'parking', 'maintenance', 'toll', 'fine', 'rent', 'other'
);

create type public.maintenance_kind as enum (
  'oil_change', 'tires', 'brake_pads', 'suspension', 'filters', 'generic'
);

create type public.fixed_cost_kind as enum (
  'ipva', 'insurance', 'licensing', 'vehicle_rent', 'financing', 'other'
);

create type public.subscription_plan as enum ('free', 'monthly', 'quarterly', 'annual');

create type public.subscription_status as enum (
  'trialing', 'active', 'past_due', 'canceled', 'expired'
);

create type public.payment_provider as enum (
  'revenuecat', 'stripe', 'mercadopago', 'manual'
);

-- -------------------------------------------- trigger utilitária: touch ----
create or replace function public.fn_touch_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- --------------------------------- hardening: nada liberado por padrão ----
revoke all on schema public from anon, authenticated;
grant usage on schema public to anon, authenticated;
alter default privileges in schema public revoke all on tables from anon, authenticated;
