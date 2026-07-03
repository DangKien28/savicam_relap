import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/env/env_config.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_shell.dart';

class AppBootstrap {
  const AppBootstrap._();

  static Future<void> initialize() async {
    if (EnvConfig.supabaseUrl.isEmpty || EnvConfig.supabaseAnonKey.isEmpty) {
      return;
    }

    try {
      await Supabase.initialize(
        url: EnvConfig.supabaseUrl,
        anonKey: EnvConfig.supabaseAnonKey,
      );
    } catch (error) {
      debugPrint('Supabase initialization skipped: $error');
    }
  }
}

class SaViCamRelapApp extends StatelessWidget {
  const SaViCamRelapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaViCam Relap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeShell(),
    );
  }
}