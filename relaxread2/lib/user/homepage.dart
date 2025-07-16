// home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:relaxread2/user/user_profile.dart';
import 'package:relaxread2/user/settings_page.dart';
import 'package:relaxread2/user/wishlist_page.dart'; // Assuming this is a separate page for wishlist
import 'package:relaxread2/user/book.dart';
import 'book_search.dart';
import 'book_detail_page.dart';
import 'package:relaxread2/theme_provider.dart';

class HomePage extends StatefulWidget {
  // Add final properties to store userName and userEmail
  final String userName;
  final String userEmail;

  const HomePage({
    Key? key,
    required this.userName, // Now correctly required and stored
    required this.userEmail, // Now correctly required and stored
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  int _selectedIndex = 0;

  final List<Book> featuredBooks = [
    Book(
      ebookId: '1',
      title: 'Calon Ister Tuan Haider',
      author: 'Zati Mohd',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+1',
      personalNote:
          'A heartfelt romance with emotional depth — where love, healing, and fatherhood intertwine unexpectedly.',
    ),
    Book(
      ebookId: '2',
      title: 'My Bae.. Tengku Fahd',
      author: 'Zati Mohd',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+2',
      personalNote:
          'A messy marriage of fate and heartbreak — when drama, exes, and secrets collide with unexpected love.',
    ),
    Book(
      ebookId: '3',
      title: 'Sekecewa Apa Pun Kau',
      author: 'Alyn',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+3',
      personalNote:
          'A bitter-sweet tale of betrayal and resilience — where love is tested, dignity is shattered, and healing becomes the hardest chapter.',
    ),
    Book(
      ebookId: '4',
      title: 'Bos Paling Romantik',
      author: 'Crystal Anabella',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+4',
      personalNote:
          'A playful enemies-to-lovers romance packed with teasing, tension, and one dangerously charming boss.',
    ),
  ];

  List<Widget> _widgetOptions(BuildContext context) => <Widget>[
    // 🏠 Tab 0 – Home
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Use widget.userName to display the passed user name
            'Hello ${widget.userName},',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium!.color, // Use theme text color
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'What would you like to read today?',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(
                context,
              ).textTheme.bodySmall!.color, // Use theme subtitle color
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for books, authors...',
              hintStyle: Theme.of(
                context,
              ).inputDecorationTheme.hintStyle, // Use theme hint style
              prefixIcon: const Icon(Icons.search, color: primaryGreen),
              filled: true,
              fillColor: Theme.of(
                context,
              ).cardColor, // Use theme card color for fill
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
            ), // Input text color
          ),
          const SizedBox(height: 30),
          Text(
            'Featured Books',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: loginPrimaryGreen, // This color might remain constant
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredBooks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, index) {
              final book = featuredBooks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).cardColor, // Use theme card color
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
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[800]
                                : Colors
                                      .grey[300], // Adjust placeholder based on theme
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
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color, // Use theme text color
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color, // Use theme subtitle color
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
    // ❤️ Tab 2 – Wishlist
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: featuredBooks.isEmpty
            ? [
                Center(
                  child: Text(
                    'Wishlist is empty at the moment 👀',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ), // Use theme text color
                  ),
                ),
              ]
            : featuredBooks.map((book) {
                return Card(
                  color: Theme.of(context).cardColor, // Use theme card color
                  child: ListTile(
                    title: Text(
                      book.title,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ), // Use theme text color
                    ),
                    subtitle: Text(
                      book.author,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall!.color,
                      ), // Use theme subtitle color
                    ),
                    leading: Image.network(
                      book.imageUrl ?? '',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 75,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors
                                  .grey[300], // Adjust placeholder based on theme
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
      ),
    ),

    const SettingsPage(), // Simply create an instance of SettingsPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(
          context,
        ).appBarTheme.backgroundColor, // Use theme app bar color
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
            ), // Use app bar foreground color for icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                    // Pass the actual userName and userEmail received by HomePage
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
        backgroundColor: Theme.of(context)
            .bottomNavigationBarTheme
            .backgroundColor, // Use theme background color
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
