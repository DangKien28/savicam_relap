import 'package:flutter/material.dart';

class DeviceListView extends StatelessWidget {
  const DeviceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý thiết bị")),
      body: const Center(child: Text("Danh sách thiết bị đã ghép nối")),
    );
  }
}