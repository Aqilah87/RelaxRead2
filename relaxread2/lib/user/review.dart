import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ReviewService {
  // Add a new review
  static Future<void> addReview({
    required String bookId,
    required String userId,
    required String reviewerName,
    required String reviewText,  // Added
    required String comment,
    required double rating,
  }) async {
    try {
      await supabase.from('reviews').insert({
        'book_id': bookId,
        'user_id': userId,
        'reviewer_name': reviewerName,
        'review_text': reviewText,  // Added
        'comment': comment,
        'rating': rating,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding review: $e');
      throw Exception('Failed to add review');
    }
  }

  // Get all reviews for a specific book
  static Future<List<Review>> getReviewsForBook(String bookId) async {
    try {
      final response = await supabase
          .from('reviews')
          .select('*')
          .eq('book_id', bookId)
          .order('created_at', ascending: false);

      return (response as List).map<Review>((review) => Review.fromSupabaseMap(review)).toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      throw Exception('Failed to fetch reviews');
    }
  }

  // Get reviews by a specific user
  static Future<List<Review>> getUserReviews(String userId) async {
    try {
      final response = await supabase
          .from('reviews')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map<Review>((review) => Review.fromSupabaseMap(review)).toList();
    } catch (e) {
      print('Error fetching user reviews: $e');
      throw Exception('Failed to fetch user reviews');
    }
  }

  // Update a review
  static Future<void> updateReview({
    required String reviewId,
    required String reviewText,  // Added
    required String comment,
    required double rating,
  }) async {
    try {
      await supabase.from('reviews').update({
        'review_text': reviewText,  // Added
        'comment': comment,
        'rating': rating,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('review_id', reviewId);
    } catch (e) {
      print('Error updating review: $e');
      throw Exception('Failed to update review');
    }
  }

  // Delete a review
  static Future<void> deleteReview(String reviewId) async {
    try {
      await supabase.from('reviews').delete().eq('review_id', reviewId);
    } catch (e) {
      print('Error deleting review: $e');
      throw Exception('Failed to delete review');
    }
  }
}

class Review {
  final String reviewId;
  final String bookId;
  final String userId;
  final String reviewerName;
  final String reviewText;  // Added
  final String comment;
  final double rating;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Review({
    required this.reviewId,
    required this.bookId,
    required this.userId,
    required this.reviewerName,
    required this.reviewText,  // Added
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.updatedAt, required String ebookId, required DateTime reviewDate,
  });

  // Convert from Supabase row to Review object
  factory Review.fromSupabaseMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['review_id'] as String,
      bookId: map['book_id'] as String,
      userId: map['user_id'] as String,
      reviewerName: map['reviewer_name'] as String,
      reviewText: map['review_text'] as String,  // Added
      comment: map['comment'] as String,
      rating: (map['rating'] as num).toDouble(),
      createdAt : DateTime.parse(map['created_at'] as String),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'] as String)
          : null, ebookId: '', reviewDate: DateTime.now(),
    );
  }

  // Convert to Supabase-compatible map
  Map<String, dynamic> toSupabaseMap() {
    return {
      'review_id': reviewId,
      'book_id': bookId,
      'user_id': userId,
      'reviewer_name': reviewerName,
      'review_text': reviewText,  // Added
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Convert to JSON for API responses
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'bookId': bookId,
      'userId': userId,
      'reviewerName': reviewerName,
      'reviewText': reviewText,  // Added
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

// Example UI Component for displaying reviews
class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final bool showUserActions;
  final Function(String)? onDelete;
  final Function(Review)? onEdit;

  const ReviewList({
    super.key,
    required this.reviews,
    this.showUserActions = false,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return ReviewCard(
          review: review,
          showActions: showUserActions,
          onDelete: onDelete,
          onEdit: onEdit,
        );
      },
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool showActions;
  final Function(String)? onDelete;
  final Function(Review)? onEdit;

  const ReviewCard({
    super.key,
    required this.review,
    this.showActions = false,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.reviewerName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < review.rating.floor()
                            ? Icons.star
                            : (index == review.rating.floor() && 
                                (review.rating - review.rating.floor()) >= 0.5)
                                ? Icons.star_half
                                : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.reviewText,  // Changed from comment to reviewText
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Additional comment: ${review.comment}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            Text(
              _formatDate(review.createdAt),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            if (showActions && onDelete != null && onEdit != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => onEdit!(review),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: () => onDelete!(review.reviewId),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Example usage in a screen
class BookReviewsScreen extends StatefulWidget {
  final String bookId;
  const BookReviewsScreen({super.key, required this.bookId});

  @override
  State<BookReviewsScreen> createState() => _BookReviewsScreenState();
}

class _BookReviewsScreenState extends State<BookReviewsScreen> {
  late Future<List<Review>> _reviewsFuture;
  final userId = supabase.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewService.getReviewsForBook(widget.bookId);
  }

  Future<void> _refreshReviews() {
    setState(() {
      _reviewsFuture = ReviewService.getReviewsForBook(widget.bookId);
    });
    return _reviewsFuture;
  }

  Future<void> _addReview() async {
    // Show dialog or navigate to add review screen
    // Then call ReviewService.addReview()
    await _refreshReviews();
  }

  Future<void> _deleteReview(String reviewId) async {
    try {
      await ReviewService.deleteReview(reviewId);
      await _refreshReviews();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Reviews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshReviews,
          ),
          if (userId != null)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addReview,
            ),
        ],
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reviews = snapshot.data ?? [];

          return RefreshIndicator(
            onRefresh: _refreshReviews,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (reviews.isEmpty)
                  const Center(
                    child: Text('No reviews yet'),
                  )
                else
                  ReviewList(
                    reviews: reviews,
                    showUserActions: true, // Show if current user is the reviewer
                    onDelete: _deleteReview,
                    onEdit: (review) {
                      // Handle edit
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}