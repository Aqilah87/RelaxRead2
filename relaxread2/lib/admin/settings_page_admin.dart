import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'dashboard_page.dart'; // <<< ADD THIS IMPORT

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);
  // static const Color lightGreen = Color(0xFFE8F5E9); // This will be dynamic now

  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Define dynamic colors based on themeProvider.isDarkMode
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFE8F5E9);
    final Color appBarColor = isDarkMode
        ? const Color(0xFF1F1F1F)
        : Colors.white;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headingColor = isDarkMode ? primaryGreen : loginPrimaryGreen;
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey;
    final Color trailingIconColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor, // Use dynamic background color
      appBar: AppBar(
        backgroundColor: appBarColor, // Use dynamic app bar color
        elevation: 1.0,
        title: Text(
          'Admin Settings',
          style: TextStyle(
            color: headingColor, // Use dynamic heading color for title
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: headingColor), // Back button color
        // Add a custom leading icon to override default back button behavior
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to the DashboardPage and remove all previous routes
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminDashboardPage(),
              ),
              (Route<dynamic> route) =>
                  false, // Remove all routes until DashboardPage is the only one
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.settings, size: 80, color: primaryGreen),
                  const SizedBox(height: 16),
                  Text(
                    'Manage Application Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: headingColor, // Use dynamic heading color
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            _buildSectionTitle(
              'General Settings',
              headingColor,
            ), // Pass headingColor
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Use dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Dark Mode',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      value: themeProvider.isDarkMode,
                      onChanged: (bool value) {
                        themeProvider.toggleDarkMode(value);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Dark Mode ${value ? 'enabled' : 'disabled'}',
                            ),
                          ),
                        );
                      },
                      activeColor: primaryGreen,
                    ),
                    ListTile(
                      title: Text(
                        'Language',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        icon: Icon(Icons.arrow_drop_down, color: primaryGreen),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Language set to $_selectedLanguage',
                              ),
                            ),
                          );
                        },
                        dropdownColor:
                            cardColor, // Ensure dropdown also respects dark mode
                        items:
                            <String>[
                              'English',
                              'Spanish',
                              'French',
                              'German',
                              'Chinese',
                              'Japanese',
                              'Malay',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: textColor),
                                ), // Use dynamic text color
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle(
              'Account Settings',
              headingColor,
            ), // Pass headingColor
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Use dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.lock, color: primaryGreen),
                      title: Text(
                        'Change Password',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: trailingIconColor, // Use dynamic icon color
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navigating to Change Password...'),
                          ),
                        );
                        // Implement navigation to password change page
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: primaryGreen),
                      title: Text(
                        'Update Email',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: trailingIconColor, // Use dynamic icon color
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Navigating to Update Email...'),
                          ),
                        );
                        // Implement navigation to email update page
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle('About', headingColor), // Pass headingColor
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Use dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.info_outline, color: primaryGreen),
                      title: Text(
                        'Version',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      trailing: Text(
                        '1.0.0',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                    ),
                    ListTile(
                      leading: Icon(Icons.policy, color: primaryGreen),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(color: textColor),
                      ), // Use dynamic text color
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: trailingIconColor, // Use dynamic icon color
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Opening Privacy Policy...'),
                          ),
                        );
                        // Implement navigation/launch URL for privacy policy
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title, Color color) {
    // Accept color parameter
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0, left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color, // Use the passed color
        ),
      ),
    );
  }
}
