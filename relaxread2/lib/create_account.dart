import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page for navigation

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the custom green color from the screenshot
    const Color primaryGreen = Color(
      0xFF6B923C,
    ); // Approximate color from screenshot

    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F2EB,
      ), // Light background color for the overall screen
      body: Center(
        // Center the content on the screen
        child: Card(
          // Use Card widget for the white, rounded background
          margin: const EdgeInsets.all(24.0), // Margin around the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16.0,
            ), // Rounded corners for the card
          ),
          elevation: 4.0, // Subtle shadow for the card
          child: SingleChildScrollView(
            // Allow content to scroll if it overflows
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 40.0,
            ), // Padding inside the card
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Make column only take up needed space
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children horizontally
              children: [
                Align(
                  // Align title to the center
                  alignment: Alignment.center,
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen, // Apply the custom green color
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Space after the title
                // Email Address Field
                const Text(
                  'Email address',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8), // Space between label and text field
                TextField(
                  decoration: InputDecoration(
                    hintText: 'you@example.com', // Placeholder text
                    isDense: true, // Make text field compact
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ), // Added horizontal padding
                    // --- START: Changes for box border ---
                    border: OutlineInputBorder(
                      // Default border
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // Border when not focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border when focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: primaryGreen,
                        width: 2.0,
                      ),
                    ),
                    // --- END: Changes for box border ---
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24), // Space between fields
                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter password',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ), // Added horizontal padding
                    // --- START: Changes for box border ---
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: primaryGreen,
                        width: 2.0,
                      ),
                    ),
                    // --- END: Changes for box border ---
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Confirm Password Field
                const Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 12.0,
                    ), // Added horizontal padding
                    // --- START: Changes for box border ---
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border when focused
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: primaryGreen,
                        width: 2.0,
                      ),
                    ),
                    // --- END: Changes for box border ---
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40), // More space before the button
                // Sign Up Button
                ElevatedButton(
                  onPressed: () {
                    // Sign Up action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign Up button pressed!')),
                    );
                    // Navigate to Login screen after successful sign-up
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen, // Solid green background
                    foregroundColor: Colors.white, // White text color
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ), // Button padding
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        8.0,
                      ), // Rounded corners for button
                    ),
                    elevation: 0, // No shadow for this button
                  ),
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 16),

                // "or" text
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'or',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 16),

                // Sign up with Google Button
                OutlinedButton(
                  onPressed: () {
                    // Google sign up action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sign up with Google pressed!'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white, // White background
                    foregroundColor: primaryGreen, // Green text color
                    side: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.0,
                    ), // Light grey border
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 20.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Keep row compact
                    children: [
                      // Placeholder for Google logo - you need to add this asset
                      // For simplicity, using a generic icon that looks like 'G'
                      // If you want the exact G, you'd use Image.asset('assets/google_logo.png')
                      Icon(
                        Icons.g_mobiledata,
                        color: primaryGreen,
                        size: 28,
                      ), // Using an icon that resembles G
                      const SizedBox(width: 8),
                      const Text('Sign up with Google'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ), // Space before "Already have an account?"
                // Already have an account? Sign In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Login screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigate to Login!')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            primaryGreen, // Green text for the link
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
