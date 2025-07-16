import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart'; // Import the Book class
import 'book_detail_page.dart'; // Import the BookDetailPage

// Dummy globalEbooks list for demonstration purposes
// In your actual app, this would likely come from a data source or be defined globally elsewhere.
final List<Book> globalEbooks = [
  Book(
    ebookId: '1',
    title: 'The Silent Patient',
    author: 'Alex Michaelides',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91K2qS3oE3L.jpg',
    personalNote: 'A gripping psychological thriller.',
  ),
  Book(
    ebookId: '2',
    title: 'Where the Crawdads Sing',
    author: 'Delia Owens',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91L8S62L-4L.jpg',
    personalNote: 'A beautiful and haunting coming-of-age story.',
  ),
  Book(
    ebookId: '3',
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91tJ0Z0yGML.jpg',
    personalNote: 'Sci-fi at its best, full of humor and heart.',
  ),
  Book(
    ebookId: '4',
    title: 'The Midnight Library',
    author: 'Matt Haig',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91KxG0V2sNL.jpg',
    personalNote: 'A thought-provoking tale about choices and regrets.',
  ),
  Book(
    ebookId: '5',
    title: 'Dune',
    author: 'Frank Herbert',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/81ym3Qu7f3L.jpg',
    personalNote: 'A classic science fiction masterpiece.',
  ),
];

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Book> books = globalEbooks; // Use your global book list

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filters row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: theme
                          .cardColor, // Use theme's card color for dropdown background
                      hint: Text(
                        'All Genres',
                        style: TextStyle(
                          color: theme
                              .textTheme
                              .bodySmall!
                              .color, // Use theme's bodySmall color for hint
                        ),
                      ),
                      items:
                          <String>[
                            'All Genres',
                            'Fiction',
                            'Science',
                            'Fantasy',
                            'History',
                            'Biography',
                            'Mystery',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: theme
                                      .textTheme
                                      .bodyMedium!
                                      .color, // Use theme's bodyMedium color for item text
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        // Handle genre change
                      },
                      style: TextStyle(
                        color: theme
                            .textTheme
                            .bodyMedium!
                            .color, // Use theme's bodyMedium color for selected item text
                      ),
                      iconEnabledColor: theme
                          .iconTheme
                          .color, // Use theme's icon color for dropdown arrow
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      dropdownColor: theme
                          .cardColor, // Use theme's card color for dropdown background
                      hint: Text(
                        'All Ratings',
                        style: TextStyle(
                          color: theme
                              .textTheme
                              .bodySmall!
                              .color, // Use theme's bodySmall color for hint
                        ),
                      ),
                      items:
                          <String>[
                            'All Ratings',
                            '5 stars',
                            '4 stars & up',
                            '3 stars & up',
                            '2 stars & up',
                            '1 star & up',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: theme
                                      .textTheme
                                      .bodyMedium!
                                      .color, // Use theme's bodyMedium color for item text
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        // Handle rating change
                      },
                      style: TextStyle(
                        color: theme
                            .textTheme
                            .bodyMedium!
                            .color, // Use theme's bodyMedium color for selected item text
                      ),
                      iconEnabledColor: theme
                          .iconTheme
                          .color, // Use theme's icon color for dropdown arrow
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      dropdownColor: theme
                          .cardColor, // Use theme's card color for dropdown background
                      hint: Text(
                        'Sort by',
                        style: TextStyle(
                          color: theme
                              .textTheme
                              .bodySmall!
                              .color, // Use theme's bodySmall color for hint
                        ),
                      ),
                      items: <String>['Most Liked', 'Newest', 'Oldest'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: theme
                                  .textTheme
                                  .bodyMedium!
                                  .color, // Use theme's bodyMedium color for item text
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle sort change
                      },
                      style: TextStyle(
                        color: theme
                            .textTheme
                            .bodyMedium!
                            .color, // Use theme's bodyMedium color for selected item text
                      ),
                      iconEnabledColor: theme
                          .iconTheme
                          .color, // Use theme's icon color for dropdown arrow
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        // Apply filters
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            theme.primaryColor, // Use theme's primary color
                        // Using onPrimary from ColorScheme is often a good default for button text
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Results Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                  children: books.map((book) {
                    return BookCard(book: book); // Pass the Book object
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book; // Change to accept a Book object

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // Navigate to the BookDetailPage when tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailPage(book: book)),
        );
      },
      child: Card(
        color: theme.cardColor, // Apply theme's card color
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                book.imageUrl ?? '',
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  // Adjust placeholder based on theme brightness
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[300],
                  child: Center(
                    // Center the icon
                    child: Icon(
                      Icons.image_not_supported,
                      color: theme.iconTheme.color!.withOpacity(
                        0.5,
                      ), // Use theme's icon color with opacity
                    ),
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
                      color: theme
                          .textTheme
                          .bodyMedium!
                          .color, // Use theme's bodyMedium color
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme
                          .textTheme
                          .bodySmall!
                          .color, // Use theme's bodySmall color
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
  }
}
