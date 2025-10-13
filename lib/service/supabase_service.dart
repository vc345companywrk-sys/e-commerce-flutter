// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");

    // UPDATED: Remove authFlowType parameter
    await Supabase.initialize(
      url: dotenv.env['https://iffkycfypeqxsgjzwjbx.supabase.co']!,
      anonKey: dotenv
          .env['eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlmZmt5Y2Z5cGVxeHNnanp3amJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgzNjk4NDMsImV4cCI6MjA3Mzk0NTg0M30.hFJBMMlmHWL0CxPINb9jbsnBM9ZxVeJher_DvEW_xws']!,
      // authFlowType parameter is no longer needed in recent versions
    );
  }
}
