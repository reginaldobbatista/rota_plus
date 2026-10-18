-- ============================================================================
-- Rota Plus · 0005 · Views de relatório
-- ============================================================================
-- `security_invoker = true` (Postgres 15+) é OBRIGATÓRIO aqui. Sem isso a view
-- roda com privilégio do dono e ignora a RLS das tabelas base — um vazamento
-- clássico: a tabela está protegida, a view que a lê não está.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Fechamento diário — substitui o laço no cliente que o Firestore exigia
-- ----------------------------------------------------------------------------
create view public.v_daily_summary
with (security_invoker = true) as
with rides as (
  select
    user_id,
    (occurred_at at time zone 'America/Boa_Vista')::date as day,
    count(*)                                              as rides_evaluated,
    count(*) filter (where outcome = 'accepted')           as rides_accepted,
    count(*) filter (where outcome = 'rejected')           as rides_rejected,
    count(*) filter (where verdict = 'accept')             as verdict_accept,
    count(*) filter (where verdict = 'think')              as verdict_think,
    count(*) filter (where verdict = 'reject')             as verdict_reject,
    coalesce(sum(fare)           filter (where outcome = 'accepted'), 0) as gross_revenue,
    coalesce(sum(operating_cost) filter (where outcome = 'accepted'), 0) as operating_cost,
    coalesce(sum(real_profit)    filter (where outcome = 'accepted'), 0) as net_profit,
    coalesce(sum(total_km)       filter (where outcome = 'accepted'), 0) as km_driven,
    avg(rs_per_km)   filter (where outcome = 'accepted')                 as avg_rs_per_km,
    avg(rs_per_hour) filter (where outcome = 'accepted')                 as avg_rs_per_hour
  from public.ride_evaluations
  group by 1, 2
),
extra as (
  select
    user_id,
    (occurred_at at time zone 'America/Boa_Vista')::date as day,
    coalesce(sum(amount), 0)                             as extra_expenses
  from public.expenses
  where deleted_at is null
  group by 1, 2
),
hours as (
  select
    user_id,
    (started_at at time zone 'America/Boa_Vista')::date as day,
    coalesce(sum(
      extract(epoch from (coalesce(ended_at, now()) - started_at)) / 3600.0
    ), 0) as hours_worked
  from public.work_sessions
  group by 1, 2
)
select
  coalesce(r.user_id, e.user_id, h.user_id)                as user_id,
  coalesce(r.day, e.day, h.day)                            as day,
  coalesce(r.rides_evaluated, 0)                           as rides_evaluated,
  coalesce(r.rides_accepted, 0)                            as rides_accepted,
  coalesce(r.rides_rejected, 0)                            as rides_rejected,
  coalesce(r.verdict_accept, 0)                            as verdict_accept,
  coalesce(r.verdict_think, 0)                             as verdict_think,
  coalesce(r.verdict_reject, 0)                            as verdict_reject,
  coalesce(r.gross_revenue, 0)                             as gross_revenue,
  coalesce(r.operating_cost, 0)                            as operating_cost,
  coalesce(e.extra_expenses, 0)                            as extra_expenses,
  coalesce(r.net_profit, 0) - coalesce(e.extra_expenses, 0) as net_profit,
  coalesce(r.km_driven, 0)                                 as km_driven,
  round(coalesce(h.hours_worked, 0)::numeric, 2)           as hours_worked,
  r.avg_rs_per_km,
  r.avg_rs_per_hour,
  case
    when coalesce(h.hours_worked, 0) > 0
    then round((coalesce(r.gross_revenue, 0) / h.hours_worked)::numeric, 2)
  end                                                      as effective_rs_per_hour
from rides r
full join extra e on e.user_id = r.user_id and e.day = r.day
full join hours h on h.user_id = coalesce(r.user_id, e.user_id)
                 and h.day     = coalesce(r.day, e.day);

-- ----------------------------------------------------------------------------
-- Fechamento mensal
-- ----------------------------------------------------------------------------
create view public.v_monthly_summary
with (security_invoker = true) as
select
  user_id,
  date_trunc('month', day)::date       as month,
  sum(rides_evaluated)                 as rides_evaluated,
  sum(rides_accepted)                  as rides_accepted,
  sum(gross_revenue)                   as gross_revenue,
  sum(operating_cost)                  as operating_cost,
  sum(extra_expenses)                  as extra_expenses,
  sum(net_profit)                      as net_profit,
  sum(km_driven)                       as km_driven,
  sum(hours_worked)                    as hours_worked,
  round(avg(avg_rs_per_km), 4)         as avg_rs_per_km,
  case
    when sum(hours_worked) > 0
    then round(sum(gross_revenue) / sum(hours_worked), 2)
  end                                  as effective_rs_per_hour,
  count(*) filter (where rides_evaluated > 0) as active_days
from public.v_daily_summary
group by 1, 2;

-- ----------------------------------------------------------------------------
-- Comparativo entre plataformas
-- ----------------------------------------------------------------------------
create view public.v_platform_comparison
with (security_invoker = true) as
select
  user_id,
  platform,
  count(*)                                            as offers,
  count(*) filter (where outcome = 'accepted')        as accepted,
  round(
    100.0 * count(*) filter (where outcome = 'accepted')
    / nullif(count(*), 0), 1)                         as acceptance_rate_pct,
  round(avg(rs_per_km), 4)                            as avg_rs_per_km,
  round(avg(rs_per_hour), 2)                          as avg_rs_per_hour,
  round(avg(fare), 2)                                 as avg_fare,
  coalesce(sum(real_profit) filter (where outcome = 'accepted'), 0) as total_profit
from public.ride_evaluations
group by 1, 2;

-- ----------------------------------------------------------------------------
-- Heatmap: melhores horas × dia da semana
-- ----------------------------------------------------------------------------
create view public.v_hour_heatmap
with (security_invoker = true) as
select
  user_id,
  extract(dow  from occurred_at at time zone 'America/Boa_Vista')::smallint as weekday,
  extract(hour from occurred_at at time zone 'America/Boa_Vista')::smallint as hour_of_day,
  count(*)                    as offers,
  round(avg(rs_per_km), 4)    as avg_rs_per_km,
  round(avg(rs_per_hour), 2)  as avg_rs_per_hour,
  round(avg(fare), 2)         as avg_fare
from public.ride_evaluations
group by 1, 2, 3;

grant select on
  public.v_daily_summary,
  public.v_monthly_summary,
  public.v_platform_comparison,
  public.v_hour_heatmap
  to authenticated;
