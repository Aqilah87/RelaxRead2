import 'package:flutter/material.dart';
import 'package:relaxread2/user/authorProfile.dart';
import 'book.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int _userRating = 0; // State variable to hold the user's selected rating
  final TextEditingController _commentController =
      TextEditingController(); // Controller for the comment input field

  // List to store comments, initially populated with some examples
  List<Map<String, String>> _comments = [
    {
      'userName': 'Jane Doe',
      'commentText': 'This book was absolutely amazing! Highly recommend it.',
    },
    {
      'userName': 'John Smith',
      'commentText': 'A good read, but I found the ending a bit rushed.',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📖 Book Cover Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.book.imageUrl ?? '',
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 📚 Book Title
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

            // 👤 Author Name (Tappable)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthorProfilePage()),
                );
              },
              child: Text(
                'by ${widget.book.author}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // 🏢 Publisher Info
            Text(
              '${widget.book.publisher ?? 'Unknown Publisher'}, ${widget.book.month_publish ?? ''} ${widget.book.yearPublisher ?? ''}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),

            // 📝 Description
            Text(
              widget.book.personalNote ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20.0),

            // ---
            ///
            /// ## ⭐ Ratings
            ///
            ///---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 10.0),
                const Text(
                  'Ratings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _userRating = index + 1;
                        });
                      },
                      child: Icon(
                        index < _userRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 5.0),
                Text(
                  _userRating > 0
                      ? 'Your rating: $_userRating stars'
                      : 'Tap stars to rate',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // ---
            ///
            /// ## 💬 Comments
            ///
            ///---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                const SizedBox(height: 10.0),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10.0),
                // Displaying comments from the _comments list
                if (_comments.isEmpty)
                  const Text('No comments yet. Be the first to comment!'),
                ..._comments.map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                    ), // Add spacing between comments
                    child: _buildComment(
                      comment['userName']!,
                      comment['commentText']!,
                    ),
                  );
                }).toList(),
                const SizedBox(height: 10.0), // Spacing before the input field
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        _submitComment();
                      },
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // ❤️ Add to Wishlist Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to Wishlist!')),
                  );
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('Add to Wishlist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B923C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildComment(String userName, String commentText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 4.0),
        Text(commentText, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  void _submitComment() {
    final String commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      // In a real app, you would send this comment to your backend/database
      // and then update your local list _after_ successful backend response.

      setState(() {
        // For demonstration, we'll use a placeholder user name.
        // In a real app, you'd get the current authenticated user's name.
        _comments.add({'userName': 'You', 'commentText': commentText});
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment submitted successfully!')),
      );
      _commentController.clear(); // Clear the text field after submission
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment cannot be empty!')));
    }
  }
}
