-- ============================================================================
-- Rota Plus · 0007 · Sincronização de despesas
-- ============================================================================
-- Simétrica a `rpc_sync_rides`, com uma diferença essencial: despesa muda
-- depois de criada, então a resolução de conflito é last-write-wins por
-- `updated_at`. Corrida é insert-only.
--
-- Por que RPC em vez de `upsert` direto na tabela: o cliente não precisa
-- conhecer nem enviar o `user_id`. A RLS rejeitaria um `user_id` alheio, mas
-- deixar o servidor resolver a identidade elimina a classe de erro inteira.
-- ============================================================================

create or replace function public.rpc_sync_expenses(p_expenses jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid     uuid := (select auth.uid());
  v_applied integer;
begin
  if v_uid is null then
    raise exception 'Não autenticado.' using errcode = '28000';
  end if;

  if jsonb_typeof(p_expenses) <> 'array' then
    raise exception 'p_expenses deve ser um array JSON.' using errcode = '22023';
  end if;

  if jsonb_array_length(p_expenses) > 200 then
    raise exception 'Lote máximo de 200 despesas.' using errcode = '22023';
  end if;

  with payload as (
    select * from jsonb_to_recordset(p_expenses) as r(
      client_id       uuid,
      category        text,
      amount          numeric,
      liters          numeric,
      odometer_km     numeric,
      description     text,
      occurred_at     timestamptz,
      updated_at      timestamptz,
      deleted_at      timestamptz,
      work_session_id uuid
    )
  )
  insert into public.expenses as e (
    user_id, client_id, category, amount, liters, odometer_km, description,
    occurred_at, updated_at, deleted_at, work_session_id
  )
  select
    v_uid,
    p.client_id,
    p.category::public.expense_category,
    p.amount,
    p.liters,
    p.odometer_km,
    left(p.description, 500),
    p.occurred_at,
    coalesce(p.updated_at, now()),
    p.deleted_at,
    p.work_session_id
  from payload p
  on conflict (user_id, client_id) do update
     set category        = excluded.category,
         amount          = excluded.amount,
         liters          = excluded.liters,
         odometer_km     = excluded.odometer_km,
         description     = excluded.description,
         occurred_at     = excluded.occurred_at,
         updated_at      = excluded.updated_at,
         deleted_at      = excluded.deleted_at,
         work_session_id = excluded.work_session_id
   -- Last-write-wins: uma retransmissão antiga não sobrescreve edição nova.
   where excluded.updated_at > e.updated_at;

  get diagnostics v_applied = row_count;

  return jsonb_build_object(
    'received', jsonb_array_length(p_expenses),
    'applied',  v_applied
  );
end;
$$;

grant execute on function public.rpc_sync_expenses(jsonb) to authenticated;

comment on function public.rpc_sync_expenses(jsonb) is
  'Sobe um lote de despesas do app. Idempotente por (user_id, client_id) e '
  'resolve conflito por updated_at. A exclusão chega como deleted_at '
  'preenchido, nunca como ausência da linha.';
