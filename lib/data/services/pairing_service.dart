import 'supabase_service.dart';

class PairingService {
  PairingService({SupabaseService? supabaseService}) : _supabaseService = supabaseService ?? SupabaseService();

  final SupabaseService _supabaseService;

  Future<Map<String, dynamic>?> findPairingByCode(String code) {
    return _supabaseService.client.from('device_pairs').select().eq('pairing_code', code).maybeSingle();
  }

  Future<bool> hasPairedDevice(String userId) async {
    final response = await _supabaseService.client
        .from('device_pairs')
        .select('id')
        .eq('relap_user_id', userId)
        .eq('status', 'paired')
        .maybeSingle();

    return response != null;
  }

  Future<void> pairDevice({required String code, required String userId}) async {
    final pairRecord = await findPairingByCode(code);

    if (pairRecord == null) {
      throw StateError('Mã kết nối không hợp lệ hoặc đã hết hạn.');
    }

    if (pairRecord['status'] == 'paired') {
      throw StateError('Thiết bị T-Mod này đã được ghép nối với một tài khoản khác.');
    }

    await _supabaseService.client.from('device_pairs').update({
      'relap_user_id': userId,
      'status': 'paired',
    }).eq('id', pairRecord['id']);
  }
}