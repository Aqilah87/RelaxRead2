// lib/user/book.dart (or adjust path if your book.dart is elsewhere)
import 'package:uuid/uuid.dart'; // Import uuid for ID generation

// A simple utility to generate UUIDs
final uuid = Uuid();

// --- Book Model ---
class Book {
  final String ebookId;
  final String title;
  final String author;
  final String? imageUrl;
  final String? personalNote;
  final int? pageNumber;
  // Removed: final String? price;
  final String? month_publish;
  final String? yearPublisher;
  final String? publisher;

  Book({
    String? ebookId, // Made optional for new books
    required this.title,
    required this.author,
    this.imageUrl,
    this.personalNote,
    this.pageNumber,
    // Removed: this.price,
    this.month_publish,
    this.yearPublisher,
    this.publisher,
  }) : ebookId = ebookId ?? uuid.v4(); // Generate UUID if not provided

  // Method to create a copy with updated values (useful for editing)
  Book copyWith({
    String? ebookId,
    String? title,
    String? author,
    String? imageUrl,
    String? personalNote,
    int? pageNumber,
    // Removed: String? price,
    String? month_publish,
    String? yearPublisher,
    String? publisher,
  }) {
    return Book(
      ebookId: ebookId ?? this.ebookId,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      personalNote: personalNote ?? this.personalNote,
      pageNumber: pageNumber ?? this.pageNumber,
      // Removed: price: price ?? this.price,
      month_publish: month_publish ?? this.month_publish,
      yearPublisher: yearPublisher ?? this.yearPublisher,
      publisher: publisher ?? this.publisher,
    );
  }

  // Not used directly for in-memory, but kept for consistency if converting to/from JSON later
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      ebookId: json['ebook_id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      imageUrl: json['image_url'] as String?,
      personalNote: json['personal_note'] as String?,
      pageNumber: json['page_number'] != null
          ? json['page_number'] as int
          : null,
      // Removed: price: json['price'] as String?,
      month_publish: json['month_publish'] as String?,
      yearPublisher: json['year_publisher'] as String?,
      publisher: json['publisher'] as String?,
    );
  }

  // Convert Book object to a Map (useful for forms, though we'll pass Book objects directly)
  Map<String, dynamic> toJson() {
    return {
      'ebook_id': ebookId,
      'title': title,
      'author': author,
      'image_url': imageUrl,
      'personal_note': personalNote,
      'page_number': pageNumber,
      // Removed: 'price': price,
      'month_publish': month_publish,
      'year_publisher': yearPublisher,
      'publisher': publisher,
    };
  }
}

// Our in-memory data store for books
// This list will reset every time the app restarts
List<Book> globalEbooks = [
  Book(
    ebookId: uuid.v4(),
    title: 'The Great Flutter Adventure',
    author: 'Dart Vader',
    pageNumber: 350,
    // Removed: price: '\$25.00',
    month_publish: 'Jan',
    yearPublisher: '2023',
    publisher: 'Code Press',
    imageUrl:
        'https://placehold.co/100x150/6B923C/ffffff?text=Flutter', // Placeholder
    personalNote: 'An exciting journey into Flutter development.',
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Supabase for Beginners',
    author: 'Post Gres',
    pageNumber: 280,
    // Removed: price: '\$19.99',
    month_publish: 'Mar',
    yearPublisher: '2024',
    publisher: 'Database Books',
    imageUrl:
        'https://placehold.co/100x150/5A7F30/ffffff?text=Supabase', // Placeholder
    personalNote: 'Learn the basics of backend with Supabase.',
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Widgets Masterclass',
    author: 'U.I. Expert',
    pageNumber: 420,
    // Removed: price: '\$30.50',
    month_publish: 'Jul',
    yearPublisher: '2023',
    publisher: 'Flutter Publishing',
    imageUrl:
        'https://placehold.co/100x150/3C6B92/ffffff?text=Widgets', // Placeholder
    personalNote: 'Deep dive into Flutter widgets.',
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Beyond the Basics: Dart',
    author: 'Lang Witch',
    pageNumber: 500,
    // Removed: price: '\$40.00',
    month_publish: 'Dec',
    yearPublisher: '2022',
    publisher: 'Dev Books',
    imageUrl:
        'https://placehold.co/100x150/923C6B/ffffff?text=Dart', // Placeholder
    personalNote: 'Advanced Dart programming concepts.',
  ),
];
