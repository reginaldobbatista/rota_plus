-- ============================================================================
-- Rota Plus · 0004 · Funções e triggers
-- ============================================================================
-- Toda função `security definer` declara `set search_path = ''` e qualifica os
-- nomes. Sem isso, um schema malicioso no search_path do chamador pode
-- sequestrar a resolução de nome e executar código com privilégio do dono.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Criação automática de profile + assinatura trial no signup
-- ----------------------------------------------------------------------------
create or replace function public.fn_handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, email, full_name, avatar_path)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name',
             new.raw_user_meta_data ->> 'name'),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;

  insert into public.subscriptions (user_id, plan, status, trial_ends_at)
  values (new.id, 'free', 'trialing', now() + interval '7 days')
  on conflict (user_id) do nothing;

  insert into public.audit_log (user_id, action, metadata)
  values (new.id, 'account.created', jsonb_build_object('provider',
          new.raw_app_meta_data ->> 'provider'));

  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.fn_handle_new_user();

-- ----------------------------------------------------------------------------
-- 2. Limite de 10 perfis de trabalho — regra de negócio no banco
-- ----------------------------------------------------------------------------
create or replace function public.fn_enforce_work_profile_limit()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  total integer;
begin
  select count(*) into total
    from public.work_profiles
   where user_id = new.user_id
     and deleted_at is null;

  if total >= 10 then
    raise exception 'Limite de 10 perfis de trabalho atingido.'
      using errcode = 'check_violation';
  end if;

  return new;
end;
$$;

create trigger trg_enforce_work_profile_limit
  before insert on public.work_profiles
  for each row execute function public.fn_enforce_work_profile_limit();

-- ----------------------------------------------------------------------------
-- 3. Custo por km — a MESMA fórmula que roda em Dart, aqui para relatórios
-- ----------------------------------------------------------------------------
create or replace function public.fn_calculate_cost_per_km(p_vehicle_id uuid)
returns numeric
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v            public.vehicles;
  maint_per_km numeric(12,4) := 0;
  fixed_month  numeric(12,2) := 0;
  fixed_per_km numeric(12,4) := 0;
begin
  select * into v from public.vehicles where id = p_vehicle_id;
  if not found then
    return null;
  end if;

  -- manutenção detalhada: soma de custo/intervalo de cada item
  select coalesce(sum(cost / interval_km), 0) into maint_per_km
    from public.maintenance_items
   where vehicle_id = p_vehicle_id;

  -- custos fixos normalizados para o mês
  select coalesce(sum(coalesce(monthly_amount, annual_amount / 12.0)), 0)
    into fixed_month
    from public.fixed_costs
   where vehicle_id = p_vehicle_id;

  fixed_per_km := fixed_month / nullif(v.work_days_per_month * v.km_per_day, 0);

  return round(
      (v.fuel_price / v.consumption_km_per_unit)
    + maint_per_km
    + v.generic_maintenance_per_km
    + v.depreciation_per_km
    + coalesce(fixed_per_km, 0)
  , 4);
end;
$$;

grant execute on function public.fn_calculate_cost_per_km(uuid) to authenticated;

-- ----------------------------------------------------------------------------
-- 4. Invalidação do custo cacheado nos perfis quando o veículo muda
-- ----------------------------------------------------------------------------
-- Duas funções, porque NEW/OLD têm formatos diferentes: em `vehicles` o veículo é
-- `id`, nas tabelas de custo é `vehicle_id`. Uma função só para as duas daria
-- "record new has no field vehicle_id" em tempo de execução.
create or replace function public.fn_invalidate_cost_cache_by_vehicle()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.work_profiles
     set cached_cost_per_km = null,
         cached_at          = null
   where vehicle_id = coalesce(new.id, old.id);
  return coalesce(new, old);
end;
$$;

create or replace function public.fn_invalidate_cost_cache_by_cost_row()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.work_profiles
     set cached_cost_per_km = null,
         cached_at          = null
   where vehicle_id = coalesce(new.vehicle_id, old.vehicle_id);
  return coalesce(new, old);
end;
$$;

create trigger trg_invalidate_cache_vehicle
  after update or delete on public.vehicles
  for each row execute function public.fn_invalidate_cost_cache_by_vehicle();

create trigger trg_invalidate_cache_maint
  after insert or update or delete on public.maintenance_items
  for each row execute function public.fn_invalidate_cost_cache_by_cost_row();

create trigger trg_invalidate_cache_fixed
  after insert or update or delete on public.fixed_costs
  for each row execute function public.fn_invalidate_cost_cache_by_cost_row();

-- ----------------------------------------------------------------------------
-- 5. Entitlement — fonte única de verdade sobre "é premium?"
-- ----------------------------------------------------------------------------
create or replace function public.fn_is_premium(p_user_id uuid default null)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
      from public.subscriptions s
     where s.user_id = coalesce(p_user_id, (select auth.uid()))
       and (
            (s.status = 'active'   and (s.current_period_end is null
                                        or s.current_period_end > now()))
         or (s.status = 'trialing' and s.trial_ends_at is not null
                                   and s.trial_ends_at > now())
       )
  );
