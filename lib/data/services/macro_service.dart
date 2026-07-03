import '../models/user_macro.dart';
import 'supabase_service.dart';

class MacroService {
  MacroService({SupabaseService? supabaseService}) : _supabaseService = supabaseService ?? SupabaseService();

  final SupabaseService _supabaseService;

  Future<List<UserMacro>> fetchMacros(String pairedDeviceId) async {
    final response = await _supabaseService.client
        .from('user_macros')
        .select()
        .eq('paired_device_id', pairedDeviceId)
        .order('created_at');

    return (response as List<dynamic>)
        .map((item) => UserMacro.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> createMacro({
    required String pairedDeviceId,
    required String name,
    required double latitude,
    required double longitude,
    String? notes,
  }) {
    return _supabaseService.client.from('user_macros').insert({
      'paired_device_id': pairedDeviceId,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    });
  }
}