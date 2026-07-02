import 'package:flutter/material.dart';

class DeviceMonitoringScreen extends StatelessWidget {
  const DeviceMonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lưới thông số thiết bị
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            children: [
              _buildStatCard('Pin thiết bị', '72%', Icons.battery_charging_full, Colors.green, 'Còn lại khoảng 6 giờ'),
              _buildStatCard('Nhiệt độ', '35°c', Icons.thermostat, Colors.orange, 'Bình thường'),
              _buildStatCard('Mạng di động', 'Mạnh', Icons.signal_cellular_alt, Colors.green, 'Độ trễ: 45 ms'),
              _buildStatCard('Camera', 'Online', Icons.camera_alt, Colors.blue.shade800, 'Đang hoạt động'),
            ],
          ),
          const SizedBox(height: 24),
          
          // Tiêu đề Lịch sử di chuyển
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Lịch sử di chuyển hôm nay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả', style: TextStyle(fontSize: 12))),
            ],
          ),
          
          // Danh sách lịch sử (Timeline)
          _buildHistoryItem('09:41', '21 Trần Duy Hưng, Trung Hòa,\nCầu Giấy, Hà Nội'),
          _buildHistoryItem('09:12', 'Phố Duy Tân, Dịch Vọng Hậu,\nCầu Giấy, Hà Nội'),
          _buildHistoryItem('08:47', 'Công viên Cầu Giấy, Dịch Vọng,\nCầu Giấy, Hà Nội'),
          _buildHistoryItem('08:15', 'Tòa nhà Keangnam, Mễ Trì,\nNam Từ Liêm, Hà Nội'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String time, String address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: Colors.blue.shade800, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(address, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
