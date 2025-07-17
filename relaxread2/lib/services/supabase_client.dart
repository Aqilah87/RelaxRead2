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
  
  Future<Map<String, dynamic>> getUserData(String userId) async {
    return await client
      .from('users')
      .select()
      .eq('id', userId)
      .single();
  }

  Future<void> updateName(String userId, String newName) async {
    await client
      .from('users')
      .update({'name': newName})
      .eq('id', userId);
  }

  Future<void> deleteUser(String userId) async {
    await client
      .from('users')
      .delete()
      .eq('id', userId);
    await client.auth.admin.deleteUser(userId);
  }

  Future<void> updatePassword(String newPassword) async {
    await client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }
}