import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the HomePage to navigate to it after the delay
import 'dart:async'; // Required for Future.delayed (Timer)

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 3 seconds
    Timer(const Duration(seconds: 3), () {
      // After 3 seconds, navigate to the HomePage
      // pushReplacement removes the current route (WelcomePage) from the stack
      // so the user can't go back to it using the back button.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background with a subtle pattern
      backgroundColor: const Color(0xFFF0F2EB), // Base background color
      body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon - represented by a black square with a white icon for now
              // In a real app, you'd use Image.asset('assets/nusa_pages_logo.png')
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
              const SizedBox(height: 10), // Space between app name and tagline
              // Tagline
              Text(
                'Discover Malay Stories', // Your tagline
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600], // Lighter grey for tagline
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
