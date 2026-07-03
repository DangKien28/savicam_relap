import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/pairing_service.dart';
import '../../../data/services/supabase_service.dart';
import '../../dashboard/screens/main_navigation_screen.dart';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PairingService _pairingService = PairingService();

  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _connectToSupabase(String code) async {
    setState(() => _isLoading = true);

    try {
      final currentUserId = SupabaseService().currentUser?.id;

      if (currentUserId == null || currentUserId.isEmpty) {
        throw StateError('Bạn chưa đăng nhập. Vui lòng đăng nhập lại tài khoản Relap.');
      }

      await _pairingService.pairDevice(code: code, userId: currentUserId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ghép nối thành công!'), backgroundColor: Colors.green),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (error) {
      _showError(error.toString().replaceFirst('Bad state: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppStrings.pairingTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.saviBlue,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.phonelink_ring_outlined, size: 40, color: AppColors.saviBlue),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Nhập mã kết nối',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Vui lòng nhập mã gồm 6 chữ số hiển thị trên ứng dụng SaViCam T-Mod của thiết bị người khiếm thị.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                        ),
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(_focusNode);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: 0.0,
                                child: TextField(
                                  controller: _codeController,
                                  focusNode: _focusNode,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  autofocus: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(6, (index) => _buildCodeBox(index)),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _codeController.text.length == 6 && !_isLoading
                                ? () => _connectToSupabase(_codeController.text)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.saviBlue,
                              disabledBackgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: _codeController.text.length == 6 ? 4 : 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Xác nhận kết nối',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    final currentText = _codeController.text;
    final isFilled = currentText.length > index;
    final isCurrentFocus = currentText.length == index;

    return Container(
      width: 48,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFilled ? Colors.white : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentFocus
              ? AppColors.saviBlue
              : (isFilled ? Colors.grey[400]! : Colors.transparent),
          width: isCurrentFocus ? 2.0 : 1.0,
        ),
        boxShadow: isCurrentFocus
          ? [BoxShadow(color: AppColors.saviBlue.withValues(alpha: 0.2), blurRadius: 8)]
            : null,
      ),
      child: Text(
        isFilled ? currentText[index] : '',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}