import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/features/alerts/emergency_alert_model.dart';
import 'package:savicam_relap/features/telemetry/telemetry_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final alertStreamProvider = StreamProvider<EmergencyAlert?>((ref) {
  final pairedDeviceId = ref.watch(currentPairedDeviceIdProvider);
  if (pairedDeviceId == null) {
    return Stream.value(null);
  }

  // Lắng nghe realtime từ bảng emergency_alerts
  return Supabase.instance.client
      .from('emergency_alerts')
      .stream(primaryKey: ['id'])
      .eq('paired_device_id', pairedDeviceId)
      .order('created_at', ascending: false) // Lấy alert mới nhất
      .map((data) {
        if (data.isNotEmpty) {
          final alert = EmergencyAlert.fromJson(data.first);
          // Chỉ trả về nếu status chưa được resolve
          if (alert.status != 'resolved') {
            return alert;
          }
        }
        return null;
      });
});
