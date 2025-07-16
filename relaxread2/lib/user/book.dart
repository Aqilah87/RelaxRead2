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
  final String? month_publish;
  final String? yearPublisher;
  final String? publisher;
  final String? genre; // Added: Genre field
  final double? rating; // Added: Rating field

  Book({
    String? ebookId, // Made optional for new books
    required this.title,
    required this.author,
    this.imageUrl,
    this.personalNote,
    this.pageNumber,
    this.month_publish,
    this.yearPublisher,
    this.publisher,
    this.genre, // Added to constructor
    this.rating, // Added to constructor
  }) : ebookId = ebookId ?? uuid.v4(); // Generate UUID if not provided

  // Method to create a copy with updated values (useful for editing)
  Book copyWith({
    String? ebookId,
    String? title,
    String? author,
    String? imageUrl,
    String? personalNote,
    int? pageNumber,
    String? month_publish,
    String? yearPublisher,
    String? publisher,
    String? genre, // Added to copyWith
    double? rating, // Added to copyWith
  }) {
    return Book(
      ebookId: ebookId ?? this.ebookId,
      title: title ?? this.title,
      author: author ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      personalNote: personalNote ?? this.personalNote,
      pageNumber: pageNumber ?? this.pageNumber,
      month_publish: month_publish ?? this.month_publish,
      yearPublisher: yearPublisher ?? this.yearPublisher,
      publisher: publisher ?? this.publisher,
      genre: genre ?? this.genre, // Copy genre
      rating: rating ?? this.rating, // Copy rating
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
      month_publish: json['month_publish'] as String?,
      yearPublisher: json['year_publisher'] as String?,
      publisher: json['publisher'] as String?,
      genre: json['genre'] as String?, // Parse genre
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null, // Parse rating
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
      'month_publish': month_publish,
      'year_publisher': yearPublisher,
      'publisher': publisher,
      'genre': genre, // Include genre in JSON
      'rating': rating, // Include rating in JSON
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
    month_publish: 'Jan',
    yearPublisher: '2023',
    publisher: 'Code Press',
    imageUrl:
        'https://placehold.co/100x150/6B923C/ffffff?text=Flutter', // Placeholder
    personalNote: 'An exciting journey into Flutter development.',
    genre: 'Programming',
    rating: 4.5,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Supabase for Beginners',
    author: 'Post Gres',
    pageNumber: 280,
    month_publish: 'Mar',
    yearPublisher: '2024',
    publisher: 'Database Books',
    imageUrl:
        'https://placehold.co/100x150/5A7F30/ffffff?text=Supabase', // Placeholder
    personalNote: 'Learn the basics of backend with Supabase.',
    genre: 'Programming',
    rating: 4.8,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Widgets Masterclass',
    author: 'U.I. Expert',
    pageNumber: 420,
    month_publish: 'Jul',
    yearPublisher: '2023',
    publisher: 'Flutter Publishing',
    imageUrl:
        'https://placehold.co/100x150/3C6B92/ffffff?text=Widgets', // Placeholder
    personalNote: 'Deep dive into Flutter widgets.',
    genre: 'Programming',
    rating: 4.2,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Beyond the Basics: Dart',
    author: 'Lang Witch',
    pageNumber: 500,
    month_publish: 'Dec',
    yearPublisher: '2022',
    publisher: 'Dev Books',
    imageUrl:
        'https://placehold.co/100x150/923C6B/ffffff?text=Dart', // Placeholder
    personalNote: 'Advanced Dart programming concepts.',
    genre: 'Programming',
    rating: 4.7,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'The Silent Patient',
    author: 'Alex Michaelides',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91K2qS3oE3L.jpg',
    personalNote: 'A gripping psychological thriller.',
    genre: 'Mystery',
    rating: 4.1,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Where the Crawdads Sing',
    author: 'Delia Owens',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91L8S62L-4L.jpg',
    personalNote: 'A beautiful and haunting coming-of-age story.',
    genre: 'Fiction',
    rating: 4.6,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91tJ0Z0yGML.jpg',
    personalNote: 'Sci-fi at its best, full of humor and heart.',
    genre: 'Science Fiction',
    rating: 4.9,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'The Midnight Library',
    author: 'Matt Haig',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91KxG0V2sNL.jpg',
    personalNote: 'A thought-provoking tale about choices and regrets.',
    genre: 'Fantasy',
    rating: 4.3,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Dune',
    author: 'Frank Herbert',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/81ym3Qu7f3L.jpg',
    personalNote: 'A classic science fiction masterpiece.',
    genre: 'Science Fiction',
    rating: 4.7,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Sapiens: A Brief History of Humankind',
    author: 'Yuval Noah Harari',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/71R2W3c-W6L.jpg',
    personalNote: 'An eye-opening look at human history.',
    genre: 'History',
    rating: 4.5,
  ),
  Book(
    ebookId: uuid.v4(),
    title: 'Educated',
    author: 'Tara Westover',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/71x5bA-FpML.jpg',
    personalNote: 'A powerful memoir of self-invention.',
    genre: 'Biography',
    rating: 4.4,
  ),
];

// --- Global Wishlist ---
// This list will hold the books added to the wishlist.
// It's mutable and can be accessed from anywhere.
List<Book> globalWishlist = [
  // You can pre-populate with some books if you want them there by default
  // For example, if you want "Calon Isteri Tuan Haider" to always be in the wishlist:
  Book(
    ebookId: uuid.v4(), // Generate a unique ID for pre-populated books too
    title: 'Calon Isteri Tuan Haider',
    author: 'Zati Mohd',
    imageUrl: 'https://picsum.photos/150/220?random=1',
    personalNote: 'A heartfelt romance with emotional depth.',
    genre: 'Romance',
    rating: 4.0,
  ),
];
