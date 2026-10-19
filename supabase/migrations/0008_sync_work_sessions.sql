-- ============================================================================
-- Rota Plus · 0008 · Sincronização das sessões de trabalho
-- ============================================================================
-- Completa o trio de filas do outbox. Sem esta função, as sessões ficariam
-- enfileiradas para sempre no aparelho: o app as enfileira desde que o
-- registro de expediente existe, mas não havia para onde enviá-las.
--
-- Uma sessão muda depois de criada (abre sem fim, depois recebe o fim), então
-- a resolução é por upsert com last-write-wins implícito: o registro mais
-- recente sempre traz o `ended_at`.
-- ============================================================================

create or replace function public.rpc_sync_work_sessions(p_sessions jsonb)
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

  if jsonb_typeof(p_sessions) <> 'array' then
    raise exception 'p_sessions deve ser um array JSON.' using errcode = '22023';
  end if;

  if jsonb_array_length(p_sessions) > 200 then
    raise exception 'Lote máximo de 200 sessões.' using errcode = '22023';
  end if;

  with payload as (
    select * from jsonb_to_recordset(p_sessions) as r(
      client_id       uuid,
      work_profile_id uuid,
      started_at      timestamptz,
      ended_at        timestamptz
    )
  )
  insert into public.work_sessions as s (
    user_id, client_id, work_profile_id, started_at, ended_at
  )
  select v_uid, p.client_id, p.work_profile_id, p.started_at, p.ended_at
  from payload p
  on conflict (user_id, client_id) do update
     set work_profile_id = excluded.work_profile_id,
         started_at      = excluded.started_at,
         ended_at        = excluded.ended_at
   -- Só avança: um reenvio atrasado não pode reabrir uma sessão já encerrada.
   where s.ended_at is null or excluded.ended_at is not null;

  get diagnostics v_applied = row_count;

  return jsonb_build_object(
    'received', jsonb_array_length(p_sessions),
    'applied',  v_applied
  );
end;
$$;

grant execute on function public.rpc_sync_work_sessions(jsonb) to authenticated;

comment on function public.rpc_sync_work_sessions(jsonb) is
  'Sobe um lote de sessões de trabalho do app. Idempotente por '
  '(user_id, client_id). Sessão aberta sobe com ended_at nulo e é completada '
  'no envio seguinte.';
