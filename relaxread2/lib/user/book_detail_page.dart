  import 'package:flutter/material.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
  import 'book.dart';
  import 'wishlist_page.dart';
  import 'package:relaxread2/user/authorProfile.dart';

  class BookDetailPage extends StatefulWidget {
    final Book book;
    final Function(Book) onAddToWishlist;
    final List<Book> wishlist;

    const BookDetailPage({
      Key? key,
      required this.book,
      required this.onAddToWishlist,
      required this.wishlist,
    }) : super(key: key);

    @override
    State<BookDetailPage> createState() => _BookDetailPageState();
  }

  class _BookDetailPageState extends State<BookDetailPage> {
    final TextEditingController _commentController = TextEditingController();
    bool _isAddedToWishlist = false;
    int _userRating = 0;

    final List<Map<String, dynamic>> _comments = [];

    @override
    void initState() {
      super.initState();
      _checkIfAlreadyInWishlist();
    }

    void _checkIfAlreadyInWishlist() {
      _isAddedToWishlist = widget.wishlist.any(
        (b) => b.ebookId == widget.book.ebookId,
      );
    }

    Future<void> _handleAddToWishlist() async {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to use wishlist')),
        );
        return;
      }

      try {
        final existing = await Supabase.instance.client
            .from('wishlist')
            .select()
            .eq('user_id', user.id)
            .eq('book_id', widget.book.ebookId)
            .maybeSingle();

        if (existing != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.book.title} is already in your wishlist')),
          );
          return;
        }

        await Supabase.instance.client.from('wishlist').insert({
          'user_id': user.id,
          'book_id': widget.book.ebookId,
        });

        setState(() {
          _isAddedToWishlist = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.book.title} added to wishlist')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to wishlist: $e')),
        );
      }
    }

    void _submitComment() {
      final commentText = _commentController.text.trim();

      if (_userRating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a rating')),
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment added')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment cannot be empty')),
        );
      }
    }

    @override
    void dispose() {
      _commentController.dispose();
      super.dispose();
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
                  MaterialPageRoute(
                    builder: (context) => AuthorProfilePage(
                      authorName: widget.book.author,
                      profileImageUrl: 'https://placehold.co/150x150.png?text=${widget.book.author}', // or your own image
                      booksByAuthor: [], // 🔧 Ideally filtered from all books
                    ),
                  ),
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
              '${widget.book.publisher ?? 'Unknown Publisher'}, ${widget.book.monthPublish ?? ''} ${widget.book.yearPublisher ?? ''}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            // 📝 Description (Updated to use the 'description' field)
            const SizedBox(height: 16.0),
            Text(
              widget.book.description ?? 'No description available.',
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
                onPressed: _isAddedToWishlist
                    ? null
                    : () {
                        setState(() {
                          _isAddedToWishlist = true;
                        });
                        if (!widget.wishlist.any(
                          (b) =>
                              b.title == widget.book.title &&
                              b.author == widget.book.author,
                        )) {
                          widget.onAddToWishlist(widget.book);
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.book.title} added to Wishlist!',
                            ),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishlistPage(),
                          ),
                        );
                      },
                icon: _isAddedToWishlist
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
                label: Text(
                  _isAddedToWishlist ? 'Added to Wishlist' : 'Add to Wishlist',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAddedToWishlist
                      ? Colors.grey
                      : const Color(0xFF6B923C),
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
