import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:relaxread2/user/user_profile.dart';
import 'package:relaxread2/user/settings_page.dart';
import 'package:relaxread2/user/wishlist_page.dart';
import 'package:relaxread2/user/book.dart';
import '../theme_provider.dart'; // Ensure this path is correct for ThemeProvider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      title: 'Calon Isteri Tuan Haider',
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

  List<Widget> _widgetOptions(BuildContext context, bool isDarkMode) {
    // Define colors for the widgets based on the theme mode
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color? lightTextColor = isDarkMode
        ? Colors.grey[400]
        : Colors.grey[600];
    final Color headingColor = isDarkMode ? primaryGreen : loginPrimaryGreen;
    final Color searchFieldFillColor = isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;
    final Color cardBackgroundColor = isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;

    return <Widget>[
      // 🏠 Tab 0 – Home
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Reader,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textColor, // Dynamic text color
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'What would you like to read today?',
              style: TextStyle(
                fontSize: 18,
                color: lightTextColor,
              ), // Dynamic text color
            ),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for books, authors...',
                prefixIcon: Icon(Icons.search, color: primaryGreen),
                filled: true,
                fillColor: searchFieldFillColor, // Dynamic fill color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: primaryGreen, width: 2.0),
                ),
                hintStyle: TextStyle(
                  color: lightTextColor,
                ), // Dynamic hint text color
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 20.0,
                ),
              ),
              style: TextStyle(color: textColor), // Dynamic input text color
            ),
            const SizedBox(height: 30),
            Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: headingColor, // Dynamic heading color
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  final categories = [
                    'Fiction',
                    'Science',
                    'Fantasy',
                    'History',
                    'Biography',
                    'Mystery',
                  ];
                  final categoryIcons = [
                    Icons.book,
                    Icons.science,
                    Icons.auto_stories,
                    Icons.history_edu,
                    Icons.person,
                    Icons.search_sharp,
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 2.0,
                          color: cardBackgroundColor, // Dynamic card color
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Category tapped!'),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    cardBackgroundColor, // Dynamic container color
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Icon(
                                categoryIcons[index],
                                color: primaryGreen,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: lightTextColor,
                          ), // Dynamic text color
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Featured Books',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: headingColor, // Dynamic heading color
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
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3.0,
                  color: cardBackgroundColor, // Dynamic card color
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tapped on "${book.title}"')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12.0),
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
                              color: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors
                                        .grey[300], // Dynamic error placeholder color
                              child: Icon(
                                Icons.image_not_supported,
                                color: isDarkMode
                                    ? Colors.grey[600]
                                    : Colors.grey, // Dynamic icon color
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
                                  color: textColor, // Dynamic text color
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: lightTextColor, // Dynamic text color
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
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Discover More pressed!')),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Discover More'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),

      // 📚 Tab 1 – Library
      Center(
        child: Text(
          'Library tab placeholder',
          style: TextStyle(color: textColor),
        ),
      ),

      // ❤️ Tab 2 – Wishlist
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: featuredBooks.isEmpty
              ? [
                  Center(
                    child: Text(
                      'Wishlist is empty at the moment 👀',
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ]
              : featuredBooks.map((book) {
                  return WishlistCard(
                    book: book,
                    onConfirmDelete: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor:
                              cardBackgroundColor, // Dynamic dialog background
                          title: Text(
                            'Remove from Wishlist?',
                            style: TextStyle(color: headingColor),
                          ), // Dynamic title color
                          content: Text(
                            'Are you sure you want to delete this book?',
                            style: TextStyle(color: textColor),
                          ), // Dynamic content color
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: primaryGreen),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  featuredBooks.remove(book);
                                });
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Book removed from wishlist'),
                                  ),
                                );
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
                  );
                }).toList(),
        ),
      ),

      // ⚙️ Tab 3 – Settings
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final snackBarMessages = [
      'Home tapped!',
      'Library tapped!',
      'Wishlist tapped!',
      'Settings tapped!',
    ];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(snackBarMessages[index])));
  }

  @override
  Widget build(BuildContext context) {
    // Access ThemeProvider to get the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the current theme mode
    final Color appBarColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final Color scaffoldBackgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF0F2EB);
    final Color appBarTitleColor = isDarkMode
        ? primaryGreen
        : loginPrimaryGreen;
    final Color appBarIconColor = isDarkMode
        ? Colors.white70
        : loginPrimaryGreen;
    final Color bottomNavBarBackgroundColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final Color bottomNavBarSelectedItemColor = isDarkMode
        ? Colors.lightGreenAccent
        : loginPrimaryGreen;
    final Color bottomNavBarUnselectedItemColor = isDarkMode
        ? Colors.grey[600]!
        : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // Dynamic background color
      appBar: AppBar(
        automaticallyImplyLeading: false, // This line removes the back arrow
        backgroundColor: appBarColor, // Dynamic app bar background
        elevation: 1.0,
        title: Row(
          children: [
            Icon(Icons.menu_book, color: primaryGreen, size: 28),
            const SizedBox(width: 8),
            Text(
              'RelaxRead',
              style: TextStyle(
                color: appBarTitleColor, // Dynamic app bar title color
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: appBarIconColor,
            ), // Dynamic icon color
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search button pressed!')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: appBarIconColor,
            ), // Dynamic icon color
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Profile!')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(
                    userName: 'Current User',
                    userEmail: 'current.user@example.com',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions(context, isDarkMode).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            bottomNavBarBackgroundColor, // Dynamic bottom nav bar background
        selectedItemColor:
            bottomNavBarSelectedItemColor, // Dynamic selected icon color
        unselectedItemColor:
            bottomNavBarUnselectedItemColor, // Dynamic unselected icon color
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
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
