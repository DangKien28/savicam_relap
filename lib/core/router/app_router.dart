import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/supabase_service.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/dashboard/screens/main_navigation_screen.dart';
import '../../features/pairing/providers/pairing_providers.dart';
import '../../features/pairing/screens/pairing_screen.dart';
import '../../features/auth/screens/auth_screen.dart';

class AppBootstrap extends ConsumerWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!SupabaseService.isInitialized) {
      return const MainNavigationScreen();
    }

    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      loading: () => const _AppLoadingScreen(),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Không thể đọc trạng thái đăng nhập: $error')),
      ),
      data: (authState) {
        final session = authState.session;

        if (session == null) {
          return LoginScreen();
        }

        final pairingStatus = ref.watch(pairingStatusProvider(session.user.id));

        return pairingStatus.when(
          loading: () => const _AppLoadingScreen(),
          error: (error, stackTrace) => Scaffold(
            body: Center(child: Text('Không thể kiểm tra ghép nối: $error')),
          ),
          data: (hasPairedDevice) {
            if (hasPairedDevice) {
              return const MainNavigationScreen();
            }

            return const PairingScreen();
          },
        );
      },
    );
  }
}

class _AppLoadingScreen extends StatelessWidget {
  const _AppLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}