-- ============================================================================
-- Rota Plus · 0009 · Fecha o EXECUTE das funções internas
-- ============================================================================
-- Correção de uma falha real, apontada pelo advisor do Supabase na primeira
-- execução das migrations.
--
-- No Postgres, `CREATE FUNCTION` concede `EXECUTE` a `PUBLIC` por padrão. Como
-- o PostgREST expõe o schema `public`, **toda** função virava um endpoint:
-- `POST /rest/v1/rpc/<nome>`. As migrations anteriores concederam EXECUTE
-- explicitamente às RPCs desejadas, mas nunca revogaram o padrão das demais.
--
-- O resultado era grave. Estas duas eram chamáveis sem autenticação:
--
--   fn_purge_deleted_accounts()   -- apaga contas de auth.users
--   fn_prune_free_tier_history()  -- apaga o histórico de corridas do Free
--
-- Ambas são `security definer`, ou seja, rodariam com privilégio do dono. Um
-- `curl` anônimo com a chave publicável — que vai dentro do APK — bastaria
-- para destruir dados de todos os motoristas do plano gratuito.
--
-- A correção segue o mesmo princípio do `revoke all on schema public` da
-- 0001: negar por padrão e reconceder só o necessário.
-- ============================================================================

-- ---------------------------------------------------------------- revogação
do $$
declare
  fn record;
begin
  for fn in
    select p.oid::regprocedure as signature
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'public'
       and p.prokind = 'f'
  loop
    execute format(
      'revoke all on function %s from public, anon, authenticated',
      fn.signature
    );
  end loop;
end $$;

-- Funções criadas daqui para a frente também nascem fechadas.
alter default privileges in schema public
  revoke execute on functions from public, anon, authenticated;

-- ------------------------------------------------------------- reconcessão
-- Só o que o app precisa chamar. Cada linha aqui é uma decisão consciente de
-- expor um endpoint.

-- Sincronização do outbox. Resolvem a identidade por `auth.uid()` e recusam
-- chamada sem sessão.
grant execute on function public.rpc_sync_rides(jsonb) to authenticated;
grant execute on function public.rpc_sync_expenses(jsonb) to authenticated;
grant execute on function public.rpc_sync_work_sessions(jsonb) to authenticated;

-- Quota do plano Free. Precisa ser `security definer` para escrever na tabela
-- de contagem, que o usuário só pode ler.
grant execute on function public.rpc_consume_ride_quota() to authenticated;

-- Exclusão de conta (LGPD art. 18). Age apenas sobre o próprio usuário.
grant execute on function public.rpc_request_account_deletion() to authenticated;

-- Cálculo de custo por km. `security invoker` e sem efeito colateral.
grant execute on function public.fn_calculate_cost_per_km(uuid)
  to authenticated;

-- ---------------------------------------------------------------------------
-- O que deliberadamente NÃO é reconcedido:
--
--   fn_purge_deleted_accounts, fn_prune_free_tier_history,
--   fn_ensure_next_ride_partition  -- rodam por pg_cron, como superusuário
--   fn_handle_new_user, fn_touch_updated_at,
--   fn_enforce_work_profile_limit,
--   fn_invalidate_cost_cache_*     -- são gatilhos; chamada direta não faz
--                                     sentido e burlaria a regra que impõem
--   fn_is_premium                  -- aceita p_user_id e revelaria o status
--                                     de assinatura de qualquer usuário
--
-- O app lê o próprio entitlement pela tabela `subscriptions`, protegida por
-- RLS. Não precisa desta função.
-- ---------------------------------------------------------------------------

comment on function public.rpc_sync_rides(jsonb) is
  'Sobe um lote de corridas avaliadas. Único caminho de escrita em '
  'ride_evaluations a partir do app.';
