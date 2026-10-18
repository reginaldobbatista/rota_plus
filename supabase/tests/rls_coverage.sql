-- ============================================================================
-- Rota Plus · Verificação de cobertura de RLS
-- ============================================================================
-- Roda no CI depois de aplicar todas as migrations. Falha o build se houver
-- qualquer furo.
--
-- Um furo de RLS não é bug de funcionalidade: é o dado financeiro de um
-- motorista visível para outro. Por isso bloqueia merge.
--
-- Uso: psql "$DATABASE_URL" --set ON_ERROR_STOP=1 -f supabase/tests/rls_coverage.sql
-- ============================================================================

\echo '== 1. Toda tabela em public precisa ter RLS habilitada =='
do $$
declare
  offenders text;
begin
  select string_agg(c.relname, ', ' order by c.relname)
    into offenders
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public'
     and c.relkind = 'r'
     and not c.relrowsecurity;

  if offenders is not null then
    raise exception 'Tabelas em public sem RLS habilitada: %', offenders;
  end if;
end $$;

\echo '== 2. Toda tabela com RLS precisa ter ao menos uma policy =='
-- RLS habilitada sem policy nenhuma nega tudo. É seguro, mas quase sempre
-- indica policy esquecida — e o sintoma em produção é "o app não mostra nada".
do $$
declare
  offenders text;
begin
  select string_agg(c.relname, ', ' order by c.relname)
    into offenders
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public'
     and c.relkind = 'r'
     and c.relrowsecurity
     and c.relname not in ('webhook_events')  -- cega para o cliente, de propósito
     and not exists (
       select 1 from pg_policy p where p.polrelid = c.oid
     );

  if offenders is not null then
    raise exception 'Tabelas com RLS mas sem nenhuma policy: %', offenders;
  end if;
end $$;

\echo '== 3. `anon` não pode escrever em nenhuma tabela =='
do $$
declare
  offenders text;
begin
  select string_agg(
           format('%s(%s)', table_name, privilege_type), ', '
           order by table_name, privilege_type)
    into offenders
    from information_schema.role_table_grants
   where grantee = 'anon'
     and table_schema = 'public'
     and privilege_type in ('INSERT', 'UPDATE', 'DELETE', 'TRUNCATE');

  if offenders is not null then
    raise exception 'Role anon tem permissão de escrita: %', offenders;
  end if;
end $$;

\echo '== 4. `authenticated` não pode escrever em subscriptions =='
-- É o que impede o usuário de se promover a premium. Só o service_role,
-- dentro de uma Edge Function com webhook assinado, escreve aqui.
do $$
declare
  offenders text;
begin
  select string_agg(privilege_type, ', ' order by privilege_type)
    into offenders
    from information_schema.role_table_grants
   where grantee = 'authenticated'
     and table_schema = 'public'
     and table_name = 'subscriptions'
     and privilege_type in ('INSERT', 'UPDATE', 'DELETE');

  if offenders is not null then
    raise exception
      'Role authenticated pode escrever em subscriptions: %', offenders;
  end if;
end $$;

\echo '== 5. Função security definer precisa fixar search_path =='
-- Sem `set search_path = ''`, um schema malicioso no search_path do chamador
-- sequestra a resolução de nomes e executa código com o privilégio do dono.
do $$
declare
  offenders text;
begin
  select string_agg(p.proname, ', ' order by p.proname)
    into offenders
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'public'
     and p.prosecdef
     and not exists (
       select 1 from unnest(coalesce(p.proconfig, '{}')) as cfg
        where cfg like 'search_path=%'
     );

  if offenders is not null then
    raise exception
      'Funções security definer sem search_path fixo: %', offenders;
  end if;
end $$;

\echo '== 6. Views de relatório precisam de security_invoker =='
-- Sem isso a view roda com privilégio do dono e ignora a RLS das tabelas
-- base: a tabela fica protegida e a view que a lê, não.
do $$
declare
  offenders text;
begin
  select string_agg(c.relname, ', ' order by c.relname)
    into offenders
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public'
     and c.relkind = 'v'
     and not exists (
       select 1 from unnest(coalesce(c.reloptions, '{}')) as opt
        where opt = 'security_invoker=true'
     );

  if offenders is not null then
    raise exception 'Views sem security_invoker: %', offenders;
  end if;
end $$;

\echo '== 7. Tabelas esperadas existem =='
do $$
declare
  missing text;
begin
  select string_agg(expected, ', ' order by expected)
    into missing
    from unnest(array[
      'profiles', 'vehicles', 'maintenance_items', 'fixed_costs',
      'work_profiles', 'work_sessions', 'ride_evaluations', 'expenses',
      'subscriptions', 'ride_quota_usage', 'coupons', 'coupon_redemptions',
      'device_push_tokens', 'webhook_events', 'audit_log'
    ]) as expected
   where not exists (
     select 1
       from pg_class c
       join pg_namespace n on n.oid = c.relnamespace
      where n.nspname = 'public' and c.relname = expected
   );

  if missing is not null then
    raise exception 'Tabelas ausentes após as migrations: %', missing;
  end if;
end $$;

\echo '== 8. RPCs de sincronização existem e são executáveis =='
do $$
declare
  missing text;
begin
  select string_agg(expected, ', ' order by expected)
    into missing
    from unnest(array[
      'rpc_sync_rides', 'rpc_sync_expenses', 'rpc_consume_ride_quota',
      'fn_calculate_cost_per_km', 'fn_is_premium'
    ]) as expected
   where not exists (
     select 1
       from pg_proc p
       join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public' and p.proname = expected
   );

  if missing is not null then
    raise exception 'Funções ausentes após as migrations: %', missing;
  end if;
end $$;

\echo ''
\echo 'OK — todas as verificações de segurança do banco passaram.'
