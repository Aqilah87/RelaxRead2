import 'package:flutter/material.dart';
import 'ebook_form_page.dart';
import 'package:relaxread2/user/book.dart'; // Ensure Book class is imported correctly
import 'settings_page_admin.dart'; // Assuming globalEbooks is defined here

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Book> _currentEbooks = []; // Local list to display, filtered by search
  int _selectedIndex = 0; // To manage selected navigation item

  // Define your navigation destinations
  final List<Map<String, dynamic>> _navigationDestinations = [
    {'label': 'Manage Books', 'icon': Icons.menu_book}, // Changed from 'Ebooks'
    {
      'label': 'Manage Reviews',
      'icon': Icons.reviews,
    }, // New destination with icon
    {'label': 'Settings', 'icon': Icons.settings},
  ];

  // Placeholder pages for different sections
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadEbooks(); // Initial load

    // Initialize pages with the new ManageBooksPage, ReviewManagementPage, and AdminSettingsPage
    _pages = [
      _buildEbookListPage(), // Manage Books page (index 0)
      _buildReviewManagementPage(), // Review Management page (index 1)
      const AdminSettingsPage(), // NEW: Settings page (index 2) - Corrected constructor
    ];
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

  // Helper widget to build the Ebook List Page content (now "Manage Books")
  Widget _buildEbookListPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'Manage Books', // Specific header for this page
          style: TextStyle(
            color: loginPrimaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
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
      ),
    );
  }

  // Helper widget to build the Review Management Page content
  Widget _buildReviewManagementPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'Manage Reviews', // Specific header for this page
          style: TextStyle(
            color: loginPrimaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.reviews, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'Review Management - Under Construction',
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'This page will allow you to view, approve, and delete user reviews.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for general placeholder pages (e.g., Settings)
  // This method will no longer be used for Settings once AdminSettingsPage is integrated
  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            '$title - Under Construction',
            style: const TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ],
      ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2EB),
      // appBar: AppBar( // Removed the global AppBar
      //   backgroundColor: Colors.white,
      //   elevation: 1.0,
      //   title: Text(
      //     'Admin Dashboard',
      //     style: TextStyle(
      //       color: loginPrimaryGreen,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 22,
      //     ),
      //   ),
      // ),
      // Drawer for smaller screens
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: loginPrimaryGreen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 40,
                            color: loginPrimaryGreen,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Book Admin',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          'admin@bookapp.com',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ..._navigationDestinations.asMap().entries.map((entry) {
                    int idx = entry.key;
                    Map<String, dynamic> item = entry.value;
                    return ListTile(
                      leading: Icon(
                        item['icon'],
                        color: _selectedIndex == idx
                            ? primaryGreen
                            : Colors.grey[700],
                      ),
                      title: Text(
                        item['label'],
                        style: TextStyle(
                          fontWeight: _selectedIndex == idx
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: _selectedIndex == idx,
                      onTap: () {
                        setState(() {
                          _selectedIndex = idx;
                        });
                        Navigator.pop(context); // Close drawer
                      },
                    );
                  }).toList(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text('Logout'),
                    onTap: () {
                      // Handle logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out!')),
                      );
                    },
                  ),
                ],
              ),
            )
          : null, // No drawer for larger screens

      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we are on a small screen (e.g., mobile)
          bool isSmallScreen = constraints.maxWidth < 600;

          return Row(
            children: [
              // Navigation Rail for larger screens
              if (!isSmallScreen)
                NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _navigationDestinations.map((item) {
                    return NavigationRailDestination(
                      icon: Icon(item['icon']),
                      selectedIcon: Icon(item['icon'], color: primaryGreen),
                      label: Text(item['label']),
                    );
                  }).toList(),
                  leading: Column(
                    children: [
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: loginPrimaryGreen,
                        child: const Icon(
                          Icons.admin_panel_settings,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: loginPrimaryGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.grey),
                          onPressed: () {
                            // Handle logout
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logged out!')),
                            );
                          },
                          tooltip: 'Logout',
                        ),
                      ),
                    ),
                  ),
                ),
              // Main content area
              Expanded(child: _pages[_selectedIndex]),
            ],
          );
        },
      ),
      floatingActionButton:
          _selectedIndex ==
              0 // Only show FAB on Manage Books page (index 0)
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EbookFormPage(),
                  ),
                );
                // Refresh list after returning from form, only if on the Manage Books page
                if (_selectedIndex == 0) {
                  _loadEbooks();
                }
              },
              backgroundColor: loginPrimaryGreen,
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Add New Ebook',
            )
          : null, // Hide FAB on other pages
    );
  }
}
