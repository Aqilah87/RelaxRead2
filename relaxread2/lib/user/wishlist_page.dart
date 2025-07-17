import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart';
import 'package:relaxread2/user/book_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<Book>> _wishlistFuture;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _refreshWishlist();
  }

  Future<void> _refreshWishlist() {
    setState(() {
      _wishlistFuture = _fetchWishlist();
    });
    return _wishlistFuture;
  }

  Future<List<Book>> _fetchWishlist() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabase
          .from('user_wishlists')
          .select('''
            book_id,
            books:book_id (
              title,
              author,
              genre,
              description,
              image_url,
              page_number,
              month_published,
              year_published,
              publisher,
              ebook_id
            )
          ''')
          .eq('user_id', userId);

      // ✅ Log response for debugging
      print('Wishlist response: $response');

      // ✅ Make sure response is a non-empty list
      if (response.isEmpty) return [];

      return response.map<Book>((item) {
        final bookData = item['books'] as Map<String, dynamic>?;

        // ✅ Handle edge case: books block is missing
        if (bookData == null) {
          print('Missing book data for wishlist item: $item');
          return Book.fromMap({
            'title': 'Unknown',
            'author': '',
            'description': '',
            'genre': '',
            'image_url': '',
            'page_number': 0,
            'month_published': '',
            'year_published': '',
            'publisher': '',
            'ebook_id': '',
          });
        }

        return Book.fromMap({
          ...bookData,
          'ebook_id': bookData['ebook_id'] ?? bookData['id'],
        });
      }).toList();
    } catch (e) {
      print('Error fetching wishlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load wishlist: ${e.toString()}')),
      );
      return [];
    }
  }

  Future<void> _deleteBook(String bookId) async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase
          .from('user_wishlists')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);

      await _refreshWishlist();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Removed from wishlist')));
      }
    } catch (e) {
      print('Error deleting book: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  Future<void> _addDummyWishlistItems() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      // Selected 5 books from your list
      final dummyBooks = [
        {
          'book_id': '08e9eb7b-3998-43bd-9c09-8088b80f8003', // THANKS BOSS
          'user_id': userId,
        },
        {
          'book_id': '34bb99ec-e929-47db-bf91-d345d9bdf85a', // MY500K HUSBAND
          'user_id': userId,
        },
        {
          'book_id':
              '79caa916-63a9-4a66-af4f-65e4c5d9fc73', // HATI YANG TERPILIH
          'user_id': userId,
        },
        {
          'book_id':
              'c71f39b9-27fb-484d-a06a-af92cec0efa6', // EX SKANDAL SEBELAH RUMAH
          'user_id': userId,
        },
        {
          'book_id': 'fb6b0ab9-fc2e-44be-b1e3-289ed4d3f513', // TAKE CARE, TUAN
          'user_id': userId,
        },
      ];

      // Insert all dummy items
      await supabase.from('user_wishlists').insert(dummyBooks);

      // Refresh the wishlist
      await _refreshWishlist();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added 5 dummy books to wishlist')),
        );
      }
    } catch (e) {
      print('Error adding dummy books: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add dummy books: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.textTheme.titleLarge?.color,
        elevation: 0.5,
        actions: [],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWishlist,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Book>>(
              future: _wishlistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading wishlist',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshWishlist,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                final wishlist = snapshot.data ?? [];
                if (wishlist.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu_book,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your wishlist is empty',
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add books to your wishlist to see them here',
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _addDummyWishlistItems,
                          child: const Text('Add Wishlist Books'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    final book = wishlist[index];
                    return WishlistCard(
                      book: book,
                      currentWishlist: wishlist,
                      onDismissed: (direction) => _deleteBook(book.ebookId!),
                      isDeleting: _isDeleting,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class WishlistCard extends StatelessWidget {
  final Book book;
  final List<Book> currentWishlist;
  final ValueChanged<DismissDirection> onDismissed;
  final bool isDeleting;

  const WishlistCard({
    super.key,
    required this.book,
    required this.currentWishlist,
    required this.onDismissed,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final validImage = (book.imageUrl?.startsWith('http') ?? false)
        ? book.imageUrl!
        : 'https://via.placeholder.com/150x220.png?text=No+Image';

    return Dismissible(
      key: ValueKey(book.ebookId ?? '${book.title}_${book.author}'),
      direction: DismissDirection.endToStart,
      onDismissed: isDeleting ? null : onDismissed,
      confirmDismiss: isDeleting
          ? null
          : (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove from Wishlist?'),
                  content: Text('Remove "${book.title}" from your wishlist?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Remove',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },

      background: Container(
        color: Colors.red.shade700,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: AbsorbPointer(
        absorbing: isDeleting,
        child: Opacity(
          opacity: isDeleting ? 0.5 : 1.0,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailPage(
                      book: book,
                      onAddToWishlist: (_) {},
                      wishlist: currentWishlist,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        validImage,
                        width: 90,
                        height: 140,
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
                              color: theme.iconTheme.color?.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleMedium?.color,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            book.author,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (book.genre?.isNotEmpty ?? false)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'Genre: ${book.genre}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (book.rating != null)
                            Row(
                              children: [
                                ...List.generate(5, (index) {
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
                                    color: theme.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Text(
                            book.personalNote ??
                                'No additional information available.',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodyMedium?.color,
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
        ),
      ),
    );
  }
}
