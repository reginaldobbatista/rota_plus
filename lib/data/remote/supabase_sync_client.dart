import 'package:rota_plus/core/sync/sync_engine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Implementação de [RemoteSyncClient] sobre o Supabase.
///
/// Usa as RPCs `rpc_sync_rides` e `rpc_sync_expenses`, que inserem o lote
/// inteiro numa transação e resolvem a identidade do usuário no servidor — o
/// app nunca envia `user_id`.
class SupabaseSyncClient implements RemoteSyncClient {
  /// Cria o cliente.
  const SupabaseSyncClient(this._client);

  /// Limite aceito pelas RPCs. Lotes maiores são fatiados.
  static const int maxBatch = 200;

  final SupabaseClient _client;

  @override
  Future<void> pushRides(List<Map<String, Object?>> payload) =>
      _pushInSlices('rpc_sync_rides', 'p_rides', payload);

  @override
  Future<void> pushExpenses(List<Map<String, Object?>> payload) =>
      _pushInSlices('rpc_sync_expenses', 'p_expenses', payload);

  @override
  Future<void> pushWorkSessions(List<Map<String, Object?>> payload) =>
      _pushInSlices('rpc_sync_work_sessions', 'p_sessions', payload);

  Future<void> _pushInSlices(
    String function,
    String param,
    List<Map<String, Object?>> payload,
  ) async {
    for (var start = 0; start < payload.length; start += maxBatch) {
      final end = (start + maxBatch).clamp(0, payload.length);
      await _client.rpc<void>(
        function,
        params: {param: payload.sublist(start, end)},
      );
    }
  }
}
