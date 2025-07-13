import 'package:flutter/material.dart';
import 'user_profile.dart'; // Import the new user profile page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Define the primary green color, consistent with Create Account screen
  static const Color primaryGreen = Color(0xFF6B923C);
  // Define a slightly darker green for accents, consistent with Login page
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
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

            // Search Bar (more prominent)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for books, authors...',
                prefixIcon: Icon(Icons.search, color: primaryGreen),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none, // No border for a cleaner look
                ),
                enabledBorder: OutlineInputBorder(
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

            // Categories Section
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
              height: 100, // Fixed height for horizontal category list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Example number of categories
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
                            // Makes the card tappable
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Category tapped!'),
                                ),
                              );
                              // Navigate to category specific page
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Featured Books Section
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
              shrinkWrap: true, // Take only necessary space
              physics:
                  const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 16.0, // Spacing between columns
                mainAxisSpacing: 16.0, // Spacing between rows
                childAspectRatio:
                    0.7, // Aspect ratio for book cards (height relative to width)
              ),
              itemCount: 4, // Example number of featured books
              itemBuilder: (context, index) {
                // Placeholder book data
                final bookTitles = [
                  'The Silent Patient',
                  'Where the Crawdads Sing',
                  'Project Hail Mary',
                  'Atomic Habits',
                ];
                final bookAuthors = [
                  'Alex Michaelides',
                  'Delia Owens',
                  'Andy Weir',
                  'James Clear',
                ];
                final bookCoverPlaceholders = [
                  'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+1',
                  'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+2',
                  'https://placehold.co/150x220/6B923C/FFFFFF?text=Book+3',
                  'https://placehold.co/150x220/5A7F30/FFFFFF?text=Book+4',
                ];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 3.0,
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped on "${bookTitles[index]}"'),
                        ),
                      );
                      // Navigate to book details page
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
                            bookCoverPlaceholders[index],
                            height: 150, // Fixed height for book cover
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[600],
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
                                bookTitles[index],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                bookAuthors[index],
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
            const SizedBox(height: 30),

            // Call to Action / Discover More
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Discover More pressed!')),
                  );
                  // Navigate to a broader book discovery page
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
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          // Handle navigation based on index
          final snackBarMessages = [
            'Home tapped!',
            'Library tapped!',
            'Saved tapped!',
            'Settings tapped!',
          ];
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snackBarMessages[index])));
        },
      ),
    );
  }
}
