import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // LỚP 1: Nền Bản đồ mô phỏng (Dùng ảnh hoặc màu nền)
        Container(
          color: Colors.blue.shade50,
          width: double.infinity,
          height: double.infinity,
          child: const Center(
            child: Icon(Icons.map, size: 100, color: Colors.black12),
          ),
        ),

        // LỚP 2: Card Thông tin T-Mod ở phía trên
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_walk, color: Colors.blue.shade800),
                        const SizedBox(width: 8),
                        const Text(
                          "T-Mod của Minh Anh",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Text(
                      "Online",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("ID thiết bị: SC-TMOD-7A23", style: TextStyle(color: Colors.grey, fontSize: 12)),
                const Divider(),
                // Các thông số nhanh
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStatus(Icons.battery_full, "72%", Colors.green),
                    _buildQuickStatus(Icons.signal_cellular_4_bar, "4G", Colors.green),
                    _buildQuickStatus(Icons.location_on, "Tốt", Colors.green),
                    _buildQuickStatus(Icons.camera_alt, "Online", Colors.black),
                  ],
                )
              ],
            ),
          ),
        ),

        // LỚP 3: Card Địa chỉ hiện tại ở góc dưới cùng
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Khung địa chỉ
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue.shade800, size: 30),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "21 Trần Duy Hưng, Trung Hòa",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            const Text(
                              "Cầu Giấy, Hà Nội, Việt Nam",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "21.02850° N, 105.80420° E",
                              style: TextStyle(color: Colors.blue.shade800, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nút cảnh báo đỏ nhỏ (Mô phỏng nút bấm nổi)
              FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.red,
                child: const Icon(Icons.sos, color: Colors.white),
              )
            ],
          ),
        ),
      ],
    );
  }

  // Hàm hỗ trợ vẽ icon trạng thái nhỏ
  Widget _buildQuickStatus(IconData icon, String text, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
