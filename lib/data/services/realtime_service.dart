import 'supabase_service.dart';

class RealtimeService {
  RealtimeService({SupabaseService? supabaseService}) : _supabaseService = supabaseService ?? SupabaseService();

  final SupabaseService _supabaseService;

  Stream<List<Map<String, dynamic>>> watchTelemetry(String pairedDeviceId) {
    return _supabaseService.client
        .from('device_telemetry')
        .stream(primaryKey: ['id'])
        .eq('paired_device_id', pairedDeviceId);
  }

  Stream<List<Map<String, dynamic>>> watchEmergencyAlerts(String pairedDeviceId) {
    return _supabaseService.client
        .from('emergency_alerts')
        .stream(primaryKey: ['id'])
        .eq('paired_device_id', pairedDeviceId);
  }

  Future<void> resolveEmergencyAlert(String alertId) {
    return _supabaseService.client.from('emergency_alerts').update({'status': 'resolved'}).eq('id', alertId);
  }
}