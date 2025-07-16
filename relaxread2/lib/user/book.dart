import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Book {
  final String ebookId;
  final String title;
  final String author;
  final String? imageUrl;
  final String? personalNote;
  final String? description; // Added description field
  final int? pageNumber;
  final String? monthPublish;
  final String? yearPublisher;
  final String? publisher;
  final String? genre;
  final double? rating;

  Book({
    String? ebookId,
    required this.title,
    required this.author,
    this.imageUrl,
    this.personalNote,
    this.description, // Added to constructor
    this.pageNumber,
    this.monthPublish,
    this.yearPublisher,
    this.publisher,
    this.genre,
    this.rating,
  }) : ebookId = ebookId ?? uuid.v4();

  /// Parse from Supabase row
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      ebookId: map['ebook_id']?.toString() ?? uuid.v4(),
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['image_url'],
      personalNote: map['personal_note'],
      description: map['description'], // Added to fromMap
      pageNumber: map['page_number'] is int 
          ? map['page_number'] 
          : int.tryParse(map['page_number']?.toString() ?? ''),
      monthPublish: map['month_publish'],
      yearPublisher: map['year_publisher'],
      publisher: map['publisher'],
      genre: map['genre'],
      rating: map['rating'] != null 
          ? (map['rating'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ebook_id': ebookId,
      'title': title,
      'author': author,
      'image_url': imageUrl,
      'personal_note': personalNote,
      'description': description, // Added to toMap
      'page_number': pageNumber,
      'month_publish': monthPublish,
      'year_publisher': yearPublisher,
      'publisher': publisher,
      'genre': genre,
      'rating': rating,
    };
  }
}