// lib/manage_books_page.dart
import 'package:flutter/material.dart';
import 'ebook_form_page.dart';
import 'package:relaxread2/user/book.dart'; // Ensure Book class is imported correctly

class ManageBooksPage extends StatefulWidget {
  const ManageBooksPage({super.key});

  @override
  State<ManageBooksPage> createState() => _ManageBooksPageState();
}

class _ManageBooksPageState extends State<ManageBooksPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Book> _currentEbooks = []; // Local list to display, filtered by search

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadEbooks(); // Initial load
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterEbooks(); // Re-filter when search query changes
    });
  }

  void _loadEbooks() {
    setState(() {
      _currentEbooks = List.from(globalEbooks); // Make a mutable copy
      _filterEbooks(); // Apply initial filter
    });
  }

  void _filterEbooks() {
    if (_searchQuery.isEmpty) {
      _currentEbooks = List.from(globalEbooks);
    } else {
      _currentEbooks = globalEbooks.where((book) {
        final title = book.title.toLowerCase();
        final author = book.author.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || author.contains(query);
      }).toList();
    }
  }

  // Function to delete an ebook from in-memory list
  void _deleteEbook(String ebookId) {
    setState(() {
      globalEbooks.removeWhere((book) => book.ebookId == ebookId);
      _filterEbooks(); // Re-filter the displayed list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ebook deleted successfully!')),
    );
  }

  // Confirmation dialog for deletion
  Future<void> _showDeleteConfirmationDialog(
    String ebookId,
    String title,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Deletion'),
          content: Text(
            'Are you sure you want to delete "$title"? This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: primaryGreen)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteEbook(ebookId);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Helper widget for info chips
  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: primaryGreen.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search ebooks by title or author...',
              prefixIcon: Icon(Icons.search, color: primaryGreen),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
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
                vertical: 12.0,
                horizontal: 16.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: _currentEbooks.isEmpty && _searchQuery.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey, size: 50),
                      SizedBox(height: 10),
                      Text('No ebooks found. Add some using the + button!'),
                    ],
                  ),
                )
              : _currentEbooks.isEmpty && _searchQuery.isNotEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, color: Colors.grey, size: 50),
                      SizedBox(height: 10),
                      Text('No matching ebooks found for your search.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _currentEbooks.length,
                  itemBuilder: (context, index) {
                    final book = _currentEbooks[index];

                    return Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child:
                                  book.imageUrl != null &&
                                      book.imageUrl!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        book.imageUrl!,
                                        fit: BoxFit.cover,
                                        width: 70,
                                        height: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                  color: primaryGreen,
                                                ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.menu_book,
                                      size: 40,
                                      color: primaryGreen,
                                    ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    'by ${book.author}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: [
                                      if (book.publisher != null &&
                                          book.publisher!.isNotEmpty)
                                        _buildInfoChip(
                                          Icons.business,
                                          book.publisher!,
                                        ),
                                      if (book.yearPublisher != null &&
                                          book.yearPublisher!.isNotEmpty)
                                        _buildInfoChip(
                                          Icons.calendar_today,
                                          book.yearPublisher!,
                                        ),
                                      if (book.pageNumber != null)
                                        _buildInfoChip(
                                          Icons.pages,
                                          '${book.pageNumber} pages',
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: primaryGreen),
                                  tooltip: 'Edit Ebook',
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EbookFormPage(ebook: book),
                                      ),
                                    );
                                    _loadEbooks(); // Refresh list after returning from form
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  tooltip: 'Delete Ebook',
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                      book.ebookId,
                                      book.title,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
