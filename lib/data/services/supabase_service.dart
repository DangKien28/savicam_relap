import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseUrl.isEmpty || supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
      _initialized = false;
      return;
    }

    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
    _initialized = true;
  }

  SupabaseClient get client {
    if (!_initialized) {
      throw StateError('Supabase has not been initialized.');
    }

    return Supabase.instance.client;
  }

  User? get currentUser => _initialized ? client.auth.currentUser : null;

  Stream<AuthState> get authStateChanges => _initialized
      ? client.auth.onAuthStateChange
      : const Stream<AuthState>.empty();
}