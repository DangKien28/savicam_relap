import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/services/supabase_service.dart';

final authStateChangesProvider = StreamProvider<AuthState>((ref) {
  if (!SupabaseService.isInitialized) {
    return const Stream<AuthState>.empty();
  }

  return SupabaseService().authStateChanges;
});