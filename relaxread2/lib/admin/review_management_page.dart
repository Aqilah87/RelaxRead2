import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

// Review model class
class Review {
  final String reviewId;
  final String ebookId;
  final String reviewerName;
  final String reviewText;
  final double rating;
  final DateTime reviewDate;

  Review({
    required this.reviewId,
    required this.ebookId,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.reviewDate,
  });

  // Convert from Map to Review
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['review_id'] ?? '',
      ebookId: map['ebook_id'] ?? '',
      reviewerName: map['reviewer_name'] ?? 'Anonymous',
      reviewText: map['review_text'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewDate: DateTime.parse(map['created_at'] ?? DateTime.now().toString()),
    );
  }
}

class ReviewManagementPage extends StatefulWidget {
  const ReviewManagementPage({super.key});

  @override
  State<ReviewManagementPage> createState() => _ReviewManagementPageState();
}

class _ReviewManagementPageState extends State<ReviewManagementPage> {
  final Color primaryGreen = const Color(0xFF6B923C);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Review> _currentReviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadReviews();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase
          .from('reviews')
          .select('*')
          .order('created_at', ascending: false);

      if (response != null && response is List) {
        final reviews = response.map((r) => Review.fromMap(r)).toList();
        setState(() {
          _currentReviews = reviews;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Failed to load reviews: $e');
    }
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.toLowerCase());
  }

  List<Review> get _filteredReviews {
    if (_searchQuery.isEmpty) return _currentReviews;
    return _currentReviews.where((review) {
      return review.reviewerName.toLowerCase().contains(_searchQuery) ||
          review.reviewText.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _deleteReview(String reviewId) async {
    try {
      await supabase.from('reviews').delete().eq('review_id', reviewId);
      setState(() {
        _currentReviews.removeWhere((r) => r.reviewId == reviewId);
      });
      _showSuccessSnackbar('Review deleted successfully');
    } catch (e) {
      _showErrorSnackbar('Failed to delete review: $e');
    }
  }

  Future<void> _showDeleteDialog(Review review) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Review'),
        content: Text(
          'Delete review by ${review.reviewerName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteReview(review.reviewId);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<String> _getBookTitle(String ebookId) async {
    try {
      final response = await supabase
          .from('books')
          .select('title')
          .eq('ebook_id', ebookId)
          .single();

      return response['title'] ?? 'Unknown Book';
    } catch (e) {
      return 'Unknown Book';
    }
  }

  Widget _buildReviewCard(Review review) {
    return FutureBuilder<String>(
      future: _getBookTitle(review.ebookId),
      builder: (context, snapshot) {
        final bookTitle = snapshot.data ?? 'Loading...';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'By: ${review.reviewerName}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        Text(' ${review.rating}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.reviewText,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.reviewDate.toString().split(' ')[0],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(review),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.reviews : Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No reviews available'
                : 'No matching reviews found',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Management'),
        backgroundColor: primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReviews,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search reviews...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredReviews.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadReviews,
                        child: ListView.builder(
                          itemCount: _filteredReviews.length,
                          itemBuilder: (context, index) =>
                              _buildReviewCard(_filteredReviews[index]),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}