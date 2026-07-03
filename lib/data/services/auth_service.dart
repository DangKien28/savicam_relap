import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Đăng nhập đơn giản bằng Email & Password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Đăng nhập thất bại. Vui lòng kiểm tra lại email/mật khẩu!');
    }
  }

  // Đăng ký đơn giản (Vì đã tắt Confirm Email trên Supabase nên đăng ký xong là đăng nhập luôn)
  Future<AuthResponse> register(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Đăng ký thất bại. Email này có thể đã được sử dụng.');
    }
  }

  // Lấy ID của người dùng hiện tại
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }
}