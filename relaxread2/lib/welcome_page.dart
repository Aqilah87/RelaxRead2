import 'package:flutter/material.dart';
import 'package:relaxread2/login_page.dart'; // Import the new login page

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background with a subtle pattern
      backgroundColor: const Color(0xFFF0F2EB), // Base background color
      body: Container(
        // Ensure you have 'assets/noisy_background.png' in your pubspec.yaml
        // and the file exists in your assets folder.
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(
              'assets/noisy_background.png',
            ), // Background image
            fit: BoxFit.cover, // Cover the entire screen
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8), // Lighten the background
              BlendMode.modulate, // Blend mode to apply the color filter
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // Added SingleChildScrollView to prevent overflow on small screens
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon - represented by a black square with a white icon
                Container(
                  width: 120, // Adjust size as needed
                  height: 120, // Adjust size as needed
                  decoration: BoxDecoration(
                    color: Colors.black, // Dark background for the logo
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ), // Rounded corners for the logo box
                  ),
                  child: const Center(
                    // Placeholder for your actual logo image.
                    // Replace this with your image asset: Image.asset('assets/nusa_pages_logo.png', height: 80, width: 80),
                    child: Icon(
                      Icons
                          .menu_book, // Using a generic book icon as a placeholder
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Space between logo and app name
                // App Name
                Text(
                  'RelaxRead', // Your app name
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[850], // Dark grey for strong contrast
                    letterSpacing: 1.5, // Slightly increased letter spacing
                  ),
                ),
                const SizedBox(
                  height: 10,
                ), // Space between app name and tagline
                // Tagline
                Text(
                  'Discover Malay Stories', // Your tagline
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600], // Lighter grey for tagline
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 60), // Space before buttons
                // Admin Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(userType: 'Admin'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings, size: 24),
                    label: const Text('Admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: loginPrimaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // User Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(userType: 'User'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person, size: 24),
                    label: const Text('User'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
