import 'package:flutter/material.dart';
import 'package:savicam_relap/ui/screens/dashboard_screen.dart';
import 'package:savicam_relap/ui/screens/telemetry_screen.dart';
import 'package:savicam_relap/ui/screens/user_macros_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TelemetryScreen(),
    UserMacrosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Viễn trắc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Từ điển',
          ),
        ],
      ),
    );
  }
}
