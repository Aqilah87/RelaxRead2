import 'package:relaxread2/user/review.dart'; // Import the Review class
import 'package:relaxread2/user/book.dart'; // Import the Book class
import 'package:uuid/uuid.dart';

class DataService {
  static final Uuid _uuid = Uuid();

  // Simulated in-memory review database
  static final List<Review> _mockReviews = [
    Review(
      reviewId: _uuid.v4(),
      ebookId: 'book1',
      reviewerName: 'Jane Doe',
      reviewText: 'This book was absolutely amazing! Highly recommend it.',
      rating: 5.0,
      reviewDate: DateTime(2023, 10, 26, 14, 30),
    ),
    Review(
      reviewId: _uuid.v4(),
      ebookId: 'book1',
      reviewerName: 'John Smith',
      reviewText: 'A good read, but I found the ending a bit rushed.',
      rating: 3.0,
      reviewDate: DateTime(2023, 11, 1, 9, 15),
    ),
    Review(
      reviewId: _uuid.v4(),
      ebookId: 'book2',
      reviewerName: 'Alice Brown',
      reviewText: 'Couldn\'t put it down! A masterpiece.',
      rating: 5.0,
      reviewDate: DateTime(2024, 1, 5, 18, 0),
    ),
    Review(
      reviewId: _uuid.v4(),
      ebookId: 'book2',
      reviewerName: 'Bob White',
      reviewText: 'Decent, but not my favorite genre.',
      rating: 2.0,
      reviewDate: DateTime(2024, 2, 10, 11, 45),
    ),
  ];

  // Wishlist functionality
  static final List<Book> wishlistBooks = [];

  static void addToWishlist(Book book) {
    if (!wishlistBooks.any((b) => b.ebookId == book.ebookId)) {
      wishlistBooks.add(book);
    }
  }

  static void removeFromWishlist(String ebookId) {
    wishlistBooks.removeWhere((b) => b.ebookId == ebookId);
  }

  /// Get reviews for a specific book
  static List<Review> getReviewsForBook(String ebookId) {
    return _mockReviews.where((review) => review.ebookId == ebookId).toList();
  }

  /// Add a new review
  static void addReview(Review newReview) {
    _mockReviews.add(newReview);
  }

  /// Async version to fetch reviews
  static Future<List<Review>> fetchReviewsForBook(Book book) async {
    await Future.delayed(const Duration(seconds: 1));
    return getReviewsForBook(book.ebookId);
  }

  /// Async version to simulate review submission
  static Future<bool> addReviewForBook(Book book, Review newReview) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      addReview(newReview);
      return true;
    } catch (e) {
      print('Error adding review: $e');
      return false;
    }
  }
}
