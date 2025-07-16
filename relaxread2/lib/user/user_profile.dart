import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:relaxread2/welcome_page.dart'; // Import the new WelcomePage
import '../theme_provider.dart'; // Ensure this path is correct for ThemeProvider

class UserProfilePage extends StatefulWidget {
  // Now requires userName and userEmail to be passed in
  final String userName;
  final String userEmail;

  const UserProfilePage({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Define the primary green color, consistent with Create Account screen
  static const Color primaryGreen = Color(0xFF6B923C);
  // Define a slightly darker green for accents, consistent with Login page
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  // Function to handle logging out
  void _handleLogout() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged out successfully!')));
    // After logging out, navigate back to the Welcome page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomePage(), // Navigate to WelcomePage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access ThemeProvider to get the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;

    // Define colors based on the current theme mode
    final Color appBarColor = isDarkMode
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final Color scaffoldBackgroundColor = isDarkMode
        ? const Color(0xFF121212)
        : const Color(0xFFF0F2EB);
    final Color appBarTitleColor = isDarkMode
        ? primaryGreen
        : loginPrimaryGreen;
    final Color textColor = isDarkMode ? Colors.white70 : Colors.grey[800]!;
    final Color lightTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final Color cardBackgroundColor = isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;
    final Color dividerColor = isDarkMode
        ? Colors.grey[700]!
        : Colors.grey[300]!;
    final Color sectionTitleColor = isDarkMode
        ? primaryGreen
        : loginPrimaryGreen;
    final Color trailingIconColor = isDarkMode
        ? Colors.grey[500]!
        : Colors.grey;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // Dynamic background color
      appBar: AppBar(
        backgroundColor: appBarColor, // Dynamic app bar background
        elevation: 1.0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: appBarTitleColor, // Dynamic app bar title color
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Center the title
        iconTheme: IconThemeData(
          color: appBarTitleColor, // Color for the back arrow icon
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: [
            // User Avatar/Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: isDarkMode
                  ? primaryGreen.withOpacity(0.4)
                  : primaryGreen.withOpacity(0.2), // Dynamic background
              child: Icon(
                Icons.person,
                size: 80,
                color: isDarkMode
                    ? Colors.white
                    : primaryGreen, // Dynamic icon color
              ),
              // You can replace this with an actual user image:
              // backgroundImage: NetworkImage('https://example.com/user_profile.jpg'),
            ),
            const SizedBox(height: 20),

            // User Name and Edit Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.userName, // Display user name passed from constructor
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor, // Dynamic text color
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.edit, color: primaryGreen, size: 24),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Edit Profile details (Name/Email) functionality goes here!',
                        ),
                      ),
                    );
                    // In a real app, this would navigate to an edit profile screen
                    // or show a dialog to edit name/email.
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // User Email Display
            Text(
              widget.userEmail, // Display user email passed from constructor
              style: TextStyle(
                fontSize: 18,
                color: lightTextColor,
              ), // Dynamic text color
            ),
            const SizedBox(height: 40),

            // --- Profile Settings Section ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile Settings', // Section title
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: sectionTitleColor, // Dynamic section title color
                ),
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
              color: cardBackgroundColor, // Dynamic card background
              child: ListTile(
                leading: Icon(Icons.lock_outline, color: primaryGreen),
                title: Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ), // Dynamic text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor, // Dynamic trailing icon color
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Change Password!')),
                  );
                  // Navigate to change password page
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardBackgroundColor, // Dynamic card background
              child: ListTile(
                leading: const Icon(
                  Icons.subscriptions_outlined,
                  color: primaryGreen,
                ),
                title: Text(
                  'Manage Subscriptions',
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ), // Dynamic text color
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor, // Dynamic trailing icon color
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Manage Subscriptions!')),
                  );
                  // Navigate to subscription management page
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              color: cardBackgroundColor, // Dynamic card background
              child: ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ), // Red icon for delete
                title: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 17, color: Colors.redAccent),
                ), // Red text for delete
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: trailingIconColor, // Dynamic trailing icon color
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete Account! (Confirmation needed)'),
                    ),
                  );
                  // Implement account deletion logic (with confirmation dialog)
                },
              ),
            ),
            const SizedBox(height: 30),

            // Logout Button
            ElevatedButton.icon(
              onPressed: _handleLogout, // Call the logout handler
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Red for logout
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 2,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
