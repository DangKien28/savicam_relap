import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savicam_relap/core/env/env_config.dart';
import 'package:savicam_relap/core/services/supabase_service.dart';
import 'package:savicam_relap/ui/screens/pairing_screen.dart';
import 'package:savicam_relap/ui/widgets/global_alert_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Environment variables
  await EnvConfig.loadEnv();
  
  // Initialize Supabase
  await SupabaseService().initialize();

  runApp(
    const ProviderScope(
      child: SaViCamApp(),
    ),
  );
}

class SaViCamApp extends StatelessWidget {
  const SaViCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalAlertOverlay(
      child: MaterialApp(
        title: 'SaViCam Relap',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const PairingScreen(),
      ),
    );
  }
}