-- ============================================================================
-- Rota Plus · 0003 · Row Level Security
-- ============================================================================
-- Princípios:
--   1. RLS habilitada em TODAS as tabelas de public, sem exceção.
--   2. Uma policy por comando (select/insert/update/delete) — mais legível e
--      auditável do que uma policy "for all".
--   3. `(select auth.uid())` em vez de `auth.uid()`: o planner trata como
--      InitPlan e avalia UMA vez por query, não uma vez por linha. Em tabela de
--      centenas de milhares de linhas isso muda a ordem de grandeza do tempo.
--   4. `to authenticated` sempre explícito — nunca deixar `anon` cair numa policy.
--   5. Toda coluna usada em policy é indexada (ver 0002).
-- ============================================================================

alter table public.profiles            enable row level security;
alter table public.vehicles            enable row level security;
alter table public.maintenance_items   enable row level security;
alter table public.fixed_costs         enable row level security;
alter table public.work_profiles       enable row level security;
alter table public.work_sessions       enable row level security;
alter table public.ride_evaluations    enable row level security;
alter table public.expenses            enable row level security;
alter table public.subscriptions       enable row level security;
alter table public.ride_quota_usage    enable row level security;
alter table public.coupons             enable row level security;
alter table public.coupon_redemptions  enable row level security;
alter table public.device_push_tokens  enable row level security;
alter table public.webhook_events      enable row level security;
alter table public.audit_log           enable row level security;

-- Defesa extra: nem o dono da tabela escapa da RLS por engano.
alter table public.subscriptions    force row level security;
alter table public.ride_quota_usage force row level security;
alter table public.webhook_events   force row level security;

-- ----------------------------------------------------------------------------
-- Grants: a RLS filtra LINHAS, o grant libera a OPERAÇÃO. Precisa dos dois.
-- ----------------------------------------------------------------------------
grant select, insert, update, delete on
  public.vehicles, public.maintenance_items, public.fixed_costs,
  public.work_profiles, public.work_sessions, public.ride_evaluations,
  public.expenses, public.device_push_tokens
  to authenticated;

grant select, update on public.profiles to authenticated;
grant select on public.subscriptions, public.ride_quota_usage, public.coupons to authenticated;
grant select, insert on public.coupon_redemptions to authenticated;
grant select on public.audit_log to authenticated;

-- `anon` não recebe nada em nenhuma tabela. Login e signup passam por auth.*.

-- ----------------------------------------------------------------------------
-- profiles
-- ----------------------------------------------------------------------------
create policy "profiles_select_own" on public.profiles
  for select to authenticated
  using ((select auth.uid()) = id and deleted_at is null);

create policy "profiles_update_own" on public.profiles
  for update to authenticated
  using ((select auth.uid()) = id and deleted_at is null)
  with check ((select auth.uid()) = id);

-- INSERT não tem policy de propósito: o profile nasce pelo trigger
-- on_auth_user_created (0004). DELETE também não: exclusão passa pela
-- Edge Function delete-account, que faz soft delete + purga agendada.

-- ----------------------------------------------------------------------------
-- Macro para as tabelas cujo dono é simplesmente user_id
-- ----------------------------------------------------------------------------
do $$
declare
  t text;
begin
  foreach t in array array[
    'vehicles', 'maintenance_items', 'fixed_costs', 'work_profiles',
    'work_sessions', 'ride_evaluations', 'expenses', 'device_push_tokens'
  ]
  loop
    execute format($f$
      create policy "%1$s_select_own" on public.%1$s
        for select to authenticated
        using ((select auth.uid()) = user_id);

      create policy "%1$s_insert_own" on public.%1$s
        for insert to authenticated
        with check ((select auth.uid()) = user_id);

      create policy "%1$s_update_own" on public.%1$s
        for update to authenticated
        using ((select auth.uid()) = user_id)
        with check ((select auth.uid()) = user_id);

      create policy "%1$s_delete_own" on public.%1$s
        for delete to authenticated
        using ((select auth.uid()) = user_id);
    $f$, t);
  end loop;
end $$;

-- ----------------------------------------------------------------------------
-- subscriptions — leitura própria; escrita é privilégio de service_role
-- ----------------------------------------------------------------------------
create policy "subscriptions_select_own" on public.subscriptions
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- Sem policy de insert/update/delete para `authenticated`:
-- é exatamente isso que impede o usuário de se tornar premium sozinho.
-- service_role ignora RLS por definição e é usado só dentro das Edge Functions.

-- ----------------------------------------------------------------------------
-- ride_quota_usage — o usuário lê o próprio consumo; o incremento é via RPC
-- ----------------------------------------------------------------------------
create policy "quota_select_own" on public.ride_quota_usage
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- coupons — só cupom válido é visível, e nunca a contagem de outros
-- ----------------------------------------------------------------------------
create policy "coupons_select_active" on public.coupons
  for select to authenticated
  using (
    is_active
    and valid_from <= now()
    and (valid_until is null or valid_until > now())
    and (max_redemptions is null or redeemed_count < max_redemptions)
  );

create policy "redemptions_select_own" on public.coupon_redemptions
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "redemptions_insert_own" on public.coupon_redemptions
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- audit_log — o titular enxerga o próprio rastro (transparência LGPD)
-- ----------------------------------------------------------------------------
create policy "audit_select_own" on public.audit_log
  for select to authenticated
  using ((select auth.uid()) = user_id);

-- ----------------------------------------------------------------------------
-- webhook_events — nenhuma policy. Tabela cega para o cliente.
-- ----------------------------------------------------------------------------

-- ----------------------------------------------------------------------------
-- Storage: buckets privados, um "diretório" por usuário
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('avatars',  'avatars',  false, 2097152,  array['image/jpeg','image/png','image/webp']),
  ('receipts', 'receipts', false, 5242880,  array['image/jpeg','image/png','image/webp','application/pdf'])
on conflict (id) do nothing;

-- Convenção de caminho: <uid>/<arquivo>. A policy compara o primeiro segmento.
create policy "storage_read_own" on storage.objects
  for select to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_insert_own" on storage.objects
  for insert to authenticated
  with check (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_update_own" on storage.objects
  for update to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy "storage_delete_own" on storage.objects
  for delete to authenticated
  using (
    bucket_id in ('avatars', 'receipts')
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

-- ----------------------------------------------------------------------------
-- Verificação de conformidade — roda no CI, falha o build se houver furo
-- ----------------------------------------------------------------------------
-- select c.relname
--   from pg_class c
--   join pg_namespace n on n.oid = c.relnamespace
--  where n.nspname = 'public'
--    and c.relkind = 'r'
--    and not c.relrowsecurity;
-- Resultado esperado: 0 linhas.
