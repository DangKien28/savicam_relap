import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/providers/app_state_provider.dart';
import '../../../core/utils/formatters.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RelapAppState appState = ref.watch(relapAppControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Text('Cài đặt trạm', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        const Text(
          'Các điểm tích hợp cloud, thông báo và cuộc gọi ưu tiên cho hệ sinh thái SaViCam T-Mod.',
        ),
        const SizedBox(height: 16),
        _SettingsTile(
          icon: Icons.link,
          title: 'Thiết bị đã ghép nối',
          subtitle: 'paired_device_id: ${appState.telemetry.pairedDeviceId}',
          trailing: const Chip(label: Text('Active')),
        ),
        _SettingsTile(
          icon: Icons.cloud,
          title: 'Supabase Realtime',
          subtitle: AppConfig.hasSupabaseConfig
              ? 'Đã nhận SUPABASE_URL và SUPABASE_ANON_KEY'
              : 'Chưa cấu hình dart-define, app đang dùng dữ liệu demo',
          trailing: Chip(
            label: Text(AppConfig.hasSupabaseConfig ? 'Ready' : 'Demo'),
          ),
        ),
        _SettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Push Notifications',
          subtitle: 'FCM/APNs sẽ đánh thức SOS Red Alert khi cloud gửi sự kiện.',
          trailing: const Chip(label: Text('Planned')),
        ),
        _SettingsTile(
          icon: Icons.phone_in_talk,
          title: 'VoIP ưu tiên',
          subtitle: 'Kênh gọi trực tiếp đến T-Mod khi có emergency_alerts active.',
          trailing: const Chip(label: Text('Stub')),
        ),
        _SettingsTile(
          icon: Icons.sync,
          title: 'Đồng bộ UserMacros',
          subtitle: appState.lastSyncAt == null
              ? 'Chưa đồng bộ'
              : 'Lần cuối: ${timeAgo(appState.lastSyncAt!)}',
          trailing: Chip(label: Text('${appState.pendingMacroCount} pending')),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: trailing,
        ),
      ),
    );
  }
}
