import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/features/macros/user_macro_model.dart';
import 'package:savicam_relap/features/telemetry/telemetry_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Đơn giản hóa state provider để lấy danh sách macros.
final macrosStreamProvider = StreamProvider.autoDispose<List<UserMacro>>((ref) {
  final pairedDeviceId = ref.watch(currentPairedDeviceIdProvider);
  if (pairedDeviceId == null) return Stream.value([]);

  return Supabase.instance.client
      .from('user_macros')
      .stream(primaryKey: ['id'])
      .eq('paired_device_id', pairedDeviceId)
      .map((data) => data.map((json) => UserMacro.fromJson(json)).toList());
});

class UserMacrosScreen extends ConsumerWidget {
  const UserMacrosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macrosAsync = ref.watch(macrosStreamProvider);
    final pairedDeviceId = ref.watch(currentPairedDeviceIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ điển Vị trí (Macros)'),
      ),
      body: macrosAsync.when(
        data: (macros) {
          if (macros.isEmpty) {
            return const Center(child: Text('Chưa có địa điểm nào được lưu.'));
          }
          return ListView.builder(
            itemCount: macros.length,
            itemBuilder: (context, index) {
              final macro = macros[index];
              return ListTile(
                leading: const Icon(Icons.place),
                title: Text(macro.keyword, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Loại: ${macro.actionType}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await Supabase.instance.client
                        .from('user_macros')
                        .delete()
                        .eq('id', macro.id);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (pairedDeviceId != null) {
            _showAddMacroDialog(context, pairedDeviceId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vui lòng kết nối thiết bị trước.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMacroDialog(BuildContext context, String pairedDeviceId) {
    final keywordController = TextEditingController();
    double lat = 0.0;
    double lng = 0.0;
    String selectedActionType = 'navigate';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Địa Điểm Mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: keywordController,
                  decoration: const InputDecoration(labelText: 'Tên/Từ khóa (VD: Nhà, Công ty)'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedActionType,
                  decoration: const InputDecoration(labelText: 'Loại Hành động'),
                  items: const [
                    DropdownMenuItem(value: 'navigate', child: Text('Điều hướng (Navigate)')),
                    DropdownMenuItem(value: 'announce', child: Text('Thông báo (Announce)')),
                  ],
                  onChanged: (val) {
                    if (val != null) selectedActionType = val;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Tọa độ (Tạm thời nhập thủ công)'),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Vĩ độ (Lat)'),
                  onChanged: (val) => lat = double.tryParse(val) ?? 0.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Kinh độ (Lng)'),
                  onChanged: (val) => lng = double.tryParse(val) ?? 0.0,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newMacro = UserMacro(
                  id: const Uuid().v4(),
                  pairedDeviceId: pairedDeviceId,
                  keyword: keywordController.text.trim(),
                  actionType: selectedActionType,
                  dataValue: {'lat': lat, 'lng': lng},
                  updatedAt: DateTime.now(),
                  createdAt: DateTime.now(),
                );

                await Supabase.instance.client
                    .from('user_macros')
                    .insert(newMacro.toJson());

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Lưu và Đồng bộ'),
            ),
          ],
        );
      },
    );
  }
}
