import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart'; // Adjust path as needed

class SettingsPage extends StatefulWidget {
  // It's good practice to make the onThemeToggle callback explicit
  // for better readability and dependency management.
  // Although in the previous example, the SettingsPage was instantiated
  // within _HomePageState with a direct call to Provider.of.
  // For consistency with that, we'll keep it as a StatefulWidget without a direct callback prop
  // and access the ThemeProvider directly within its build method.
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // These are your primary branding colors, which might not change with the theme mode.
  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  void showInfoDialog(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    // Rely on Theme.of(context) for dialog colors as well
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(
          context,
        ).cardColor, // Use theme's card color for dialog background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: primaryGreen), // Icon color remains primaryGreen
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .color, // Use theme's title text color
                ),
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ), // Use theme's body text color
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(
                color: primaryGreen,
              ), // Button text color (can be primaryGreen or Theme.of(context).buttonTheme.color)
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Assuming ThemeProvider has an `isDarkMode` getter or you use `themeProvider.themeMode == ThemeMode.dark`
    final bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor, // Use theme's scaffold background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Preferences',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).textTheme.titleMedium!.color, // Use theme's title text color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ), // Use theme's divider color
            // --- Dark Mode Feature ---
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(
                  isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: primaryGreen,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(); // Toggle the theme
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Theme changed to ${value ? 'Dark' : 'Light'} Mode',
                        ),
                      ),
                    );
                  },
                  activeColor: primaryGreen,
                ),
                onTap: () {
                  // Tapping the ListTile also toggles the theme
                  themeProvider.toggleTheme();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Theme changed to ${!isDarkMode ? 'Dark' : 'Light'} Mode',
                      ),
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
                color: Theme.of(
                  context,
                ).textTheme.titleMedium!.color, // Use theme's title text color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ), // Use theme's divider color
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: primaryGreen),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // Use theme's icon color
                ),
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
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(Icons.description_outlined, color: primaryGreen),
                title: Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // Use theme's icon color
                ),
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
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(Icons.info_outline, color: primaryGreen),
                title: Text(
                  'About RelaxRead',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // Use theme's icon color
                ),
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
                color: Theme.of(
                  context,
                ).textTheme.titleMedium!.color, // Use theme's title text color
              ),
            ),
            Divider(
              height: 20,
              thickness: 1,
              color: Theme.of(context).dividerColor,
            ), // Use theme's divider color
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(Icons.help_outline, color: primaryGreen),
                title: Text(
                  'Help & FAQs',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // Use theme's icon color
                ),
                onTap: () => showInfoDialog(
                  context,
                  'Help & FAQs',
                  'Need help using RelaxRead?\n\nCheck out answers to common questions:\n\n• How do I add a book to my wishlist?\n• How do I follow an author?\n• How can I leave a review?\n• Can I use RelaxRead without logging in?\n\nIf you still need help, contact us through Send Feedback.',
                  Icons.help_outline,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: Theme.of(context).cardColor, // Use theme's card color
              child: ListTile(
                leading: Icon(Icons.feedback_outlined, color: primaryGreen),
                title: Text(
                  'Send Feedback',
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ), // Use theme's body text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Theme.of(
                    context,
                  ).iconTheme.color, // Use theme's icon color
                ),
                onTap: () => showInfoDialog(
                  context,
                  'Send Feedback',
                  'We’d love to hear from you!\n\nIf you have suggestions, bugs to report, or want to share your experience using RelaxRead, feel free to contact us at:\n\n📧 relaxread.support@gmail.com\n🕘 We usually reply within 1–2 working days.',
                  Icons.feedback_outlined,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // App Version
            Center(
              child: Text(
                'RelaxRead v1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color, // Use theme's subtitle/secondary text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
