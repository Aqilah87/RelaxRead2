import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ebook_form_page.dart';
import 'review_management_page.dart';
import 'settings_page_admin.dart';
import 'package:relaxread2/user/book.dart';
import 'manage_books_page.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'manage_users_page.dart';

final supabase = Supabase.instance.client;

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // Color definitions
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);
  static const Color lightGreenBackground = Color(0xFFF0F2EB);
  static const Color lightAppBarBackground = Colors.white;
  static const Color lightCardBackground = Colors.white;
  static const Color lightTextColor = Colors.black;
  static const Color lightDrawerHeaderBackground = loginPrimaryGreen;
  static const Color lightDrawerIconColor = Colors.grey;
  static const Color lightDrawerTextColor = Colors.black;
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkAppBarBackground = Color(0xFF2C2C2C);
  static const Color darkCardBackground = Color(0xFF383838);
  static const Color darkTextColor = Colors.white;
  static const Color darkDrawerHeaderBackground = Color(0xFF2C2C2C);
  static const Color darkDrawerIconColor = Colors.white70;
  static const Color darkDrawerTextColor = Colors.white;

  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _navigationDestinations = [
    {'label': 'Dashboard', 'icon': Icons.dashboard},
    {'label': 'Manage Books', 'icon': Icons.menu_book},
    {'label': 'Manage Reviews', 'icon': Icons.reviews},
    {'label': 'Manage User Account', 'icon': Icons.people},
    {'label': 'Settings', 'icon': Icons.settings},
  ];

  List<Book> _allBooks = [];
  int _totalUsers = 0;
  int _totalAdmins = 0;
  int _totalReviews = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch books
      final booksResponse = await supabase.from('books').select();
      _allBooks = (booksResponse as List)
          .map((item) => Book.fromMap(item as Map<String, dynamic>))
          .toList();

      // Fetch user counts
      final usersResponse = await supabase
          .from('profiles')
          .select()
          .eq('user_type', 'User');
      _totalUsers = usersResponse.length;

      final adminsResponse = await supabase
          .from('profiles')
          .select()
          .eq('user_type', 'Admin');
      _totalAdmins = adminsResponse.length;

      // Fetch review count
      final reviewsResponse = await supabase.from('reviews').select();
      _totalReviews = reviewsResponse.length;

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchData();
  }

  // Color getters based on theme
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

    final List<Widget> pages = [
      _buildDashboardPage(isDarkMode),
      AdminDashboardPage(
       /* initialEbooks: _allBooks,
        onBookAdded: (book) => _refreshData(),
        onBookUpdated: (book) => _refreshData(),
        onBookDeleted: (id) => _refreshData(),*/
      ),
      ReviewManagementPage(
        /*onReviewDeleted: () => _refreshData(),*/
      ),
      const ManageUsersPage(),
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
            onPressed: themeProvider.toggleTheme,
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? Drawer(
              backgroundColor: _scaffoldBackgroundColor(isDarkMode),
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
                        const SizedBox(height: 10),
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
                          : Colors.grey[200],
                      onTap: () {
                        setState(() => _selectedIndex = idx);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                bool isSmallScreen = constraints.maxWidth < 600;
                return Row(
                  children: [
                    if (!isSmallScreen)
                      NavigationRail(
                        backgroundColor: _appBarBackgroundColor(isDarkMode),
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (int index) {
                          setState(() => _selectedIndex = index);
                        },
                        labelType: NavigationRailLabelType.all,
                        destinations: _navigationDestinations.map((item) {
                          return NavigationRailDestination(
                            icon: Icon(
                              item['icon'],
                              color: _drawerIconColor(isDarkMode),
                            ),
                            selectedIcon: Icon(item['icon'], color: primaryGreen),
                            label: Text(
                              item['label'],
                              style: TextStyle(color: _drawerTextColor(isDarkMode)),
                            ),
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
                                color: _appBarTitleColor(isDarkMode),
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

  Widget _buildDashboardPage(bool isDarkMode) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatCard(
              'Total Ebooks',
              '${_allBooks.length}',
              Icons.menu_book,
              primaryGreen,
              isDarkMode,
            ),
            _buildStatCard(
              'Total Users',
              '$_totalUsers',
              Icons.people,
              Colors.blue,
              isDarkMode,
            ),
            _buildStatCard(
              'Total Reviews',
              '$_totalReviews',
              Icons.reviews,
              Colors.purple,
              isDarkMode,
            ),
            _buildStatCard(
              'Total Admins',
              '$_totalAdmins',
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
                color: _dashboardTitleColor(isDarkMode),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: _cardBackgroundColor(isDarkMode),
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
                      barTouchData: const BarTouchData(enabled: true),
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
                                ),
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
                              );
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
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Card(
      color: _cardBackgroundColor(isDarkMode),
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
          ),
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