import 'package:flutter/material.dart';

class DeviceMonitorScreen extends StatelessWidget {
  const DeviceMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Giám sát thiết bị', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Theo dõi telemetry, lịch sử di chuyển và thông số cảm biến.'),
        const SizedBox(height: 16),
        _TelemetryCard(
          title: 'Pin',
          value: '72%',
          icon: Icons.battery_full,
          color: Colors.green,
        ),
        _TelemetryCard(
          title: 'GPS',
          value: 'Tốt',
          icon: Icons.location_on,
          color: Colors.green,
        ),
        _TelemetryCard(
          title: 'Mạng',
          value: '4G',
          icon: Icons.signal_cellular_alt,
          color: Colors.green,
        ),
      ],
    );
  }
}

class _TelemetryCard extends StatelessWidget {
  const _TelemetryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}