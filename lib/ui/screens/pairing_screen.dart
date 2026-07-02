import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/features/telemetry/telemetry_provider.dart';
import 'package:savicam_relap/ui/screens/main_screen.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pairDevice() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Kiểm tra xem code có tồn tại và hợp lệ không
      final response = await SupabaseService().client
          .from('device_pairs')
          .select()
          .eq('pairing_code', code)
          .eq('status', 'pending')
          .maybeSingle();

      if (response != null) {
        // 2. Cập nhật status thành active
        await SupabaseService().client
            .from('device_pairs')
            .update({'status': 'active', 'relap_user_id': 'current_user_id'}) // Mock user id
            .eq('id', response['id']);

        // 3. Set paired device id vào state
        ref.read(currentPairedDeviceIdProvider.notifier).state = response['id'];

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ghép nối thành công!')),
          );
          // Navigate to main/dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mã ghép nối không hợp lệ hoặc đã hết hạn.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi ghép nối: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ghép nối thiết bị T-Mod')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.qr_code_scanner, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            const Text(
              'Nhập mã ghép nối 6 số từ thiết bị T-Mod của người thân',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'XXXXXX',
              ),
              maxLength: 6,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _pairDevice,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: _isLoading 
                ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('XÁC NHẬN GHÉP NỐI'),
            ),
          ],
        ),
      ),
    );
  }
}
