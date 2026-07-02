import 'package:flutter/material.dart';
import 'package:savicam_relap/ui/screens/device_monitoring_screen.dart';
import 'dashboard_view.dart';
import 'dictionary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Danh sách các màn hình tương ứng với các tab
  final List<Widget> _pages = [
    const DashboardView(),
    const DictionaryScreen(),
    const DeviceMonitoringScreen(),      // Sẽ làm sau
    const Center(child: Text('Màn hình Cài đặt')),               // Sẽ làm sau
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('SaViCam Relap', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              // TODO: Mở màn hình Lịch sử cảnh báo
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade800,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Bản đồ'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Từ điển'),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Thiết bị'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}
