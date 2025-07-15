import 'package:flutter/material.dart';
import 'package:relaxread2/user/authorProfile.dart';
import 'book.dart';
import 'book_detail_page.dart'; // Import the BookDetailPage

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📖 Book Cover Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  book.imageUrl ?? '',
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
              book.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),

            // 👤 Author Name (Tappable)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthorProfilePage(), // Pass real authorName if you want dynamic
                  ),
                );
              },
              child: Text(
                'by ${book.author}',
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
              '${book.publisher ?? 'Unknown Publisher'}, ${book.month_publish ?? ''} ${book.yearPublisher ?? ''}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),

            // 📝 Description
            Text(
              book.personalNote ?? 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20.0),

            // ❤️ Add to Wishlist Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // You can implement wishlist logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to Wishlist!')),
                  );
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text('Add to Wishlist'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6B923C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          ],
        ),
      ),
    );
  }
}
