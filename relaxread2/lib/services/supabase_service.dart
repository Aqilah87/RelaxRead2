import 'package:supabase_flutter/supabase_flutter.dart';
import '/user/book.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  Future<List<Book>> fetchBooks() async {
    final response = await client
        .from('books')
        .select()
        .order('title', ascending: true);

    final data = response as List<dynamic>;
    return data.map((e) => Book.fromMap(e as Map<String, dynamic>)).toList();

  }
}
