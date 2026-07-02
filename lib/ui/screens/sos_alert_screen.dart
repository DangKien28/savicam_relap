import 'package:flutter/material.dart';

class SOSAlertScreen extends StatelessWidget {
  const SOSAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(), // Ẩn nút back mặc định
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 80),
            const SizedBox(height: 16),
            const Text(
              'CẢNH BÁO\nKHẨN CẤP!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tín hiệu SOS từ T-Mod của Minh Anh',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // Card Thông tin vị trí
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Vị trí xảy ra sự cố', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            const Text('21 Trần Duy Hưng, Trung Hòa, Cầu Giấy, Hà Nội, Việt Nam'),
                            const SizedBox(height: 8),
                            Text('21.02850° N, 105.80420° E', style: TextStyle(color: Colors.blue.shade800, fontSize: 12)),
                            const Text('Độ chính xác: ± 8 m', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.access_time, color: Colors.grey, size: 16),
                          SizedBox(width: 8),
                          Text('Thời gian cảnh báo', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('09:41:18 AM', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('20/05/2026', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            
            // Nút Gọi đàm thoại ưu tiên
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lệnh gọi điện VoIP
                },
                icon: const Icon(Icons.phone_in_talk, color: Colors.white),
                label: const Text('KẾT NỐI ĐÀM THOẠI ƯU TIÊN', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Nút trượt để tắt cảnh báo (Mô phỏng bằng Button thường để đơn giản hóa giao diện tĩnh)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Đã xử lý / Tắt cảnh báo', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
