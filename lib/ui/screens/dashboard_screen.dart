import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:savicam_relap/core/env/env_config.dart';
import 'package:savicam_relap/features/telemetry/telemetry_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(telemetryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SaViCam Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings/macros
            },
          )
        ],
      ),
      body: telemetryAsync.when(
        data: (telemetry) {
          if (telemetry == null) {
            return const Center(child: Text('Chưa có dữ liệu từ thiết bị.'));
          }

          final currentPos = LatLng(telemetry.currentLat, telemetry.currentLng);

          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: currentPos,
                  initialZoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: EnvConfig.osmTileUrl,
                    userAgentPackageName: 'com.example.savicam_relap',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentPos,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusItem(
                          Icons.battery_full,
                          '${telemetry.batteryLevel}%',
                          telemetry.batteryLevel < 15 ? Colors.red : Colors.green,
                        ),
                        _buildStatusItem(
                          Icons.network_cell,
                          telemetry.networkStatus,
                          Colors.blue,
                        ),
                        _buildStatusItem(
                          Icons.visibility_off,
                          telemetry.isHeadlessMode ? 'ON' : 'OFF',
                          telemetry.isHeadlessMode ? Colors.orange : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
