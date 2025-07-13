import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'create_account.dart'; // Import the create account page

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // Define the primary green color, consistent with Create Account screen
  static const Color primaryGreen = Color(0xFF6B923C);
  // Define a slightly darker green for accents, consistent with Login page
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  // --- State variables to manage user login status and display info ---
  // In a real app, _isLoggedIn and user data would come from an authentication service.
  bool _isLoggedIn = false; // Initial state: User is not logged in (Guest)
  String _userName = 'Guest User';
  String _userEmailDisplay =
      'Not logged in'; // Text to show when no email is available

  // Function to simulate logging in/out
  void _toggleLoginStatus() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
      if (_isLoggedIn) {
        _userName = 'John Doe'; // Simulate logged-in user's name
        _userEmailDisplay =
            'john.doe@example.com'; // Simulate logged-in user's email
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Simulating Login!')));
      } else {
        _userName = 'Guest User'; // Revert to guest name
        _userEmailDisplay = 'Not logged in'; // Revert to no email display
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Simulating Logout!')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2EB), // Consistent light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: loginPrimaryGreen,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true, // Center the title
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
              backgroundColor: primaryGreen.withOpacity(
                0.2,
              ), // Light green background
              child: Icon(
                Icons.person,
                size: 80,
                color: primaryGreen, // Green icon
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
                  _userName, // Dynamic User Name
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
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
              _userEmailDisplay, // Dynamic Email Display
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),

            // --- Account Actions Section (Conditional) ---
            // This section is only visible if the user is NOT logged in
            if (!_isLoggedIn) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: loginPrimaryGreen,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.grey,
              ), // Separator
              // Register Button
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2.0,
                child: ListTile(
                  leading: Icon(Icons.person_add, color: primaryGreen),
                  title: const Text(
                    'Create New Account',
                    style: TextStyle(fontSize: 17),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Navigating to Create Account!'),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Login Button
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 2.0,
                child: ListTile(
                  leading: Icon(Icons.login, color: primaryGreen),
                  title: const Text('Log In', style: TextStyle(fontSize: 17)),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navigating to Login!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ), // Add space only if these buttons are visible
            ],
            // End of conditional "Account Actions" section

            // General Settings Section (Example)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: loginPrimaryGreen,
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 2.0,
              child: ListTile(
                leading: Icon(Icons.notifications_none, color: primaryGreen),
                title: const Text(
                  'Notifications',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications settings!')),
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
              child: ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: primaryGreen),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy Policy!')),
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
              child: ListTile(
                leading: Icon(Icons.help_outline, color: primaryGreen),
                title: const Text(
                  'Help & Support',
                  style: TextStyle(fontSize: 17),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Logout Button (Conditional)
            if (_isLoggedIn) // Only show logout if logged in
              ElevatedButton.icon(
                onPressed: _toggleLoginStatus, // Simulate logout
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
            const SizedBox(height: 20), // Space after logout button if visible
          ],
        ),
      ),
    );
  }
}
