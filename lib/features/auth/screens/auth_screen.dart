import 'package:flutter/material.dart';
import '../../../data/services/auth_service.dart';
// import '../../pairing/screens/pairing_screen.dart'; // Mở comment này khi có màn hình Pairing

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isLoginMode = true; // True: Đang ở chế độ Đăng nhập, False: Đăng ký

  // Hàm xử lý khi bấm nút
  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ Email và Mật khẩu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLoginMode) {
        await _authService.login(email, password);
      } else {
        await _authService.register(email, password);
      }
      
      if (!mounted) return;
      
      // Đăng nhập thành công -> Chuyển sang màn hình Nhập mã 6 số (Pairing)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isLoginMode ? 'Đăng nhập thành công!' : 'Đăng ký thành công!')),
      );
      
      // Kịch bản thực tế: Chuyển hướng sang màn hình Pairing
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PairingScreen()));

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo / Tiêu đề
                const Icon(Icons.family_restroom, size: 80, color: Color(0xFF1E40AF)),
                const SizedBox(height: 16),
                const Text(
                  'SaViCam Relap',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                ),
                const Text(
                  'Ứng dụng đồng hành cho người thân',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 48),

                // Form nhập liệu
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email của bạn',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mật khẩu',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nút Đăng nhập / Đăng ký
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E40AF), // savi-blue
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  _isLoginMode ? 'Đăng nhập' : 'Tạo tài khoản',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Nút chuyển đổi giữa Login và Register
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLoginMode = !_isLoginMode;
                    });
                  },
                  child: Text(
                    _isLoginMode 
                        ? 'Chưa có tài khoản? Đăng ký ngay' 
                        : 'Đã có tài khoản? Đăng nhập',
                    style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}