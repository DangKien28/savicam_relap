import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../home/presentation/home_shell.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RelapAppState appState = ref.watch(relapAppControllerProvider);
    final EmergencyAlert? activeAlert = appState.activeAlert;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          title: const Text('SaViCam Relap'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                activeAlert == null
                    ? Icons.notifications_none
                    : Icons.notification_important,
              ),
              color: activeAlert == null ? null : colorScheme.error,
              onPressed: () => ref.read(homeIndexProvider.notifier).state = 1,
              tooltip: 'Cảnh báo SOS',
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _StatusPanel(activeAlert: activeAlert),
              const SizedBox(height: 12),
              _LiveMapPanel(telemetry: appState.telemetry),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final int crossAxisCount = constraints.maxWidth >= 900 ? 4 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: constraints.maxWidth >= 900 ? 1.45 : 1.25,
                    children: <Widget>[
                      _MetricCard(
                        label: 'Pin T-Mod',
                        value: '${appState.telemetry.batteryLevel}%',
                        icon: Icons.battery_charging_full,
                        tone: _batteryColor(appState.telemetry.batteryLevel),
                      ),
                      _MetricCard(
                        label: 'Mạng',
                        value: networkStatusLabel(appState.telemetry.networkStatus),
                        icon: Icons.wifi,
                        tone: appState.telemetry.networkStatus == NetworkStatus.online
                            ? Colors.teal
                            : colorScheme.error,
                      ),
                      _MetricCard(
                        label: 'Headless',
                        value: appState.telemetry.isHeadlessMode ? 'Bật' : 'Tắt',
                        icon: Icons.visibility_off,
                        tone: colorScheme.primary,
                      ),
                      _MetricCard(
                        label: 'Macro chờ',
                        value: '${appState.pendingMacroCount}',
                        icon: Icons.cloud_upload_outlined,
                        tone: Colors.indigo,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _QuickActions(appState: appState),
            ]),
          ),
        ),
      ],
    );
  }
}

class _StatusPanel extends ConsumerWidget {
  const _StatusPanel({required this.activeAlert});

  final EmergencyAlert? activeAlert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool hasAlert = activeAlert != null;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: hasAlert ? colorScheme.error : const Color(0xFF0F4C81),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  hasAlert ? Icons.emergency : Icons.shield,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasAlert ? 'SOS đang hoạt động' : 'Trạm giám sát sẵn sàng',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasAlert
                  ? activeAlert!.message
                  : 'Theo dõi vị trí, telemetry và từ điển vị trí của thiết bị T-Mod theo thời gian thực.',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () => ref.read(homeIndexProvider.notifier).state =
                  hasAlert ? 1 : 2,
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: hasAlert ? colorScheme.error : colorScheme.primary,
              ),
              icon: Icon(hasAlert ? Icons.priority_high : Icons.monitor_heart),
              label: Text(hasAlert ? 'Mở cảnh báo' : 'Xem telemetry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveMapPanel extends StatelessWidget {
  const _LiveMapPanel({required this.telemetry});

  final DeviceTelemetry telemetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 220,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _MapGridPainter(Theme.of(context).colorScheme),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.location_on, color: Color(0xFFD7263D)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Live tracking: ${formatLatLng(telemetry.currentLat, telemetry.currentLng)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Center(
              child: Icon(Icons.my_location, size: 42, color: Color(0xFFD7263D)),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Chip(
                avatar: const Icon(Icons.schedule, size: 18),
                label: Text(timeAgo(telemetry.lastPingAt)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends ConsumerWidget {
  const _QuickActions({required this.appState});

  final RelapAppState appState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            FilledButton.icon(
              onPressed: () => ref.read(homeIndexProvider.notifier).state = 3,
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Thêm vị trí'),
            ),
            OutlinedButton.icon(
              onPressed: appState.isSyncing
                  ? null
                  : () => ref.read(relapAppControllerProvider.notifier).syncMacros(),
              icon: appState.isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              label: Text(appState.isSyncing ? 'Đang đồng bộ' : 'Đồng bộ macro'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  ref.read(relapAppControllerProvider.notifier).createDemoAlert(),
              icon: const Icon(Icons.warning_amber),
              label: const Text('Giả lập SOS'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: tone),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  const _MapGridPainter(this.colorScheme);

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint background = Paint()..color = const Color(0xFFE9F3F3);
    canvas.drawRect(Offset.zero & size, background);

    final Paint minorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;
    final Paint majorRoad = Paint()
      ..color = colorScheme.primary.withValues(alpha: 0.25)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    for (double y = 32; y < size.height; y += 46) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 16), minorRoad);
    }
    for (double x = 28; x < size.width; x += 58) {
      canvas.drawLine(Offset(x, 0), Offset(x - 20, size.height), minorRoad);
    }
    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width, size.height * 0.32),
      majorRoad,
    );
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) => false;
}

Color _batteryColor(int value) {
  if (value >= 50) {
    return Colors.teal;
  }
  if (value >= 25) {
    return Colors.orange;
  }
  return const Color(0xFFD7263D);
}
