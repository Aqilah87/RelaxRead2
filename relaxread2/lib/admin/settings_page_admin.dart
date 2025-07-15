// lib/settings_page_admin.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Required for ThemeProvider
import '../theme_provider.dart'; // Your custom ThemeProvider

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  static const Color primaryGreen = Color(0xFF6B923C);

  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to determine current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Define dynamic colors based on the theme mode
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF121212) // Dark background for dark mode
        : const Color(0xFFE8F5E9); // Light background for light mode
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headingColor = isDarkMode
        ? primaryGreen // Primary green for headings in dark mode
        : const Color(0xFF5A7F30); // A darker green for headings in light mode
    final Color cardColor = isDarkMode
        ? const Color(0xFF1E1E1E) // Darker card for dark mode
        : Colors.white; // White card for light mode
    final Color trailingIconColor = isDarkMode
        ? Colors.grey[400]! // Lighter grey for trailing icons in dark mode
        : Colors.grey; // Default grey for light mode
    final Color leadingIconColor = isDarkMode
        ? primaryGreen.withOpacity(
            0.8,
          ) // Muted green for leading icons in dark mode
        : primaryGreen; // Primary green for leading icons in light mode

    return Scaffold(
      backgroundColor: backgroundColor, // Apply dynamic background color
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
                      color: headingColor, // Apply dynamic heading color
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            _buildSectionTitle(
              'General Settings',
              headingColor, // Pass dynamic heading color
            ),
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Apply dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Language',
                        style: TextStyle(
                          color: textColor,
                        ), // Apply dynamic text color
                      ),
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
                                  style: TextStyle(
                                    color: textColor,
                                  ), // Apply dynamic text color
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    // Removed the SwitchListTile for Dark Mode here
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionTitle(
              'Account Settings',
              headingColor, // Pass dynamic heading color
            ),
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Apply dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.lock,
                        color:
                            leadingIconColor, // Apply dynamic leading icon color
                      ),
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                          color: textColor,
                        ), // Apply dynamic text color
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color:
                            trailingIconColor, // Apply dynamic trailing icon color
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
                      leading: Icon(
                        Icons.email,
                        color:
                            leadingIconColor, // Apply dynamic leading icon color
                      ),
                      title: Text(
                        'Update Email',
                        style: TextStyle(
                          color: textColor,
                        ), // Apply dynamic text color
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color:
                            trailingIconColor, // Apply dynamic trailing icon color
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
            _buildSectionTitle(
              'About',
              headingColor,
            ), // Pass dynamic heading color
            Card(
              elevation: 2.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: cardColor, // Apply dynamic card color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color:
                            leadingIconColor, // Apply dynamic leading icon color
                      ),
                      title: Text(
                        'Version',
                        style: TextStyle(
                          color: textColor,
                        ), // Apply dynamic text color
                      ),
                      trailing: Text(
                        '1.0.0',
                        style: TextStyle(
                          color: textColor,
                        ), // Apply dynamic text color
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.policy,
                        color:
                            leadingIconColor, // Apply dynamic leading icon color
                      ),
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(color: textColor),
                      ), // Apply dynamic text color
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color:
                            trailingIconColor, // Apply dynamic trailing icon color
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0, left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color, // Use the passed dynamic color
        ),
      ),
    );
  }
}
