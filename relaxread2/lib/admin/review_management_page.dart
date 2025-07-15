// lib/review_management_page.dart
import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart'; // Assuming Book class is here

// Placeholder Review class for demonstration
class Review {
  final String reviewId;
  final String ebookId; // Link to the book
  final String reviewerName;
  final String reviewText;
  final double rating; // 1.0 to 5.0
  final DateTime reviewDate;

  Review({
    required this.reviewId,
    required this.ebookId,
    required this.reviewerName,
    required this.reviewText,
    required this.rating,
    required this.reviewDate,
  });
}

// Assuming globalReviews is a List<Review> defined in global_data.dart
// For demonstration, let's add some dummy review data
List<Review> globalReviews = [
  Review(
    reviewId: 'rev1',
    ebookId: '1', // Assuming an ebook with ID '1' exists
    reviewerName: 'Alice Smith',
    reviewText: 'A truly captivating read! Highly recommended.',
    rating: 4.5,
    reviewDate: DateTime(2023, 10, 26),
  ),
  Review(
    reviewId: 'rev2',
    ebookId: '2', // Assuming an ebook with ID '2' exists
    reviewerName: 'Bob Johnson',
    reviewText: 'Enjoyed the plot, but some characters felt underdeveloped.',
    rating: 3.0,
    reviewDate: DateTime(2023, 11, 15),
  ),
  Review(
    reviewId: 'rev3',
    ebookId: '1',
    reviewerName: 'Charlie Brown',
    reviewText: 'Could not put it down! A masterpiece.',
    rating: 5.0,
    reviewDate: DateTime(2024, 1, 5),
  ),
];

class ReviewManagementPage extends StatefulWidget {
  const ReviewManagementPage({super.key});

  @override
  State<ReviewManagementPage> createState() => _ReviewManagementPageState();
}

class _ReviewManagementPageState extends State<ReviewManagementPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Review> _currentReviews =
      []; // Local list to display, filtered by search

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadReviews(); // Initial load
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterReviews(); // Re-filter when search query changes
    });
  }

  void _loadReviews() {
    setState(() {
      _currentReviews = List.from(globalReviews); // Make a mutable copy
      _filterReviews(); // Apply initial filter
    });
  }

  void _filterReviews() {
    if (_searchQuery.isEmpty) {
      _currentReviews = List.from(globalReviews);
    } else {
      _currentReviews = globalReviews.where((review) {
        final reviewerName = review.reviewerName.toLowerCase();
        final reviewText = review.reviewText.toLowerCase();
        final query = _searchQuery.toLowerCase();
        // You might also want to search by book title, which would require
        // fetching the book details based on review.ebookId
        return reviewerName.contains(query) || reviewText.contains(query);
      }).toList();
    }
  }

  // Function to delete a review from in-memory list
  void _deleteReview(String reviewId) {
    setState(() {
      globalReviews.removeWhere((review) => review.reviewId == reviewId);
      _filterReviews(); // Re-filter the displayed list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Review deleted successfully!')),
    );
  }

  // Confirmation dialog for deletion
  Future<void> _showDeleteConfirmationDialog(
    String reviewId,
    String reviewerName,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete the review by "$reviewerName"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: primaryGreen)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReview(reviewId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Helper to get book title from ebookId (for display purposes)
  String _getBookTitle(String ebookId) {
    final book = globalEbooks.firstWhere(
      (b) => b.ebookId == ebookId,
      orElse: () =>
          Book(ebookId: '', title: 'Unknown Book', author: ''), // Fallback
    );
    return book.title;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search reviews by reviewer or content...',
              prefixIcon: Icon(Icons.search, color: primaryGreen),
              filled: true,
              fillColor: const Color.fromARGB(255, 234, 232, 232),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: primaryGreen, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: _currentReviews.isEmpty && _searchQuery.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rate_review, color: Colors.grey, size: 50),
                      SizedBox(height: 10),
                      Text('No reviews found.'),
                    ],
                  ),
                )
              : _currentReviews.isEmpty && _searchQuery.isNotEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, color: Colors.grey, size: 50),
                      SizedBox(height: 10),
                      Text('No matching reviews found for your search.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _currentReviews.length,
                  itemBuilder: (context, index) {
                    final review = _currentReviews[index];
                    final bookTitle = _getBookTitle(review.ebookId);

                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Review for: $bookTitle',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: loginPrimaryGreen,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'By: ${review.reviewerName}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                    Text(
                                      '${review.rating.toStringAsFixed(1)}/5.0',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              review.reviewText,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${review.reviewDate.toLocal().toString().split(' ')[0]}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Delete Review',
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                    review.reviewId,
                                    review.reviewerName,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
