import 'package:flutter/material.dart';
import 'package:relaxread2/login_page.dart'; // Make sure this path is correct

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  static const Color primaryGreen = Color(0xFF6B923C);
  static const Color loginPrimaryGreen = Color(0xFF5A7F30);

  @override
  Widget build(BuildContext context) {
    // Fixed colors as dark mode is not needed for this page
    const Color backgroundColor = Color(0xFFF0F2EB); // Light background
    const Color appNameColor = Colors.black; // Dark text for app name
    const Color taglineColor = Colors.grey; // Grey text for tagline

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🖼 Logo at the Top
              Image.asset(
                'assets/RR12.png',
                width: 250, // Adjust size as needed
                height: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              // 🌿 App Name
              Text(
                'RelaxRead',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: appNameColor, // Fixed color
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 10),

              // 🌱 Tagline
              Text(
                'Discover Malay Stories',
                style: TextStyle(
                  fontSize: 18,
                  color: taglineColor, // Fixed color
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 60),

              // 🛡 Admin Login Button
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
                  icon: const Icon(Icons.admin_panel_settings),
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

              // 👤 User Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(userType: 'User'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
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
    );
  }
}
