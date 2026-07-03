import 'package:flutter/material.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Từ điển vị trí', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Quản lý các macro vị trí thường dùng.'),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Nhà'),
            subtitle: const Text('Hà Nội'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.place_outlined),
            title: const Text('Bệnh viện'),
            subtitle: const Text('Tọa độ được lưu từ bản đồ'),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
            ),
          ),
        ),
      ],
    );
  }
}