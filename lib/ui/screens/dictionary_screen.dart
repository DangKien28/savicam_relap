import 'package:flutter/material.dart';
import 'package:savicam_relap/ui/screens/add_location_screen.dart';

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Thanh tìm kiếm và mô tả
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Quản lý các địa điểm và từ khóa để AI Agent trên T-Mod nhận diện và điều hướng chính xác.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm địa điểm...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ],
          ),
        ),
        
        // Danh sách các địa điểm
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildLocationItem(Icons.home, Colors.green, "Nhà", "Nhà con trai", "21 Trần Duy Hưng, Trung Hòa, Cầu Giấy, Hà Nội"),
              _buildLocationItem(Icons.local_hospital, Colors.red, "Bệnh viện", "Bệnh viện E", "89 Trần Cung, Nghĩa Tân, Cầu Giấy, Hà Nội"),
              _buildLocationItem(Icons.business, Colors.blue, "Công ty", "Công ty ABC", "Tòa nhà Keangnam, Mễ Trì, Nam Từ Liêm, Hà Nội"),
              _buildLocationItem(Icons.shopping_cart, Colors.orange, "Siêu thị", "WinMart Trung Hòa", "119 Trần Duy Hưng, Trung Hòa, Cầu Giấy, Hà Nội"),
            ],
          ),
        ),
        
        // Nút thêm địa điểm mới
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddLocationScreen()));
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Thêm địa điểm mới", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Hàm tạo Card địa điểm
  Widget _buildLocationItem(IconData icon, Color iconColor, String title, String subtitle, String address) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(address, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: const Icon(Icons.more_vert),
        isThreeLine: true,
      ),
    );
  }
}
