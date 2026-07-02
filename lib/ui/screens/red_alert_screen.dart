import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/features/alerts/emergency_alert_model.dart';

class RedAlertScreen extends ConsumerWidget {
  final EmergencyAlert alert;

  const RedAlertScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF0000), // Bắt buộc màu đỏ theo spec
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'CẢNH BÁO KHẨN CẤP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Thông điệp: ${alert.message}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Vị trí: ${alert.latitude}, ${alert.longitude}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Thời gian: ${alert.createdAt.toLocal().toString().split('.')[0]}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement VoIP/WebRTC audio connection
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang kết nối đàm thoại ưu tiên...')),
                  );
                },
                icon: const Icon(Icons.record_voice_over, size: 28),
                label: const Text(
                  'KẾT NỐI ĐÀM THOẠI ƯU TIÊN',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  // Đổi status thành 'resolved' để tắt báo động
                  await SupabaseService().client
                      .from('emergency_alerts')
                      .update({'status': 'resolved'})
                      .eq('id', alert.id);
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Tắt báo động (Đã xử lý)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