$$;

grant execute on function public.fn_is_premium(uuid) to authenticated;

-- ----------------------------------------------------------------------------
-- 6. Quota do plano Free — 3 avaliações/dia, contadas no servidor
-- ----------------------------------------------------------------------------
create or replace function public.rpc_consume_ride_quota()
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid     uuid := (select auth.uid());
  v_premium boolean;
  v_used    integer;
  c_limit   constant integer := 3;
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  v_premium := public.fn_is_premium(v_uid);
  if v_premium then
    return jsonb_build_object('allowed', true, 'premium', true, 'remaining', null);
  end if;

  -- UPSERT atômico: duas requisições simultâneas não furam o limite.
  -- O alias `q` é necessário: dentro de ON CONFLICT ... DO UPDATE a referência à
  -- linha existente não aceita nome qualificado por schema.
  insert into public.ride_quota_usage as q (user_id, usage_date, used_count)
  values (v_uid, current_date, 1)
  on conflict (user_id, usage_date) do update
     set used_count = q.used_count + 1
   where q.used_count < c_limit
  returning q.used_count into v_used;

  if v_used is null then
    return jsonb_build_object(
      'allowed',   false,
      'premium',   false,
      'remaining', 0,
      'reason',    'daily_quota_exceeded'
    );
  end if;

  return jsonb_build_object(
    'allowed',   true,
    'premium',   false,
    'remaining', c_limit - v_used
  );
end;
$$;

grant execute on function public.rpc_consume_ride_quota() to authenticated;

-- ----------------------------------------------------------------------------
-- 7. Sync em lote — o outbox do app sobe N corridas numa chamada
-- ----------------------------------------------------------------------------
-- Uma requisição com 50 corridas em vez de 50 requisições: menos handshake TLS,
-- menos wakeup de rádio, menos bateria. Idempotente por (user_id, client_id).
create or replace function public.rpc_sync_rides(p_rides jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid      uuid := (select auth.uid());
  v_inserted integer;
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  if jsonb_typeof(p_rides) <> 'array' then
    raise exception 'p_rides deve ser um array JSON.' using errcode = '22023';
  end if;

  if jsonb_array_length(p_rides) > 200 then
    raise exception 'Lote máximo de 200 corridas.' using errcode = '22023';
  end if;

  with payload as (
    select * from jsonb_to_recordset(p_rides) as r(
      client_id        uuid,
      work_profile_id  uuid,
      work_session_id  uuid,
      platform         text,
      occurred_at      timestamptz,
      fare             numeric,
      pickup_km        numeric,
      trip_km          numeric,
      pickup_minutes   numeric,
      trip_minutes     numeric,
      passenger_rating numeric,
      pickup_region    text,
      surge_multiplier numeric,
      rs_per_km        numeric,
      rs_per_hour      numeric,
      cost_per_km_used numeric,
      operating_cost   numeric,
      real_profit      numeric,
      margin_pct       numeric,
      verdict          text,
      outcome          text
    )
  )
  insert into public.ride_evaluations (
    user_id, client_id, work_profile_id, work_session_id, platform, occurred_at,
    fare, pickup_km, trip_km, pickup_minutes, trip_minutes, passenger_rating,
    pickup_region, surge_multiplier, rs_per_km, rs_per_hour, cost_per_km_used,
    operating_cost, real_profit, margin_pct, verdict, outcome
  )
  select
    v_uid, p.client_id, p.work_profile_id, p.work_session_id,
    p.platform::public.ride_platform, p.occurred_at,
    p.fare, p.pickup_km, p.trip_km, coalesce(p.pickup_minutes, 0),
    coalesce(p.trip_minutes, 0), p.passenger_rating,
    -- sanitização defensiva: região é nome de bairro, não endereço
    left(regexp_replace(coalesce(p.pickup_region, ''), '[0-9]{3,}', '', 'g'), 120),
    p.surge_multiplier, p.rs_per_km, p.rs_per_hour, p.cost_per_km_used,
    p.operating_cost, p.real_profit, p.margin_pct,
    p.verdict::public.ride_verdict,
    coalesce(p.outcome, 'unknown')::public.ride_outcome
  from payload p
  on conflict (user_id, client_id, occurred_at) do nothing;

  get diagnostics v_inserted = row_count;

  return jsonb_build_object(
    'received', jsonb_array_length(p_rides),
    'inserted', v_inserted
  );
end;
$$;

grant execute on function public.rpc_sync_rides(jsonb) to authenticated;

-- ----------------------------------------------------------------------------
-- 8. Soft delete de conta (chamada pela Edge Function delete-account)
-- ----------------------------------------------------------------------------
create or replace function public.rpc_request_account_deletion()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  update public.profiles set deleted_at = now() where id = v_uid;

  insert into public.audit_log (user_id, action, metadata)
  values (v_uid, 'account.deletion_requested',
          jsonb_build_object('purge_after', now() + interval '30 days'));
end;
$$;

grant execute on function public.rpc_request_account_deletion() to authenticated;
