import 'package:flutter/material.dart';
// You might need to import other pages if settings lead to them, e.g.:
// import 'user_profile_page.dart';
// import 'about_us_page.dart';

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

  // --- State variable for Dark Mode ---
  // In a real app, this would likely be managed globally (e.g., via Provider, Riverpod, Bloc)
  // and persist across app launches. For this example, it's local state.
  bool _isDarkMode = false; // Initial state: Light mode

  @override
  Widget build(BuildContext context) {
    // Define colors based on current theme mode
    final Color backgroundColor = _isDarkMode
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFF0F2EB);
    final Color appBarColor = _isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;
    final Color textColor = _isDarkMode ? Colors.white70 : Colors.black87;
    final Color headingColor = _isDarkMode ? primaryGreen : loginPrimaryGreen;
    final Color cardColor = _isDarkMode
        ? const Color(0xFF3A3A3A)
        : Colors.white;
    final Color dividerColor = _isDarkMode ? Colors.grey[700]! : Colors.grey;
    final Color trailingIconColor = _isDarkMode
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
                  _isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: primaryGreen,
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 17, color: textColor),
                ), // Dynamic text color
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (bool value) {
                    setState(() {
                      _isDarkMode = value; // Update the local state
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Dark Mode toggled: $value')),
                    );
                    // In a real app, you would notify a global theme provider here
                    // to change the theme of the entire application.
                  },
                  activeColor: primaryGreen,
                ),
                onTap: () {
                  // Tapping the ListTile itself also toggles the switch
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dark Mode toggled: $_isDarkMode')),
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terms of Service!')),
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('About RelaxRead!')),
                  );
                },
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
