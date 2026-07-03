import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Cài đặt', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Nguyễn Văn An'),
            subtitle: Text('Master'),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.group_outlined),
                title: const Text('Quản lý thành viên'),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Thông báo'),
                onTap: () {},
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: const Text('Âm thanh & Rung'),
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}