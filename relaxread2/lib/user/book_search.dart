// lib/book_search_page.dart
import 'package:flutter/material.dart';
import 'package:relaxread2/user/book.dart';
import 'package:relaxread2/services/supabase_service.dart';
import 'book_detail_page.dart';

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
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];

  final List<String> _availableGenres = [
    'All Genres',
    'Fiction',
    'Fantasy',
    'Biography',
    'Mystery',
    'Romance',
    ' Thriller',
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
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await SupabaseService().fetchBooks();
    setState(() {
      _allBooks = books;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Book> currentBooks = List.from(_allBooks);

    if (_searchQuery.isNotEmpty) {
      currentBooks = currentBooks.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedGenre != null && _selectedGenre != 'All Genres') {
      currentBooks = currentBooks
          .where(
            (book) =>
                book.genre != null &&
                book.genre!.toLowerCase() == _selectedGenre!.toLowerCase(),
          )
          .toList();
    }

    if (_selectedRating != null && _selectedRating != 'All Ratings') {
      final double minRating = _ratingThresholds[_selectedRating] ?? 0.0;
      currentBooks = currentBooks
          .where((book) => book.rating != null && book.rating! >= minRating)
          .toList();
    }

    if (_selectedSortBy != null) {
      currentBooks.sort((a, b) {
        switch (_selectedSortBy) {
          case 'Most Liked':
            return (b.rating ?? 0).compareTo(a.rating ?? 0);
          case 'Newest':
            final int yearA = int.tryParse(a.yearPublisher ?? '0') ?? 0;
            final int yearB = int.tryParse(b.yearPublisher ?? '0') ?? 0;
            int yearCompare = yearB.compareTo(yearA);
            if (yearCompare != 0) return yearCompare;
            final int monthA = _monthToInt(a.monthPublish);
            final int monthB = _monthToInt(b.monthPublish);
            return monthB.compareTo(monthA);
          case 'Oldest':
            final int yearA = int.tryParse(a.yearPublisher ?? '0') ?? 0;
            final int yearB = int.tryParse(b.yearPublisher ?? '0') ?? 0;
            int yearCompare = yearA.compareTo(yearB);
            if (yearCompare != 0) return yearCompare;
            final int monthA = _monthToInt(a.monthPublish);
            final int monthB = _monthToInt(b.monthPublish);
            return monthA.compareTo(monthB);
          default:
            return 0;
        }
      });
    }

    setState(() {
      _filteredBooks = currentBooks;
    });
  }

  int _monthToInt(String? month) {
    const months = {
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
    return months[month] ?? 0;
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
              TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  _applyFilters();
                },
                decoration: InputDecoration(
                  hintText: 'Search by title or author...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDropdown(
                      'All Genres',
                      _availableGenres,
                      _selectedGenre,
                      (val) {
                        setState(() => _selectedGenre = val);
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildDropdown(
                      'All Ratings',
                      _ratingThresholds.keys.toList(),
                      _selectedRating,
                      (val) {
                        setState(() => _selectedRating = val);
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildDropdown(
                      'Sort by',
                      ['Most Liked', 'Newest', 'Oldest'],
                      _selectedSortBy,
                      (val) {
                        setState(() => _selectedSortBy = val);
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredBooks.isEmpty
                    ? Center(child: Text('No matching books found.'))
                    : GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.65,
                        children: _filteredBooks
                            .map((book) => BookCard(book: book))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? currentValue,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          hint: Text(hint),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item == hint ? null : item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BookDetailPage(book: book, onAddToWishlist: (b) {}, wishlist: []),
        ),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                book.imageUrl ?? '',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey,
                  child: const Center(child: Icon(Icons.broken_image)),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.genre != null)
                    Text(
                      'Genre: ${book.genre}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  if (book.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        Text(
                          '${book.rating!.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 12),
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
