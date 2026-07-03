import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env/env_config.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
    return null;
  }

  return Supabase.instance.client;
});