import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/formatters.dart';

class SOSAlertPage extends ConsumerWidget {
  const SOSAlertPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RelapAppState appState = ref.watch(relapAppControllerProvider);
    final EmergencyAlert? alert = appState.activeAlert;

    if (alert == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('SOS Red Alert')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.verified_user, size: 64, color: Colors.teal),
                const SizedBox(height: 16),
                Text(
                  'Không có cảnh báo khẩn cấp',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Trạm vẫn đang lắng nghe SOS, FCM và Supabase Realtime.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () =>
                      ref.read(relapAppControllerProvider.notifier).createDemoAlert(),
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('Giả lập cảnh báo'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD7263D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Icon(Icons.emergency, color: Colors.white, size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'SOS RED ALERT',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                alert.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              _IncidentMap(alert: alert),
              const SizedBox(height: 12),
              _AlertDetailTile(
                icon: Icons.location_on,
                title: 'Tọa độ GPS',
                value: formatLatLng(alert.latitude, alert.longitude),
              ),
              const SizedBox(height: 10),
              _AlertDetailTile(
                icon: Icons.schedule,
                title: 'Thời điểm nhận',
                value: timeAgo(alert.createdAt),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showCallSheet(context),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD7263D),
                  minimumSize: const Size.fromHeight(58),
                ),
                icon: const Icon(Icons.call),
                label: const Text('Kết nối đàm thoại ưu tiên'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(relapAppControllerProvider.notifier).resolveAlert(alert.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã cập nhật SOS thành resolved')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.5),
                  minimumSize: const Size.fromHeight(54),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Đã xử lý'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Kênh đàm thoại ưu tiên',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Trong bản hoàn chỉnh, nút này gọi VoIP Service hoặc fallback viễn thông đến thiết bị T-Mod.',
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.phone_in_talk),
                label: const Text('Bắt đầu cuộc gọi'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AlertDetailTile extends StatelessWidget {
  const _AlertDetailTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFD7263D)),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

class _IncidentMap extends StatelessWidget {
  const _IncidentMap({required this.alert});

  final EmergencyAlert alert;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 190,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _IncidentMapPainter()),
            ),
            Center(
              child: Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFD7263D).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.report_problem,
                  color: Color(0xFFD7263D),
                  size: 44,
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: Text(
                formatLatLng(alert.latitude, alert.longitude),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncidentMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFFF1F2),
    );
    final Paint road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, 24), road);
    canvas.drawLine(
      Offset(20, size.height),
      Offset(size.width * 0.72, 0),
      road,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.75),
      Offset(size.width, size.height * 0.62),
      road,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
