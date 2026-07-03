import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          // Mục thông tin tài khoản
          const ListTile(
            leading: Icon(Icons.person),
            title: Text("Tài khoản người thân"),
            subtitle: Text("Email: user@example.com"),
          ),
          const Divider(),
          
          // Cài đặt thông báo
          SwitchListTile(
            title: const Text("Thông báo khẩn cấp (SOS)"),
            subtitle: const Text("Nhận thông báo ngay khi có sự cố"),
            value: true,
            onChanged: (val) {},
          ),
          
          // Quản lý quyền thiết bị
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Quản lý quyền riêng tư"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Điều hướng đến trang quản lý permission
            },
          ),
          
          const Divider(),
          
          // Đăng xuất
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await SupabaseService.instance.client.auth.signOut();
              // Điều hướng về màn hình Login
            },
          ),
        ],
      ),
    );
  }
}