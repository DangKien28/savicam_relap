import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/features/telemetry/telemetry_provider.dart';

class TelemetryScreen extends ConsumerWidget {
  const TelemetryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(telemetryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giám sát Viễn trắc'),
      ),
      body: telemetryAsync.when(
        data: (telemetry) {
          if (telemetry == null) {
            return const Center(child: Text('Đang chờ kết nối dữ liệu từ thiết bị...'));
          }

          final isLowBattery = telemetry.batteryLevel < 15;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isLowBattery)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'CẢNH BÁO: Pin thiết bị T-Mod đang ở mức cực thấp (<15%)!',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMetricCard(
                        'Mức Pin',
                        '${telemetry.batteryLevel}%',
                        Icons.battery_charging_full,
                        isLowBattery ? Colors.red : Colors.green,
                      ),
                      _buildMetricCard(
                        'Kết nối mạng',
                        telemetry.networkStatus,
                        Icons.network_check,
                        Colors.blue,
                      ),
                      _buildMetricCard(
                        'Headless Mode',
                        telemetry.isHeadlessMode ? 'Đang Bật' : 'Đang Tắt',
                        Icons.visibility_off,
                        telemetry.isHeadlessMode ? Colors.orange : Colors.grey,
                      ),
                      _buildMetricCard(
                        'Cập nhật lần cuối',
                        _formatTime(telemetry.lastPingAt),
                        Icons.access_time,
                        Colors.purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}:${local.second.toString().padLeft(2, '0')}';
  }
}
