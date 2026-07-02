import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Cloudflare R2 (If needed)
  static String get r2Endpoint => dotenv.env['R2_ENDPOINT'] ?? '';
  static String get r2AccessKey => dotenv.env['R2_ACCESS_KEY'] ?? '';
  static String get r2SecretKey => dotenv.env['R2_SECRET_KEY'] ?? '';

  // Oracle Cloud (If direct connection needed, though usually backend handles this)
  static String get oracleCloudUrl => dotenv.env['ORACLE_CLOUD_URL'] ?? '';

  // OpenStreetMap API (If needed for custom tiles)
  static String get osmTileUrl => dotenv.env['OSM_TILE_URL'] ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
