// lib/user/wishlist_page.dart (or your actual path)
import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart'; // Import the book.dart file with globalWishlist
import 'package:relaxread2/user/book_detail_page.dart'; // Import the BookDetailPage

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  void _deleteBook(String ebookId) {
    // Find the index of the book to delete by its ebookId in the global list
    final index = globalWishlist.indexWhere((book) => book.ebookId == ebookId);
    if (index != -1) {
      setState(() {
        globalWishlist.removeAt(index); // Remove from the global list
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
      debugPrint(
        'Book with ID $ebookId deleted. Current global wishlist length: ${globalWishlist.length}',
      );
    } else {
      debugPrint('Attempted to delete book with non-existent ID: $ebookId');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'WishlistPage build: current global wishlist length = ${globalWishlist.length}',
    );

    final theme = Theme.of(context); // Get current theme

    return Scaffold(
      backgroundColor: theme
          .scaffoldBackgroundColor, // Ensure background color matches theme
      // AppBar removed entirely
      body: SafeArea(
        // Use SafeArea to avoid content overlapping status bar
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: globalWishlist.isEmpty
              ? Center(
                  child: Text(
                    'Wishlist is empty at the moment 👀',
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.textTheme.bodySmall!.color,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: globalWishlist.length,
                  itemBuilder: (context, index) {
                    final book = globalWishlist[index];
                    return WishlistCard(
                      book: book,
                      onDismissed: (direction) => _deleteBook(book.ebookId),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Book book;
  final ValueChanged<DismissDirection> onDismissed;

  const WishlistCard({
    super.key,
    required this.book,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if imageUrl is null or not a valid HTTP/HTTPS URL
    final validImage = book.imageUrl?.startsWith('http') == true
        ? book.imageUrl!
        : 'https://via.placeholder.com/150x220.png?text=No+Image';

    return Dismissible(
      key: ValueKey(book.ebookId), // Using ebookId for a unique key
      direction:
          DismissDirection.endToStart, // Swipe from right to left to dismiss
      onDismissed: onDismissed,
      background: Container(
        color: Colors.red.shade700, // Darker red for delete background
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.dialogBackgroundColor,
            title: Text(
              'Remove from Wishlist?',
              style: TextStyle(color: theme.textTheme.titleMedium!.color),
            ),
            content: Text(
              'Are you sure you want to remove "${book.title}" from your wishlist?',
              style: TextStyle(color: theme.textTheme.bodyMedium!.color),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), // User cancels
                child: Text(
                  'Cancel',
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // User confirms deletion
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
      child: InkWell(
        // Added InkWell for tap functionality and visual feedback
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailPage(
                book: book,
                onAddToWishlist: (Book) {},
                wishlist: [],
              ),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: theme.cardColor, // Use theme's card color
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    validImage,
                    width: 90, // Slightly increased width
                    height:
                        140, // Slightly increased height for better aspect ratio
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 140,
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: theme.iconTheme.color!.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Increased spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 17, // Slightly larger font
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleMedium!.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6), // Increased spacing
                      Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodySmall!.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Genre and Rating Display
                      if (book.genre != null && book.genre!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Genre: ${book.genre}',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall!.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (book.rating != null)
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              // Full star if index < rating (integer part)
                              // Half star if index is the integer part and rating has a decimal >= 0.5
                              // Empty star otherwise
                              return Icon(
                                index < book.rating!.floor()
                                    ? Icons.star
                                    : (index == book.rating!.floor() &&
                                          (book.rating! -
                                                  book.rating!.floor()) >=
                                              0.5)
                                    ? Icons.star_half_outlined
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 16,
                              );
                            }),
                            const SizedBox(width: 4),
                            Text(
                              book.rating!.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall!.color,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Text(
                        book.personalNote ?? 'No description available.',
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium!.color,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
