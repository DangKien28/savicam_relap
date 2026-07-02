import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:savicam_relap/core/env/env_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}
