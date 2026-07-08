import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://hcyezbiviugennwsqwfd.supabase.co';
  static const String anonKey = 'sb_publishable_fO0gcXbhCsaTX5ZwbCU8TA_YtuYJxFJ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

final supabase = Supabase.instance.client;