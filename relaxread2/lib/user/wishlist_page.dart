import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Book> wishlist = [
    Book(
      title: 'Calon Isteri Tuan Haider',
      author: 'Zati Mohd',
      imageUrl: 'https://placehold.co/80x120.png?text=Book+Cover',
      personalNote: 'A heartfelt romance with emotional depth.',
    ),
    Book(
      title: 'Bos Paling Romantik',
      author: 'Crystal Anabella',
      imageUrl: 'https://placehold.co/80x120.png?text=Bos+Romantik',
      personalNote: 'Enemies to lovers with teasing tension.',
    ),
  ];

  void deleteBook(int index) {
    setState(() {
      wishlist.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from wishlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
      child: wishlist.isEmpty
          ? const Center(
              child: Text(
                'Wishlist is empty at the moment 👀',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final book = wishlist[index];
                return WishlistCard(
                  book: book,
                  onConfirmDelete: () => deleteBook(index),
                );
              },
            ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Book book;
  final VoidCallback onConfirmDelete;

  const WishlistCard({
    super.key,
    required this.book,
    required this.onConfirmDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.imageUrl ?? '',
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.personalNote ?? '',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remove from Wishlist?'),
                    content: const Text(
                      'Are you sure you want to delete this book?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onConfirmDelete();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.redAccent),
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
    );
  }
}
