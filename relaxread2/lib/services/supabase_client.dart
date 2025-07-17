// lib/services/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  
  late final SupabaseClient client;

  SupabaseService._internal() {
    client = Supabase.instance.client;
  }

  User? get currentUser => client.auth.currentUser;

  // ✅ Fixed: Closed method properly so it doesn't interrupt the class
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final result = await client
      .from('users')
      .select('user_id, name, email')
      .eq('user_id', userId)
      .maybeSingle();

    return result ?? {};
  }

  // ✅ Method now properly outside getUserData block
  Future<void> updateName(String userId, String newName) async {
    await client
      .from('users')
      .update({'name': newName})
      .eq('user_id', userId);
  }

  Future<void> deleteUser(String userId) async {
    await client
      .from('users')
      .delete()
      .eq('user_id', userId);

    await client.auth.admin.deleteUser(userId);
  }

  Future<void> updatePassword(String newPassword) async {
    await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}
