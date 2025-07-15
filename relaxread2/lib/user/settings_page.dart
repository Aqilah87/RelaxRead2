import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
// Update the import path if ThemeProvider is located elsewhere, for example:
import '../theme_provider.dart'; // Adjust path as needed

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Define the primary green color, consistent with Create Account screen
  static const Color primaryGreen = Color(0xFF6B923C);
  // Define a slightly darker green for accents, consistent with Login page
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  void showInfoDialog(BuildContext context, String title, String content, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: primaryGreen),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        content: Text(content, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
      context,
    ); // Access ThemeProvider
    final bool isDarkMode =
        themeProvider.isDarkMode; // Use ThemeProvider's state

    // Define colors based on current theme mode
    final Color backgroundColor = isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF0F2EB);
    final Color appBarColor = isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    final Color headingColor = isDarkMode ? primaryGreen : loginPrimaryGreen;
    final Color cardColor = isDarkMode ? const Color(0xFF3A3A3A) : Colors.white;
    final Color dividerColor = isDarkMode ? Colors.grey[700]! : Colors.grey;
    final Color trailingIconColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor, // Dynamic background color
      appBar: AppBar(
        backgroundColor: appBarColor, // Dynamic app bar color
        elevation: 1.0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: headingColor, // Dynamic title color
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Center the title
        iconTheme: IconThemeData(color: headingColor), // Back button color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          children: [
            // --- App Preferences Section ---
            Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: headingColor, // Dynamic heading color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: dividerColor,
            ), // Dynamic divider color

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.notifications_none, color: primaryGreen),
                title: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Switch(
                  // Example of a switch setting
                  value:
                      true, // This value would come from app state in a real app
                  onChanged: (bool value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifications toggled: $value')),
                    );
                    // Update notification preference in app state
                  },
                  activeColor: primaryGreen,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications settings tapped!'),
                    ),
                  );
                },
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.language, color: primaryGreen),
                title: Text(
                  'Language',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Language settings!')),
                  );
                },
              ),
            ),

            // --- Dark Mode Feature ---
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(
                  isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: primaryGreen,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Switch(
                  value: isDarkMode, // Use ThemeProvider's state
                  onChanged: (bool value) {
                    themeProvider.toggleDarkMode(
                      value,
                    ); // Update ThemeProvider's state
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dark Mode toggled: $value')),
                    );
                  },
                  activeColor: primaryGreen,
                ),
                onTap: () {
                  // Tapping the ListTile itself also toggles the switch
                  themeProvider.toggleDarkMode(
                    !isDarkMode,
                  ); // Toggle ThemeProvider's state
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dark Mode toggled: ${!isDarkMode}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // --- About & Legal Section ---
            Text(
              'About & Legal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: headingColor, // Dynamic heading color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: dividerColor,
            ), // Dynamic divider color

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: primaryGreen),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
              onTap: () => showInfoDialog(
                context,
                'Privacy Policy',
                'We respect your privacy. RelaxRead only collects basic user data (such as email and favorite books) to improve your reading experience. We do not share your data with others. Your data is kept safe and only used inside this app.',
                Icons.privacy_tip_outlined,
              ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.description_outlined, color: primaryGreen),
                title: Text(
                  'Terms of Service',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
              onTap: () => showInfoDialog(
                context,
                'Terms of Service',
                'By using RelaxRead, you agree to:\n• Use the app respectfully\n• Not upload harmful content\n• Let us improve features using your app activity\n\nWe may suspend accounts that break the rules.',
                Icons.description_outlined,
              ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.info_outline, color: primaryGreen),
                title: Text(
                  'About RelaxRead',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
              onTap: () => showInfoDialog(
                context,
                'About RelaxRead',
                'RelaxRead is a simple ebook app focused on Malay novels and folklore.\nYou can search books, save to wishlist, like, review, and follow authors.\nThis app is developed as a student project to support local stories and reading culture.',
                Icons.info_outline,
              ),
              ),
            ),
            const SizedBox(height: 30),

            // --- Support Section ---
            Text(
              'Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: headingColor, // Dynamic heading color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: dividerColor,
            ), // Dynamic divider color

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.help_outline, color: primaryGreen),
                title: Text(
                  'Help & FAQs',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Help & FAQs!')));
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardColor, // Dynamic card color
              child: ListTile(
                leading: Icon(Icons.feedback_outlined, color: primaryGreen),
                title: Text(
                  'Send Feedback',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor,
                ), // Dynamic icon color
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Send Feedback!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // App Version
            Center(
              child: Text(
                'RelaxRead v1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.7),
                ), // Dynamic text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
