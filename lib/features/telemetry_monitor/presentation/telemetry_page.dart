import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/app_models.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/formatters.dart';

class TelemetryPage extends ConsumerWidget {
  const TelemetryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RelapAppState appState = ref.watch(relapAppControllerProvider);
    final DeviceTelemetry telemetry = appState.telemetry;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Giám sát thiết bị', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Theo dõi telemetry realtime của T-Mod và giữ lại trạng thái gần nhất khi mạng chập chờn.',
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width =
                constraints.maxWidth >= 720 ? 220 : constraints.maxWidth;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: <Widget>[
                _TelemetryTile(
                  width: width,
                  label: 'Pin',
                  value: '${telemetry.batteryLevel}%',
                  icon: Icons.battery_full,
                  tone: _batteryColor(telemetry.batteryLevel),
                ),
                _TelemetryTile(
                  width: width,
                  label: 'Mạng',
                  value: networkStatusLabel(telemetry.networkStatus),
                  icon: Icons.wifi,
                  tone: telemetry.networkStatus == NetworkStatus.online
                      ? Colors.teal
                      : Theme.of(context).colorScheme.error,
                ),
                _TelemetryTile(
                  width: width,
                  label: 'Headless mode',
                  value: telemetry.isHeadlessMode ? 'Đang bật' : 'Đang tắt',
                  icon: Icons.visibility_off,
                  tone: Theme.of(context).colorScheme.primary,
                ),
                _TelemetryTile(
                  width: width,
                  label: 'Cập nhật',
                  value: timeAgo(telemetry.lastPingAt),
                  icon: Icons.schedule,
                  tone: Colors.blueGrey,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Vị trí hiện tại', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(formatLatLng(telemetry.currentLat, telemetry.currentLng)),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: telemetry.batteryLevel / 100,
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _TelemetryControls(telemetry: telemetry),
      ],
    );
  }
}

class _TelemetryControls extends ConsumerStatefulWidget {
  const _TelemetryControls({required this.telemetry});

  final DeviceTelemetry telemetry;

  @override
  ConsumerState<_TelemetryControls> createState() => _TelemetryControlsState();
}

class _TelemetryControlsState extends ConsumerState<_TelemetryControls> {
  late double _batteryLevel;
  late NetworkStatus _networkStatus;
  late bool _isHeadlessMode;

  @override
  void initState() {
    super.initState();
    _batteryLevel = widget.telemetry.batteryLevel.toDouble();
    _networkStatus = widget.telemetry.networkStatus;
    _isHeadlessMode = widget.telemetry.isHeadlessMode;
  }

  @override
  void didUpdateWidget(covariant _TelemetryControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.telemetry != widget.telemetry) {
      _batteryLevel = widget.telemetry.batteryLevel.toDouble();
      _networkStatus = widget.telemetry.networkStatus;
      _isHeadlessMode = widget.telemetry.isHeadlessMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Giả lập realtime', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                const Icon(Icons.battery_5_bar),
                Expanded(
                  child: Slider(
                    value: _batteryLevel,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_batteryLevel.round()}%',
                    onChanged: (double value) =>
                        setState(() => _batteryLevel = value),
                  ),
                ),
                SizedBox(
                  width: 48,
                  child: Text('${_batteryLevel.round()}%'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<NetworkStatus>(
              segments: const <ButtonSegment<NetworkStatus>>[
                ButtonSegment<NetworkStatus>(
                  value: NetworkStatus.online,
                  icon: Icon(Icons.wifi),
                  label: Text('Online'),
                ),
                ButtonSegment<NetworkStatus>(
                  value: NetworkStatus.weak,
                  icon: Icon(Icons.network_wifi_2_bar),
                  label: Text('Yếu'),
                ),
                ButtonSegment<NetworkStatus>(
                  value: NetworkStatus.offline,
                  icon: Icon(Icons.wifi_off),
                  label: Text('Offline'),
                ),
              ],
              selected: <NetworkStatus>{_networkStatus},
              onSelectionChanged: (Set<NetworkStatus> value) =>
                  setState(() => _networkStatus = value.first),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Headless mode'),
              value: _isHeadlessMode,
              onChanged: (bool value) => setState(() => _isHeadlessMode = value),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () {
                ref.read(relapAppControllerProvider.notifier).updateTelemetry(
                      batteryLevel: _batteryLevel.round(),
                      networkStatus: _networkStatus,
                      isHeadlessMode: _isHeadlessMode,
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Cập nhật telemetry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TelemetryTile extends StatelessWidget {
  const _TelemetryTile({
    required this.width,
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: tone),
              const SizedBox(height: 12),
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
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
