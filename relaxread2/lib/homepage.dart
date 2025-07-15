import 'package:flutter/material.dart';
import 'user_profile.dart'; // Import the user profile page
import 'settings_page.dart'; // Import the new settings page
import 'wishlist_page.dart' as wishlist;
import 'book.dart';
import 'wishlist_page.dart';
import 'package:relaxread2/book.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  int _selectedIndex = 0; 

  // ✅ ⬇️ Paste this method right here!
  Widget buildHomeTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // your home layout here...
        ],
      ),
    );
  }

  // Dummy book list for Wishlist
  final List<Book> featuredBooks = [
    Book(
      title: 'The Silent Patient',
      author: 'Alex Michaelides',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+1',
      personalNote: 'Psychological thriller with suspense!',
    ),
    Book(
      title: 'Where the Crawdads Sing',
      author: 'Delia Owens',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+2',
      personalNote: 'Nature and mystery beautifully combined.',
    ),
    Book(
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      imageUrl: 'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+3',
      personalNote: 'Sci-fi brilliance from “The Martian” author 🚀',
    ),
    Book(
      title: 'Atomic Habits',
      author: 'James Clear',
      imageUrl: 'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+4',
      personalNote: 'Simple strategies to change your life 🧠',
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
            'Explore Categories',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: loginPrimaryGreen,
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
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Category tapped!')),
                            );
                          },
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            width: 60,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
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
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 3.0,
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
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                        child: Image.network(
                          book.imageUrl,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, color: Colors.grey),
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
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                elevation: 2,
              ),
            ),
          ),
        ],
      ),
    ),

    // 📚 Tab 1 – Library
    const Center(child: Text('Library tab placeholder')),

    // ❤️ Tab 2 – Wishlist
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: Column(
        children: featuredBooks.isEmpty
          ? [const Center(child: Text('Wishlist is empty at the moment 👀'))]
          : featuredBooks.map((book) => WishlistCard(book: book)).toList(),
      ),
    ),

    // ⚙️ Tab 3 – Settings
    const SettingsPage(),
  ];

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(snackBarMessages[index])),
    );
  } // <-- Corrected closing bracket for _onItemTapped

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F2EB,
      ), // Light background for the whole page
      appBar: AppBar(
        backgroundColor: Colors.white, // White app bar for a clean look
        elevation: 1.0, // Subtle shadow under the app bar
        title: Row(
          children: [
            Icon(Icons.menu_book, color: primaryGreen, size: 28), // Book icon
            const SizedBox(width: 8),
            Text(
              'RelaxRead', // Changed title to RelaxRead as per your code
              style: TextStyle(
                color: loginPrimaryGreen, // Use the darker green for title
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search button pressed!')),
              );
              // Implement search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: loginPrimaryGreen),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigating to Profile!')),
              );
              // Navigate to the UserProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions(
        context,
      ).elementAt(_selectedIndex), // Display the selected widget from the list
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: loginPrimaryGreen, // Selected icon color
        unselectedItemColor: Colors.grey[600], // Unselected icon color
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
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
            icon: Icon(Icons.settings), // The settings icon
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex, // Highlight the currently selected tab
        onTap: _onItemTapped, 

      ),
    );
  }

}
