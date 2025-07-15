import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ebook_form_page.dart';
import 'review_management_page.dart';
import 'settings_page_admin.dart';
import 'package:relaxread2/user/book.dart';
import 'manage_books_page.dart'; // Import the ManageBooksPage
import 'package:provider/provider.dart'; // Import Provider
import '../theme_provider.dart'; // Import your custom ThemeProvider

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
  // Define base colors
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  // Light mode specific colors
  static const Color lightGreenBackground = Color(0xFFF0F2EB);
  static const Color lightAppBarBackground = Colors.white;
  static const Color lightCardBackground = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightDrawerHeaderBackground = loginPrimaryGreen;
  static const Color lightDrawerIconColor = Colors.grey;
  static const Color lightDrawerTextColor = Colors.black;

  // Dark mode specific colors
  static const Color darkBackground = Color(0xFF1A1A1A); // Dark charcoal
  static const Color darkAppBarBackground = Color(0xFF2C2C2C); // Darker gray
  static const Color darkCardBackground = Color(0xFF383838); // Medium dark gray
  static const Color darkTextColor = Colors.white;
  static const Color darkDrawerHeaderBackground = Color(0xFF2C2C2C);
  static const Color darkDrawerIconColor = Colors.white70;
  static const Color darkDrawerTextColor = Colors.white;

  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _navigationDestinations = [
    {'label': 'Dashboard', 'icon': Icons.dashboard},
    {'label': 'Manage Books', 'icon': Icons.menu_book},
    {'label': 'Manage Reviews', 'icon': Icons.reviews},
    {'label': 'Settings', 'icon': Icons.settings},
  ];

  List<Book> _allBooks = [];

  @override
  void initState() {
    super.initState();
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

  // Helper getters for colors based on dark mode
  Color _scaffoldBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkBackground : lightGreenBackground;
  Color _appBarBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkAppBarBackground : lightAppBarBackground;
  Color _appBarTitleColor(bool isDarkMode) =>
      isDarkMode ? Colors.white : loginPrimaryGreen;
  Color _drawerHeaderBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkDrawerHeaderBackground : lightDrawerHeaderBackground;
  Color _drawerIconColor(bool isDarkMode) =>
      isDarkMode ? darkDrawerIconColor : lightDrawerIconColor;
  Color _drawerTextColor(bool isDarkMode) =>
      isDarkMode ? darkDrawerTextColor : lightDrawerTextColor;
  Color _cardBackgroundColor(bool isDarkMode) =>
      isDarkMode ? darkCardBackground : lightCardBackground;
  Color _dashboardTitleColor(bool isDarkMode) =>
      isDarkMode ? Colors.white : primaryGreen;
  Color _statCardTitleColor(bool isDarkMode) =>
      isDarkMode ? Colors.white : Colors.black;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    final int totalUsers = 1250;
    final int totalAdmins = 5;
    final int totalReviews = globalReviews.length;
    final int totalEbooks = _allBooks.length;

    final List<Widget> pages = [
      _buildDashboardPage(
        totalUsers,
        totalAdmins,
        totalReviews,
        totalEbooks,
        isDarkMode,
      ),
      ManageBooksPage(
        initialEbooks: _allBooks,
        onBookAdded: _addBook,
        onBookUpdated: _updateBook,
        onBookDeleted: _deleteBook,
      ),
      const ReviewManagementPage(),
      const AdminSettingsPage(),
    ];

    return Scaffold(
      backgroundColor: _scaffoldBackgroundColor(isDarkMode),
      appBar: AppBar(
        backgroundColor: _appBarBackgroundColor(isDarkMode),
        elevation: 1.0,
        title: Text(
          _navigationDestinations[_selectedIndex]['label'],
          style: TextStyle(
            color: _appBarTitleColor(isDarkMode),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: _appBarTitleColor(isDarkMode),
            ),
            onPressed: () {
              themeProvider.toggleTheme(); // Toggle theme using ThemeProvider
            },
            tooltip: isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              backgroundColor: _scaffoldBackgroundColor(
                isDarkMode,
              ), // Apply dark mode color to drawer background
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: _drawerHeaderBackgroundColor(isDarkMode),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            : _drawerIconColor(isDarkMode),
                      ),
                      title: Text(
                        item['label'],
                        style: TextStyle(
                          fontWeight: _selectedIndex == idx
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _drawerTextColor(isDarkMode),
                        ),
                      ),
                      selected: _selectedIndex == idx,
                      selectedTileColor: isDarkMode
                          ? Colors.white12
                          : Colors.grey[200], // Highlight selected item
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
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/welcome', // Replace with your actual welcome page route
                        (Route<dynamic> route) => false,
                      );
                      // You might also want to clear user session data here
                    },
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
                  backgroundColor: _appBarBackgroundColor(
                    isDarkMode,
                  ), // Apply dark mode color to navigation rail
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _navigationDestinations.map((item) {
                    return NavigationRailDestination(
                      icon: Icon(
                        item['icon'],
                        color: _drawerIconColor(isDarkMode),
                      ), // Apply dark mode icon color
                      selectedIcon: Icon(item['icon'], color: primaryGreen),
                      label: Text(
                        item['label'],
                        style: TextStyle(color: _drawerTextColor(isDarkMode)),
                      ), // Apply dark mode text color
                    );
                  }).toList(),
                  leading: Column(
                    children: [
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
                          color: _appBarTitleColor(
                            isDarkMode,
                          ), // Use app bar title color for consistency
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

  Widget _buildDashboardPage(
    int users,
    int admins,
    int reviews,
    int ebooks,
    bool isDarkMode,
  ) {
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
            isDarkMode,
          ),
          _buildStatCard(
            'Total Users',
            '$users',
            Icons.people,
            Colors.blue,
            isDarkMode,
          ),
          _buildStatCard(
            'Total Reviews',
            '$reviews',
            Icons.reviews,
            Colors.purple,
            isDarkMode,
          ),
          _buildStatCard(
            'Total Admins',
            '$admins',
            Icons.admin_panel_settings,
            Colors.orange,
            isDarkMode,
          ),
          const SizedBox(height: 30),
          Text(
            'Monthly Reviews',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _dashboardTitleColor(isDarkMode), // Apply dark mode color
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: _cardBackgroundColor(
              isDarkMode,
            ), // Apply dark mode color to card
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
                              style: TextStyle(
                                fontSize: 12,
                                color: _statCardTitleColor(isDarkMode),
                              ), // Apply dark mode color
                            );
                          },
                          reservedSize: 30,
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: _statCardTitleColor(isDarkMode),
                              ),
                            ); // Apply dark mode color
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: isDarkMode
                              ? Colors.white12
                              : Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        );
                      },
                    ),
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
    bool isDarkMode, // Add isDarkMode parameter
  ) {
    return Card(
      color: _cardBackgroundColor(isDarkMode), // Apply dark mode color to card
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 36, color: color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: _statCardTitleColor(isDarkMode),
          ), // Apply dark mode color
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
