-- ============================================================================
-- Rota Plus · 0002 · Schema principal
-- ============================================================================

-- ----------------------------------------------------------------------------
-- profiles — espelho de auth.users com dados de aplicação
-- ----------------------------------------------------------------------------
create table public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  full_name         text check (length(full_name) <= 120),
  email             text,
  avatar_path       text,                      -- caminho no bucket, não URL pública
  phone             text,
  city              text,
  state_uf          char(2),
  tts_enabled       boolean      not null default true,
  tts_rate          numeric(3,2) not null default 1.00
                      check (tts_rate between 0.50 and 2.00),
  theme_mode        text         not null default 'system'
                      check (theme_mode in ('light', 'dark', 'system')),
  nav_app           text         not null default 'waze'
                      check (nav_app in ('waze', 'google_maps')),
  overlay_position  text         not null default 'top'
                      check (overlay_position in ('top', 'center', 'bottom')),
  overlay_timeout_s smallint     not null default 8
                      check (overlay_timeout_s between 3 and 60),
  onboarding_done   boolean      not null default false,
  accepted_terms_at timestamptz,
  created_at        timestamptz  not null default now(),
  updated_at        timestamptz  not null default now(),
  deleted_at        timestamptz
);

comment on table public.profiles is
  'Dados de aplicação do motorista. Nunca armazena dado de passageiro.';

-- ----------------------------------------------------------------------------
-- vehicles
-- ----------------------------------------------------------------------------
create table public.vehicles (
  id                         uuid primary key default gen_random_uuid(),
  user_id                    uuid not null references public.profiles (id) on delete cascade,
  client_id                  uuid not null,                 -- idempotência de sync
  nickname                   text not null check (length(nickname) between 1 and 60),
  make                       text,
  model                      text,
  model_year                 smallint check (model_year between 1950 and 2100),
  plate_suffix               char(4),       -- só os 4 últimos; nunca a placa cheia
  fuel                       public.fuel_type not null default 'flex',
  consumption_km_per_unit    numeric(10,3) not null
                               check (consumption_km_per_unit > 0),   -- km/l ou km/kWh
  fuel_price                 numeric(12,2) not null check (fuel_price >= 0),
  market_value               numeric(12,2) check (market_value >= 0), -- FIPE
  depreciation_per_km        numeric(12,4) not null default 0
                               check (depreciation_per_km >= 0),
  generic_maintenance_per_km numeric(12,4) not null default 0
                               check (generic_maintenance_per_km >= 0),
  work_days_per_month        smallint not null default 24
                               check (work_days_per_month between 1 and 31),
  km_per_day                 numeric(10,2) not null default 150
                               check (km_per_day > 0),
  is_default                 boolean not null default false,
  created_at                 timestamptz not null default now(),
  updated_at                 timestamptz not null default now(),
  deleted_at                 timestamptz,
  unique (user_id, client_id)
);

create index idx_vehicles_user on public.vehicles (user_id) where deleted_at is null;

