// home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relaxread2/user/user_profile.dart';
import 'package:relaxread2/user/settings_page.dart';
import 'package:relaxread2/user/wishlist_page.dart';
import 'package:relaxread2/user/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:relaxread2/services/supabase_service.dart'; // Add this import for the Supabase service
import 'book_search.dart';
import 'book_detail_page.dart';
import 'package:relaxread2/theme_provider.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const HomePage({Key? key, required this.userName, required this.userEmail})
    : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  int _selectedIndex = 0;
  final List<Book> _userWishlist = [];

  // Initialize SupabaseService to fetch data
  final SupabaseService _supabaseService = SupabaseService();
  List<Book> _featuredBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFeaturedBooks();
  }

  Future<void> _fetchFeaturedBooks() async {
    try {
      final books = await _supabaseService.fetchBooks();
      setState(() {
        _featuredBooks = books;
        _isLoading = false;
      });
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching featured books: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Widget> _widgetOptions(BuildContext context) => <Widget>[
    // 🏠 Tab 0 – Home
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello ${widget.userName},',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'What would you like to read today?',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for books, authors...',
              hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
              prefixIcon: const Icon(Icons.search, color: primaryGreen),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: Theme.of(context).inputDecorationTheme.border,
              focusedBorder: Theme.of(
                context,
              ).inputDecorationTheme.focusedBorder,
              contentPadding: Theme.of(
                context,
              ).inputDecorationTheme.contentPadding,
            ),
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Featured Books',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: loginPrimaryGreen,
            ),
          ),
          const SizedBox(height: 15),
          // Check for loading state or no data
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: loginPrimaryGreen),
            )
          else if (_featuredBooks.isEmpty)
            const Center(child: Text('No featured books available.'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _featuredBooks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final book = _featuredBooks[index];
                return GestureDetector(
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
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12.0),
                          ),
                          child: Image.network(
                            book.imageUrl ?? '',
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 150,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.color,
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
              },
            ),
        ],
      ),
    ),

    // 📚 Tab 1 – Book Search
    const BookSearchPage(),

    // ❤️ Tab 2 – Wishlist - Now directly uses the WishlistPage
    const WishlistPage(),
    // ⚙️ Tab 3 – Settings
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1.0,
        title: Row(
          children: [
            const Icon(Icons.menu_book, color: primaryGreen, size: 28),
            const SizedBox(width: 8),
            Text(
              'RelaxRead',
              style: TextStyle(
                color: loginPrimaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    userName: widget.userName,
                    userEmail: widget.userEmail,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions(context).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor: Theme.of(
          context,
        ).bottomNavigationBarTheme.unselectedItemColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
