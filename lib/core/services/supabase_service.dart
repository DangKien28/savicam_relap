import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:savicam_relap/core/env/env_config.dart';

class SupabaseService {
  // Triển khai mẫu Singleton để gọi lại service dễ dàng ở mọi nơi
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    final url = EnvConfig.supabaseUrl;
    final anonKey = EnvConfig.supabaseAnonKey;

    if (url.isEmpty || anonKey.isEmpty) {
      debugPrint('Cảnh báo: Thiếu SUPABASE_URL hoặc SUPABASE_ANON_KEY trong file .env');
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
      debugPrint('Khởi tạo Supabase thành công!');
    } catch (e) {
      debugPrint('Lỗi khởi tạo Supabase: $e');
    }
  }
}