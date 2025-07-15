import 'package:flutter/material.dart';
import 'package:relaxread2/user/user_profile.dart'; // Import user profile page
import 'package:relaxread2/user/settings_page.dart'; // Import settings page
import 'package:relaxread2/user/wishlist_page.dart'; // Import wishlist page
import 'package:relaxread2/user/book.dart'; // Import the Book class
import 'book_search.dart'; // Import the BookSearchPage
import 'book_detail_page.dart'; // Import the BookDetailPage

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  int _selectedIndex = 0;

  // Dummy book list for Wishlist and Featured Books
  final List<Book> featuredBooks = [
    Book(
      ebookId: '1',
      title: 'Calon Ister Tuan Haider',
      author: 'Zati Mohd',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+1',
      personalNote: 'A heartfelt romance with emotional depth — where love, healing, and fatherhood intertwine unexpectedly.',
    ),
    Book(
      ebookId: '2',
      title: 'My Bae.. Tengku Fahd',
      author: 'Zati Mohd',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+2',
      personalNote: 'A messy marriage of fate and heartbreak — when drama, exes, and secrets collide with unexpected love.',
    ),
    Book(
      ebookId: '3',
      title: 'Sekecewa Apa Pun Kau',
      author: 'Alyn',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+3',
      personalNote: 'A bitter-sweet tale of betrayal and resilience — where love is tested, dignity is shattered, and healing becomes the hardest chapter.',
    ),
    Book(
      ebookId: '4',
      title: 'Bos Paling Romantik',
      author: 'Crystal Anabella',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+4',
      personalNote: 'A playful enemies-to-lovers romance packed with teasing, tension, and one dangerously charming boss.',
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
            'Hello Reader,',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'What would you like to read today?',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 30),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for books, authors...',
              prefixIcon: Icon(Icons.search, color: primaryGreen),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: primaryGreen, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
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
                  // Navigate to the BookDetailPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailPage(book: book),
                    ),
                  );
                },
                child: Card(
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
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
    const BookSearchPage(), // Add the BookSearchPage here

    // ❤️ Tab 2 – Wishlist
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: featuredBooks.isEmpty
            ? [const Center(child: Text('Wishlist is empty at the moment 👀'))]
            : featuredBooks.map((book) {
                return Card(
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text(book.author),
                    leading: Image.network(
                      book.imageUrl ?? '',
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      // Navigate to the BookDetailPage
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
      backgroundColor: const Color(0xFFF0F2EB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Row(
          children: [
            Icon(Icons.menu_book, color: primaryGreen, size: 28),
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
            icon: Icon(Icons.search, color: loginPrimaryGreen),
            onPressed: () {
              // Navigate to the BookSearchPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookSearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: loginPrimaryGreen),
            onPressed: () {
              // Navigate to the UserProfilePage
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
      body: _widgetOptions(context).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: loginPrimaryGreen,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}