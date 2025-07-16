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
  int _userRating = 0;
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, dynamic>> _comments = [
    {
      'user': 'Jane Doe',
      'comment': 'This book was absolutely amazing! Highly recommend it.',
      'rating': 5,
    },
    {
      'user': 'John Smith',
      'comment': 'A good read, but I found the ending a bit rushed.',
      'rating': 3,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment() {
    final String commentText = _commentController.text.trim();

    if (_userRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating before commenting.'),
        ),
      );
      return;
    }

    if (commentText.isNotEmpty) {
      setState(() {
        _comments.add({
          'user': 'You',
          'comment': commentText,
          'rating': _userRating,
        });
        _commentController.clear();
        _userRating = 0;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment added!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Comment cannot be empty!')));
    }
  }

  Widget _buildComment(String userName, String commentText, int rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 4.0),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
              size: 16,
            );
          }),
        ),
        const SizedBox(height: 4.0),
        Text(commentText, style: const TextStyle(fontSize: 14)),
      ],
    );
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
            // 📘 Book cover
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
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // 📖 Title
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // 👤 Author
            const SizedBox(height: 8.0),
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

            // 🏢 Publisher info
            const SizedBox(height: 8.0),
            Text(
              '${widget.book.publisher ?? 'Unknown Publisher'}, ${widget.book.month_publish ?? ''} ${widget.book.yearPublisher ?? ''}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            // 📝 Description
            const SizedBox(height: 16.0),
            Text(
              widget.book.personalNote ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 10.0),

            // ⭐ Rating input
            const Text(
              'Your Rating',
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
                  ? 'Your rating: $_userRating star${_userRating > 1 ? 's' : ''}'
                  : 'Tap stars to rate',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 20.0),
            const Divider(),
            const SizedBox(height: 10.0),

            // 💬 Comments section
            const Text(
              'Comments',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),

            ..._comments.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildComment(c['user'], c['comment'], c['rating'] ?? 0),
              ),
            ),

            // ✍️ Comment input
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _submitComment,
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20.0),

            // ❤️ Wishlist button
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
                  backgroundColor: const Color(0xFF6B923C),
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
}
