import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart'; // Import the Book class
import 'book_detail_page.dart'; // Import the BookDetailPage

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample list of books for demonstration
    List<Book> books = globalEbooks; // Use your global book list

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filters row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('All Genres'),
                      items: <String>[
                        'All Genres',
                        'Fiction',
                        'Science',
                        'Fantasy',
                        'History',
                        'Biography',
                        'Mystery'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle genre change
                      },
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      hint: const Text('All Ratings'),
                      items: <String>[
                        'All Ratings',
                        '5 stars',
                        '4 stars & up',
                        '3 stars & up',
                        '2 stars & up',
                        '1 star & up'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle rating change
                      },
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      hint: const Text('Sort by'),
                      items: <String>[
                        'Most Liked',
                        'Newest',
                        'Oldest'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle sort change
                      },
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Apply filters
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Results Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                  children: books.map((book) {
                    return BookCard(book: book); // Pass the Book object
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book; // Change to accept a Book object

  const BookCard({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the BookDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailPage(book: book),
          ),
        );
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                book.imageUrl ?? '',
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}