-- ----------------------------------------------------------------------------
-- maintenance_items — custo + intervalo, rateado por km
-- ----------------------------------------------------------------------------
create table public.maintenance_items (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  vehicle_id  uuid not null references public.vehicles (id) on delete cascade,
  kind        public.maintenance_kind not null,
  label       text,
  cost        numeric(12,2) not null check (cost >= 0),
  interval_km numeric(10,2) not null check (interval_km > 0),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

create index idx_maint_vehicle on public.maintenance_items (vehicle_id);
create index idx_maint_user    on public.maintenance_items (user_id);

-- ----------------------------------------------------------------------------
-- fixed_costs
-- ----------------------------------------------------------------------------
create table public.fixed_costs (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references public.profiles (id) on delete cascade,
  vehicle_id     uuid not null references public.vehicles (id) on delete cascade,
  kind           public.fixed_cost_kind not null,
  label          text,
  annual_amount  numeric(12,2) check (annual_amount  >= 0),
  monthly_amount numeric(12,2) check (monthly_amount >= 0),
  created_at     timestamptz not null default now(),
  updated_at     timestamptz not null default now(),
  constraint chk_fixed_cost_amount
    check (annual_amount is not null or monthly_amount is not null)
);

create index idx_fixed_vehicle on public.fixed_costs (vehicle_id);
create index idx_fixed_user    on public.fixed_costs (user_id);

-- ----------------------------------------------------------------------------
-- work_profiles — metas + veículo (máx. 10 por usuário, imposto por trigger)
-- ----------------------------------------------------------------------------
create table public.work_profiles (
  id                   uuid primary key default gen_random_uuid(),
  user_id              uuid not null references public.profiles (id) on delete cascade,
  client_id            uuid not null,
  name                 text not null check (length(name) between 1 and 60),
  vehicle_id           uuid references public.vehicles (id) on delete set null,
  goal_rs_per_km       numeric(12,2) not null check (goal_rs_per_km   >= 0),
  goal_rs_per_hour     numeric(12,2) not null check (goal_rs_per_hour >= 0),
  min_passenger_rating numeric(3,2)  not null default 4.50
                         check (min_passenger_rating between 0 and 5),
  max_pickup_km        numeric(10,2) not null default 5 check (max_pickup_km >= 0),
  daily_revenue_goal   numeric(12,2) not null default 0 check (daily_revenue_goal   >= 0),
  monthly_revenue_goal numeric(12,2) not null default 0 check (monthly_revenue_goal >= 0),
  think_tolerance_pct  numeric(5,2)  not null default 15.00
                         check (think_tolerance_pct between 0 and 100),
  target_margin_pct    numeric(5,2)  not null default 30.00
                         check (target_margin_pct between 0 and 500),
  -- custo/km materializado: o overlay precisa de leitura O(1), sem recomputar nada
  cached_cost_per_km   numeric(12,4),
  cached_at            timestamptz,
  is_active            boolean not null default false,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  deleted_at           timestamptz,
  unique (user_id, client_id)
);

create index idx_wp_user on public.work_profiles (user_id) where deleted_at is null;

-- Só um perfil ativo por usuário — garantido por índice parcial, não por app
create unique index uq_wp_one_active
  on public.work_profiles (user_id)
  where is_active and deleted_at is null;

-- ----------------------------------------------------------------------------
-- work_sessions — horas trabalhadas reais (base do R$/hora do fechamento)
-- ----------------------------------------------------------------------------
create table public.work_sessions (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  client_id       uuid not null,
  work_profile_id uuid references public.work_profiles (id) on delete set null,
  started_at      timestamptz not null,
  ended_at        timestamptz,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  unique (user_id, client_id),
  constraint chk_session_order check (ended_at is null or ended_at > started_at)
);

create index idx_sessions_user_time
  on public.work_sessions (user_id, started_at desc);

-- ----------------------------------------------------------------------------
-- ride_evaluations — maior volume do sistema; PARTICIONADA por mês
-- ----------------------------------------------------------------------------
create table public.ride_evaluations (
  id               uuid not null default gen_random_uuid(),
  user_id          uuid not null references public.profiles (id) on delete cascade,
  client_id        uuid not null,
  work_profile_id  uuid references public.work_profiles (id) on delete set null,
  work_session_id  uuid references public.work_sessions (id) on delete set null,
  platform         public.ride_platform not null,
  occurred_at      timestamptz not null,

  -- dados capturados: apenas numéricos + nome da região
  fare             numeric(12,2) not null check (fare >= 0),
  pickup_km        numeric(10,3) not null check (pickup_km >= 0),
  trip_km          numeric(10,3) not null check (trip_km   >= 0),
  pickup_minutes   numeric(10,2) not null default 0 check (pickup_minutes >= 0),
  trip_minutes     numeric(10,2) not null default 0 check (trip_minutes   >= 0),
  passenger_rating numeric(3,2) check (passenger_rating between 0 and 5),
  pickup_region    text check (length(pickup_region) <= 120),
  surge_multiplier numeric(5,2) check (surge_multiplier >= 0),

  -- métricas derivadas, gravadas para não recalcular em relatório
  total_km         numeric(10,3) generated always as (pickup_km + trip_km) stored,
  total_minutes    numeric(10,2) generated always as (pickup_minutes + trip_minutes) stored,
  rs_per_km        numeric(12,4) not null,
  rs_per_hour      numeric(12,4) not null,
  cost_per_km_used numeric(12,4) not null,
  operating_cost   numeric(12,2) not null,
  real_profit      numeric(12,2) not null,
  margin_pct       numeric(7,2),

  verdict          public.ride_verdict not null,
  outcome          public.ride_outcome not null default 'unknown',

  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  primary key (id, occurred_at)
) partition by range (occurred_at);

comment on table public.ride_evaluations is
  'Uma linha por corrida avaliada. Particionada por mês: habilita poda de partição '
  'nos relatórios e DROP instantâneo na retenção, em vez de DELETE de milhões de linhas.';

-- Partições iniciais (as futuras são criadas por pg_cron — ver 0006)
create table public.ride_evaluations_2026_10
  partition of public.ride_evaluations
  for values from ('2026-10-01') to ('2026-11-01');
create table public.ride_evaluations_2026_11
  partition of public.ride_evaluations
  for values from ('2026-11-01') to ('2026-12-01');
create table public.ride_evaluations_2026_12
  partition of public.ride_evaluations
  for values from ('2026-12-01') to ('2027-01-01');

-- user_id SEMPRE primeiro: é a coluna que a RLS filtra
create index idx_rides_user_time
  on public.ride_evaluations (user_id, occurred_at desc);
create index idx_rides_user_platform
  on public.ride_evaluations (user_id, platform, occurred_at desc);
create index idx_rides_user_verdict
  on public.ride_evaluations (user_id, verdict, occurred_at desc);
create unique index uq_rides_user_client
  on public.ride_evaluations (user_id, client_id, occurred_at);

-- ----------------------------------------------------------------------------
-- expenses
-- ----------------------------------------------------------------------------
create table public.expenses (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references public.profiles (id) on delete cascade,
  client_id       uuid not null,
  vehicle_id      uuid references public.vehicles (id) on delete set null,
  work_session_id uuid references public.work_sessions (id) on delete set null,
  category        public.expense_category not null,
  amount          numeric(12,2) not null check (amount >= 0),
  liters          numeric(10,3) check (liters >= 0),      -- abastecimento real
  odometer_km     numeric(12,1) check (odometer_km >= 0),
  description     text check (length(description) <= 500),
  receipt_path    text,                                   -- bucket privado
  occurred_at     timestamptz not null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz,
  unique (user_id, client_id)
);

create index idx_expenses_user_time
  on public.expenses (user_id, occurred_at desc) where deleted_at is null;
create index idx_expenses_user_category
  on public.expenses (user_id, category, occurred_at desc);

-- ----------------------------------------------------------------------------
-- subscriptions — SOMENTE service_role escreve (webhook assinado)
-- ----------------------------------------------------------------------------
create table public.subscriptions (
  user_id              uuid primary key references public.profiles (id) on delete cascade,
  plan                 public.subscription_plan   not null default 'free',
  status               public.subscription_status not null default 'trialing',
  provider             public.payment_provider,
  provider_customer_id text,
  provider_sub_id      text,
  trial_ends_at        timestamptz,
  current_period_end   timestamptz,
  cancel_at_period_end boolean not null default false,
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

create index idx_subs_status on public.subscriptions (status, current_period_end);

comment on table public.subscriptions is
  'Fonte única de verdade do entitlement. O cliente só LÊ. Qualquer escrita vem de '
  'Edge Function com service_role, após validar assinatura do webhook.';

-- ----------------------------------------------------------------------------
-- ride_quota_usage — contador diário do plano Free
-- ----------------------------------------------------------------------------
create table public.ride_quota_usage (
  user_id    uuid not null references public.profiles (id) on delete cascade,
  usage_date date not null,
  used_count integer not null default 0 check (used_count >= 0),
  primary key (user_id, usage_date)
);

-- ----------------------------------------------------------------------------
-- coupons / coupon_redemptions
-- ----------------------------------------------------------------------------
create table public.coupons (
  code            text primary key check (code = upper(code)),
  description     text,
  discount_pct    smallint check (discount_pct between 1 and 100),
  free_days       smallint check (free_days between 1 and 365),
  max_redemptions integer,
  redeemed_count  integer not null default 0,
  valid_from      timestamptz not null default now(),
  valid_until     timestamptz,
  influencer_tag  text,
  is_active       boolean not null default true,
  created_at      timestamptz not null default now(),
  constraint chk_coupon_benefit
    check (discount_pct is not null or free_days is not null)
);

create table public.coupon_redemptions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  coupon_code text not null references public.coupons (code),
  redeemed_at timestamptz not null default now(),
  unique (user_id, coupon_code)
);

-- ----------------------------------------------------------------------------
-- device_push_tokens
-- ----------------------------------------------------------------------------
create table public.device_push_tokens (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references public.profiles (id) on delete cascade,
  token        text not null unique,
  platform     text not null check (platform in ('android', 'ios')),
  app_version  text,
  last_seen_at timestamptz not null default now(),
  created_at   timestamptz not null default now()
);

create index idx_tokens_user on public.device_push_tokens (user_id);

-- ----------------------------------------------------------------------------
-- webhook_events — idempotência; nunca exposta ao cliente
-- ----------------------------------------------------------------------------
create table public.webhook_events (
  id           uuid primary key default gen_random_uuid(),
  provider     public.payment_provider not null,
  external_id  text not null,
  payload      jsonb not null,
  processed_at timestamptz,
  error        text,
  received_at  timestamptz not null default now(),
  unique (provider, external_id)
);

-- ----------------------------------------------------------------------------
-- audit_log — rastro de ações sensíveis
-- ----------------------------------------------------------------------------
create table public.audit_log (
  id         bigserial primary key,
  user_id    uuid,
  action     text not null,
  table_name text,
  record_id  text,
  metadata   jsonb,
  created_at timestamptz not null default now()
);

create index idx_audit_user_time on public.audit_log (user_id, created_at desc);

-- ----------------------------------------------------------------------------
-- updated_at automático
-- ----------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'profiles', 'vehicles', 'maintenance_items', 'fixed_costs', 'work_profiles',
    'work_sessions', 'ride_evaluations', 'expenses', 'subscriptions'
  ]
  loop
    execute format(
      'create trigger trg_touch_%1$s before update on public.%1$s
         for each row execute function public.fn_touch_updated_at()', t);
  end loop;
end $$;
