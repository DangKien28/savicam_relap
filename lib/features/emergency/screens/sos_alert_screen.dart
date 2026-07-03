import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SosAlertScreen extends StatelessWidget {
  const SosAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.saviDanger,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'CẢNH BÁO KHẨN CẤP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Tín hiệu SOS đã được kích hoạt. Ứng dụng sẽ ưu tiên theo dõi và thông báo ngay lập tức.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}