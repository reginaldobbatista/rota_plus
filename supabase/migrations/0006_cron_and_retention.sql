-- ============================================================================
-- Rota Plus · 0006 · Manutenção automática, retenção e LGPD
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Criação automática da partição do mês seguinte
-- ----------------------------------------------------------------------------
-- Sem isso, no dia 1º do mês todo INSERT falha com "no partition of relation
-- found for row". É o tipo de bug que só aparece em produção, à meia-noite.
create or replace function public.fn_ensure_next_ride_partition()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_start date := date_trunc('month', now() + interval '1 month')::date;
  v_end   date := date_trunc('month', now() + interval '2 month')::date;
  v_name  text := format('ride_evaluations_%s', to_char(v_start, 'YYYY_MM'));
begin
  if not exists (
    select 1 from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
     where n.nspname = 'public' and c.relname = v_name
  ) then
    execute format(
      'create table public.%I partition of public.ride_evaluations
         for values from (%L) to (%L)', v_name, v_start, v_end);
  end if;
end;
$$;

select cron.schedule(
  'ensure-next-ride-partition',
  '0 3 25 * *',                     -- dia 25, 03:00 UTC: folga antes do virar o mês
  $$select public.fn_ensure_next_ride_partition();$$
);

-- ----------------------------------------------------------------------------
-- 2. Retenção do plano Free — histórico de 7 dias
-- ----------------------------------------------------------------------------
create or replace function public.fn_prune_free_tier_history()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  delete from public.ride_evaluations r
   where r.occurred_at < now() - interval '7 days'
     and not public.fn_is_premium(r.user_id);

  insert into public.audit_log (action, metadata)
  values ('retention.free_tier_pruned',
          jsonb_build_object('ran_at', now()));
end;
$$;

select cron.schedule(
  'prune-free-tier-history',
  '30 4 * * *',                     -- diário, 04:30 UTC
  $$select public.fn_prune_free_tier_history();$$
);

-- ----------------------------------------------------------------------------
-- 3. Purga definitiva de contas excluídas (LGPD art. 18, VI)
-- ----------------------------------------------------------------------------
-- Janela de 30 dias para arrependimento/recuperação; depois, apagar de fato.
-- A remoção de auth.users faz o CASCADE limpar todo o resto.
create or replace function public.fn_purge_deleted_accounts()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  r record;
begin
  for r in
    select id from public.profiles
     where deleted_at is not null
       and deleted_at < now() - interval '30 days'
  loop
    delete from auth.users where id = r.id;

    insert into public.audit_log (user_id, action, metadata)
    values (r.id, 'account.purged', jsonb_build_object('purged_at', now()));
  end loop;
end;
$$;

select cron.schedule(
  'purge-deleted-accounts',
  '0 5 * * *',
  $$select public.fn_purge_deleted_accounts();$$
);

-- ----------------------------------------------------------------------------
-- 4. Limpeza de tokens de push mortos e de eventos de webhook antigos
-- ----------------------------------------------------------------------------
select cron.schedule(
  'cleanup-stale-records',
  '15 5 * * 0',                     -- domingos
  $$
    delete from public.device_push_tokens
     where last_seen_at < now() - interval '90 days';

    delete from public.webhook_events
     where processed_at is not null
       and received_at < now() - interval '180 days';

    delete from public.audit_log
     where created_at < now() - interval '2 years';
  $$
);

-- ----------------------------------------------------------------------------
-- 5. Expiração de assinaturas vencidas sem renovação
-- ----------------------------------------------------------------------------
select cron.schedule(
  'expire-stale-subscriptions',
  '0 6 * * *',
  $$
    update public.subscriptions
       set status = 'expired'
     where status in ('active', 'past_due')
       and current_period_end is not null
       and current_period_end < now() - interval '3 days';

    update public.subscriptions
       set status = 'expired'
     where status = 'trialing'
       and trial_ends_at is not null
       and trial_ends_at < now();
  $$
);

-- ----------------------------------------------------------------------------
-- 6. Manutenção estatística — mantém o planner escolhendo bem o índice
-- ----------------------------------------------------------------------------
select cron.schedule(
  'analyze-hot-tables',
  '0 7 * * *',
  $$
    analyze public.ride_evaluations;
    analyze public.expenses;
    analyze public.work_sessions;
  $$
);
