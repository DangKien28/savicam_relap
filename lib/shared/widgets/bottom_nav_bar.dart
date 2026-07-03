import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.saviBlue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          activeIcon: Icon(Icons.map),
          label: 'Bản đồ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book),
          label: 'Từ điển',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.memory_outlined),
          activeIcon: Icon(Icons.memory),
          label: 'Thiết bị',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          activeIcon: Icon(Icons.settings),
          label: 'Cài đặt',
        ),
      ],
    );
  }
}