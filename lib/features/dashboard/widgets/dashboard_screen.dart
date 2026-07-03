import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF2FF), Color(0xFFF7FAFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bảng điều khiển',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.saviBlueDark,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'SOS đang hoạt động',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.saviDanger,
                    ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Live tracking đang theo dõi vị trí thiết bị theo thời gian thực.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              _StatusCard(
                title: 'Trạng thái thiết bị',
                subtitle: 'T-Mod của Minh Anh',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'ONLINE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
                children: const [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _MetricTile(label: 'Pin', value: '72%', icon: Icons.battery_full, color: Colors.green),
                      _MetricTile(label: 'Mạng', value: '4G', icon: Icons.signal_cellular_alt, color: Colors.green),
                      _MetricTile(label: 'GPS', value: 'Tốt', icon: Icons.location_on, color: Colors.green),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _StatusCard(
                title: 'Bản đồ theo dõi',
                subtitle: 'Khung map sẽ được gắn với flutter_map',
                children: [
                  SizedBox(height: 140),
                  Center(
                    child: Text(
                      'Map preview',
                      style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.saviDanger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent.shade100, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.3),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                      Text('Giữ 3 giây', style: TextStyle(color: Colors.white, fontSize: 9)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.subtitle,
    required this.children,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final trailingWidgets = trailing == null ? const <Widget>[] : <Widget>[trailing!];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                ...trailingWidgets,
              ],
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 6),
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}