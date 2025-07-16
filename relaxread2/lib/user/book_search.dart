import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart'; // Import the Book class
import 'book_detail_page.dart'; // Import the BookDetailPage

// Make sure your book.dart has 'String? genre;' and 'double? rating;'
// properties in the Book class and that your globalEbooks are populated with them.
// (As per our previous interaction where you updated book.dart)

// Dummy globalEbooks list for demonstration purposes
// This should match the updated globalEbooks in your actual book.dart file
final List<Book> globalEbooks = [
  Book(
    ebookId: '1',
    title: 'The Silent Patient',
    author: 'Alex Michaelides',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91K2qS3oE3L.jpg',
    personalNote: 'A gripping psychological thriller.',
    genre: 'Mystery',
    rating: 4.1,
    publisher: 'Celadon Books',
    month_publish: 'Feb',
    yearPublisher: '2019',
  ),
  Book(
    ebookId: '2',
    title: 'Where the Crawdads Sing',
    author: 'Delia Owens',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91L8S62L-4L.jpg',
    personalNote: 'A beautiful and haunting coming-of-age story.',
    genre: 'Fiction',
    rating: 4.6,
    publisher: 'G.P. Putnam\'s Sons',
    month_publish: 'Aug',
    yearPublisher: '2018',
  ),
  Book(
    ebookId: '3',
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91tJ0Z0yGML.jpg',
    personalNote: 'Sci-fi at its best, full of humor and heart.',
    genre: 'Science Fiction',
    rating: 4.9,
    publisher: 'Ballantine Books',
    month_publish: 'May',
    yearPublisher: '2021',
  ),
  Book(
    ebookId: '4',
    title: 'The Midnight Library',
    author: 'Matt Haig',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/91KxG0V2sNL.jpg',
    personalNote: 'A thought-provoking tale about choices and regrets.',
    genre: 'Fantasy',
    rating: 4.3,
    publisher: 'Viking',
    month_publish: 'Sep',
    yearPublisher: '2020',
  ),
  Book(
    ebookId: '5',
    title: 'Dune',
    author: 'Frank Herbert',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/81ym3Qu7f3L.jpg',
    personalNote: 'A classic science fiction masterpiece.',
    genre: 'Science Fiction',
    rating: 4.7,
    publisher: 'Chilton Books',
    month_publish: 'Aug',
    yearPublisher: '1965',
  ),
  Book(
    ebookId: '6',
    title: 'Sapiens: A Brief History of Humankind',
    author: 'Yuval Noah Harari',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/71R2W3c-W6L.jpg',
    personalNote: 'An eye-opening look at human history.',
    genre: 'History',
    rating: 4.5,
    publisher: 'Harper',
    month_publish: 'Feb',
    yearPublisher: '2015',
  ),
  Book(
    ebookId: '7',
    title: 'Educated',
    author: 'Tara Westover',
    imageUrl:
        'https://images-na.ssl-images-amazon.com/images/I/71x5bA-FpML.jpg',
    personalNote: 'A powerful memoir of self-invention.',
    genre: 'Biography',
    rating: 4.4,
    publisher: 'Random House',
    month_publish: 'Feb',
    yearPublisher: '2018',
  ),
  Book(
    ebookId: '8',
    title: 'The Great Flutter Adventure',
    author: 'Dart Vader',
    imageUrl:
        'https://placehold.co/100x150/6B923C/ffffff?text=Flutter', // Placeholder
    personalNote: 'An exciting journey into Flutter development.',
    genre: 'Programming',
    rating: 4.5,
    publisher: 'Tech Books Inc.',
    month_publish: 'Jan',
    yearPublisher: '2023',
  ),
  Book(
    ebookId: '9',
    title: 'Supabase for Beginners',
    author: 'Post Gres',
    imageUrl:
        'https://placehold.co/100x150/5A7F30/ffffff?text=Supabase', // Placeholder
    personalNote: 'Learn the basics of backend with Supabase.',
    genre: 'Programming',
    rating: 4.8,
    publisher: 'Database Press',
    month_publish: 'Apr',
    yearPublisher: '2024',
  ),
  Book(
    ebookId: '10',
    title: 'Widgets Masterclass',
    author: 'U.I. Expert',
    imageUrl:
        'https://placehold.co/100x150/3C6B92/ffffff?text=Widgets', // Placeholder
    personalNote: 'Deep dive into Flutter widgets.',
    genre: 'Programming',
    rating: 4.2,
    publisher: 'UI Publishers',
    month_publish: 'Jul',
    yearPublisher: '2023',
  ),
  Book(
    ebookId: '11',
    title: 'Beyond the Basics: Dart',
    author: 'Lang Witch',
    imageUrl:
        'https://placehold.co/100x150/923C6B/ffffff?text=Dart', // Placeholder
    personalNote: 'Advanced Dart programming concepts.',
    genre: 'Programming',
    rating: 4.7,
    publisher: 'Code Central',
    month_publish: 'Mar',
    yearPublisher: '2024',
  ),
];

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({Key? key}) : super(key: key);

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  String _searchQuery = '';
  String? _selectedGenre;
  String? _selectedRating;
  String? _selectedSortBy;

  List<Book> _filteredBooks = [];

  // Define available genres and rating thresholds for logic
  final List<String> _availableGenres = [
    'All Genres',
    'Fiction',
    'Science',
    'Fantasy',
    'History',
    'Biography',
    'Mystery',
    'Programming',
    'Science Fiction',
  ];

  final Map<String, double> _ratingThresholds = {
    'All Ratings': 0.0,
    '4.5 stars & up': 4.5,
    '4 stars & up': 4.0,
    '3 stars & up': 3.0,
  };

  @override
  void initState() {
    super.initState();
    _applyFilters(); // Initialize with all books and apply any default sorting
  }

  void _applyFilters() {
    setState(() {
      // 1. Start with all books
      List<Book> currentBooks = List.from(
        globalEbooks,
      ); // Create a mutable copy

      // 2. Apply Search Filter
      if (_searchQuery.isNotEmpty) {
        currentBooks = currentBooks.where((book) {
          return book.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              book.author.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }

      // 3. Apply Genre Filter
      if (_selectedGenre != null && _selectedGenre != 'All Genres') {
        currentBooks = currentBooks.where((book) {
          return book.genre != null &&
              book.genre!.toLowerCase() == _selectedGenre!.toLowerCase();
        }).toList();
      }

      // 4. Apply Rating Filter
      if (_selectedRating != null && _selectedRating != 'All Ratings') {
        final double minRating = _ratingThresholds[_selectedRating] ?? 0.0;
        currentBooks = currentBooks.where((book) {
          return book.rating != null && book.rating! >= minRating;
        }).toList();
      }

      // 5. Apply Sorting
      if (_selectedSortBy != null) {
        currentBooks.sort((a, b) {
          switch (_selectedSortBy) {
            case 'Most Liked':
              // Books with higher ratings come first (descending)
              if (a.rating == null && b.rating == null) return 0;
              if (a.rating == null) return 1; // Nulls last
              if (b.rating == null) return -1; // Nulls last
              return b.rating!.compareTo(a.rating!);
            case 'Newest':
              // Sort by yearPublisher (descending) then month_publish (descending)
              final int yearA = int.tryParse(a.yearPublisher ?? '0') ?? 0;
              final int yearB = int.tryParse(b.yearPublisher ?? '0') ?? 0;
              int yearCompare = yearB.compareTo(yearA);
              if (yearCompare != 0) return yearCompare;

              final Map<String, int> monthOrder = {
                'Jan': 1,
                'Feb': 2,
                'Mar': 3,
                'Apr': 4,
                'May': 5,
                'Jun': 6,
                'Jul': 7,
                'Aug': 8,
                'Sep': 9,
                'Oct': 10,
                'Nov': 11,
                'Dec': 12,
              };
              final int monthA = monthOrder[a.month_publish ?? ''] ?? 0;
              final int monthB = monthOrder[b.month_publish ?? ''] ?? 0;
              return monthB.compareTo(monthA);

            case 'Oldest':
              // Sort by yearPublisher (ascending) then month_publish (ascending)
              final int yearA = int.tryParse(a.yearPublisher ?? '0') ?? 0;
              final int yearB = int.tryParse(b.yearPublisher ?? '0') ?? 0;
              int yearCompare = yearA.compareTo(yearB);
              if (yearCompare != 0) return yearCompare;

              final Map<String, int> monthOrder = {
                'Jan': 1,
                'Feb': 2,
                'Mar': 3,
                'Apr': 4,
                'May': 5,
                'Jun': 6,
                'Jul': 7,
                'Aug': 8,
                'Sep': 9,
                'Oct': 10,
                'Nov': 11,
                'Dec': 12,
              };
              final int monthA = monthOrder[a.month_publish ?? ''] ?? 0;
              final int monthB = monthOrder[b.month_publish ?? ''] ?? 0;
              return monthA.compareTo(monthB);

            default:
              return 0; // No specific sort
          }
        });
      }

      _filteredBooks = currentBooks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar at the top
              TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _applyFilters(); // Apply filter as typing
                },
                style: TextStyle(color: theme.textTheme.bodyMedium!.color),
                decoration: InputDecoration(
                  hintText: 'Search by title or author...',
                  hintStyle: TextStyle(color: theme.hintColor),
                  prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: theme.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                ),
              ),

              const SizedBox(height: 16.0),

              // Filters row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Genre Filter
                    _buildFilterDropdown(
                      context,
                      _selectedGenre,
                      _availableGenres,
                      'All Genres',
                      (value) {
                        setState(() {
                          _selectedGenre = value;
                        });
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 12),
                    // Rating Filter
                    _buildFilterDropdown(
                      context,
                      _selectedRating,
                      _ratingThresholds.keys.toList(),
                      'All Ratings',
                      (value) {
                        setState(() {
                          _selectedRating = value;
                        });
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 12),
                    // Sort By Filter
                    _buildFilterDropdown(
                      context,
                      _selectedSortBy,
                      <String>['Most Liked', 'Newest', 'Oldest'],
                      'Sort by',
                      (value) {
                        setState(() {
                          _selectedSortBy = value;
                        });
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16.0),

              // Results Grid
              Expanded(
                child: _filteredBooks.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty &&
                                  _selectedGenre == null &&
                                  _selectedRating == null
                              ? 'No books available.' // Initial state with no filters
                              : 'No matching books found for your criteria.', // After filters applied
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium!.color,
                          ),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                        children: _filteredBooks.map((book) {
                          return BookCard(book: book);
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context,
    String? currentValue,
    List<String> items,
    String hintText,
    ValueChanged<String?> onChanged,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          dropdownColor: theme.cardColor,
          hint: Text(
            hintText,
            style: TextStyle(
              color: theme.textTheme.bodySmall!.color,
              fontSize: 14,
            ),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value == hintText
                  ? null
                  : value, // Set null for "All" options
              child: Text(
                value,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium!.color,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          style: TextStyle(color: theme.textTheme.bodyMedium!.color),
          iconEnabledColor: theme.iconTheme.color,
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        color: theme.cardColor,
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
                      color: theme.textTheme.bodyMedium!.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall!.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Display genre and rating if available
                  if (book.genre != null && book.genre!.isNotEmpty)
                    Text(
                      'Genre: ${book.genre}',
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.textTheme.bodySmall!.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (book.rating != null)
                    Row(
                      children: [
                        Icon(Icons.star, size: 12, color: Colors.amber),
                        Text(
                          ' ${book.rating!.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: theme.textTheme.bodySmall!.color,
                          ),
                        ),
                      ],
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
