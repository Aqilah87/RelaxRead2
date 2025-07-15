import 'package:flutter/material.dart';
import 'book.dart'; // reuse your Book class

class AuthorProfilePage extends StatelessWidget {
  final String authorName = 'Aisyah Rahman';
  final String profileImageUrl =
      'https://placehold.co/150x150.png?text=Aisyah'; // replace with actual

  final List<Book> booksByAuthor = [
    Book(
      title: 'Moonlit Love',
      author: 'Aisyah Rahman',
      imageUrl: 'https://placehold.co/120x180.png?text=Moonlit+Love',
      personalNote: '',
    ),
    Book(
      title: 'The Wedding Promise',
      author: 'Aisyah Rahman',
      imageUrl: 'https://placehold.co/120x180.png?text=Wedding+Promise',
      personalNote: '',
    ),
    Book(
      title: 'Echoes of the Past',
      author: 'Aisyah Rahman',
      imageUrl: 'https://placehold.co/120x180.png?text=Echoes+Past',
      personalNote: '',
    ),
  ];

  AuthorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        title: const Text('Author Profile'),
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
              backgroundImage: NetworkImage(profileImageUrl),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Followed!')));
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
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: booksByAuthor.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final book = booksByAuthor[index];
                  return Column(
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
