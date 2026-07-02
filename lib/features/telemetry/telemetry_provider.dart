import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/features/telemetry/device_telemetry_model.dart';

// Assuming we have a paired device ID in context, for now we will hardcode or require it.
// In a real app, this would come from a user session provider.
final currentPairedDeviceIdProvider = StateProvider<String?>((ref) => null);

final telemetryStreamProvider = StreamProvider<DeviceTelemetry?>((ref) {
  final pairedDeviceId = ref.watch(currentPairedDeviceIdProvider);
  if (pairedDeviceId == null) {
    return Stream.value(null);
  }

  return SupabaseService().client
      .from('device_telemetry')
      .stream(primaryKey: ['tmod_device_id'])
      .eq('paired_device_id', pairedDeviceId)
      .map((data) {
        if (data.isNotEmpty) {
          // Assuming we only care about the latest telemetry for this paired device
          return DeviceTelemetry.fromJson(data.first);
        }
        return null;
      });
});
