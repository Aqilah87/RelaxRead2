import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ebook_form_page.dart';
import 'review_management_page.dart';
import 'settings_page_admin.dart';
import 'package:relaxread2/user/book.dart';
import 'manage_books_page.dart'; // Import the ManageBooksPage

// Placeholder for globalReviews, similar to globalEbooks
// In a real application, you would fetch these from a database or API.
List<dynamic> globalReviews = [
  // Example reviews
  {'id': '1', 'text': 'Great book!', 'rating': 5},
  {'id': '2', 'text': 'Could be better.', 'rating': 3},
  {'id': '3', 'text': 'Amazing read.', 'rating': 5},
];

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);
  static const Color lightGreenBackground = Color(0xFFF0F2EB);

  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _navigationDestinations = [
    {'label': 'Dashboard', 'icon': Icons.dashboard},
    {'label': 'Manage Books', 'icon': Icons.menu_book},
    {'label': 'Manage Reviews', 'icon': Icons.reviews},
    {'label': 'Settings', 'icon': Icons.settings},
  ];

  // State to manage the list of books
  List<Book> _allBooks = [];

  @override
  void initState() {
    super.initState();
    // Initialize with some dummy data or load from persistence
    _allBooks = [
      Book(
        ebookId: '1',
        title: 'The Great Gatsby',
        author: 'F. Scott Fitzgerald',
        publisher: 'Scribner',
        yearPublisher: '1925',
        pageNumber: 180,
        imageUrl:
            'https://images-na.ssl-images-amazon.com/images/I/41Kq41nI6AL._SX322_BO1,204,203,200_.jpg',
      ),
      Book(
        ebookId: '2',
        title: '1984',
        author: 'George Orwell',
        publisher: 'Secker & Warburg',
        yearPublisher: '1949',
        pageNumber: 328,
        imageUrl:
            'https://images-na.ssl-images-amazon.com/images/I/41Kq41nI6AL._SX322_BO1,204,203,200_.jpg',
      ),
      Book(
        ebookId: '3',
        title: 'To Kill a Mockingbird',
        author: 'Harper Lee',
        publisher: 'J. B. Lippincott & Co.',
        yearPublisher: '1960',
        pageNumber: 281,
        imageUrl:
            'https://images-na.ssl-images-amazon.com/images/I/41Kq41nI6AL._SX322_BO1,204,203,200_.jpg',
      ),
    ];
  }

  void _addBook(Book newBook) {
    setState(() {
      _allBooks.add(newBook);
    });
  }

  void _updateBook(Book updatedBook) {
    setState(() {
      final index = _allBooks.indexWhere(
        (book) => book.ebookId == updatedBook.ebookId,
      );
      if (index != -1) {
        _allBooks[index] = updatedBook;
      }
    });
  }

  void _deleteBook(String ebookId) {
    setState(() {
      _allBooks.removeWhere((book) => book.ebookId == ebookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalUsers = 1250;
    final int totalAdmins = 5;
    final int totalReviews = globalReviews.length;
    final int totalEbooks =
        _allBooks.length; // Use the internal _allBooks length

    final List<Widget> pages = [
      _buildDashboardPage(totalUsers, totalAdmins, totalReviews, totalEbooks),
      ManageBooksPage(
        initialEbooks: _allBooks,
        onBookAdded: _addBook,
        onBookUpdated: _updateBook,
        onBookDeleted: _deleteBook,
      ), // Pass data and callbacks
      const ReviewManagementPage(),
      const AdminSettingsPage(),
    ];

    return Scaffold(
      backgroundColor: lightGreenBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          _navigationDestinations[_selectedIndex]['label'],
          style: const TextStyle(
            color: loginPrimaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
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
                    var item = entry.value;
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
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text('Logout'),
                    onTap: () {},
                  ),
                ],
              ),
            )
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;
          return Row(
            children: [
              if (!isSmallScreen)
                NavigationRail(
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
                    children: const [
                      SizedBox(height: 16),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: loginPrimaryGreen,
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: loginPrimaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(child: pages[_selectedIndex]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardPage(int users, int admins, int reviews, int ebooks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            'Total Ebooks',
            '$ebooks',
            Icons.menu_book,
            primaryGreen,
          ),
          _buildStatCard('Total Users', '$users', Icons.people, Colors.blue),
          _buildStatCard(
            'Total Reviews',
            '$reviews',
            Icons.reviews,
            Colors.purple,
          ),
          _buildStatCard(
            'Total Admins',
            '$admins',
            Icons.admin_panel_settings,
            Colors.orange,
          ),
          const SizedBox(height: 30),
          Text(
            'Monthly Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 20,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            const months = [
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                            ];
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                          reservedSize: 30,
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 5),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: 5,
                            color: Colors.blue,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: 12,
                            color: Colors.green,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: 7,
                            color: Colors.orange,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: 15,
                            color: Colors.red,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: 9,
                            color: Colors.purple,
                            width: 16,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(
                            toY: 13,
                            color: Colors.teal,
                            width: 16,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 36, color: color),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
