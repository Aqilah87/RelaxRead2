import 'package:flutter/material.dart';
import 'book.dart';
import 'book_detail_page.dart';

class AuthorProfilePage extends StatelessWidget {
  final String authorName;
  final String profileImageUrl;
  final List<Book> booksByAuthor;

  const AuthorProfilePage({
    super.key,
    required this.authorName,
    required this.profileImageUrl,
    required this.booksByAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        title: Text(authorName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼 Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: profileImageUrl.isNotEmpty
                  ? NetworkImage(profileImageUrl)
                  : const AssetImage('assets/default_author.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            // 📝 Author Name
            Text(
              authorName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // 🔔 Follow Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Followed!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Text('Follow', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 30),
            // 📚 Books Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Books by $authorName',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            booksByAuthor.isEmpty
                ? const Text('No books available for this author yet.')
                : SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: booksByAuthor.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final book = booksByAuthor[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookDetailPage(
                                  book: book,
                                  wishlist: [],
                                  onAddToWishlist: (_) {},
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  book.imageUrl ?? '',
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 120,
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 120,
                                child: Text(
                                  book.title,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
