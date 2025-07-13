import 'package:flutter/material.dart';
import 'create_account.dart'; // Import the create account screen for navigation

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a slightly different green color for the Login page
    // This helps differentiate it from the Create Account page while maintaining theme
    const Color loginPrimaryGreen = Color(
      0xFF5A7F30,
    ); // A slightly darker/different green

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
                    'Welcome Back!', // Changed title for login page
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color:
                          loginPrimaryGreen, // Apply the new login-specific green color
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
                    ),
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
                        color: loginPrimaryGreen,
                        width: 2.0,
                      ), // Use new green
                    ),
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
                    ),
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
                        color: loginPrimaryGreen,
                        width: 2.0,
                      ), // Use new green
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ), // Smaller space before forgot password
                // Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot Password pressed!'),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          loginPrimaryGreen, // Use new green for the link
                      padding: EdgeInsets.zero, // Remove default padding
                      minimumSize: Size.zero, // Remove minimum size constraints
                      tapTargetSize:
                          MaterialTapTargetSize.shrinkWrap, // Shrink tap target
                    ),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 24), // Space before login button
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    // Login action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login button pressed!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        loginPrimaryGreen, // Solid new green background
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
                  child: const Text('Login'),
                ),
                const SizedBox(height: 12), // Space after login button
                const SizedBox(
                  height: 16,
                ), // Space before "Don't have an account?"
                // Don't have an account? Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Create Account screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Navigate to Sign Up!')),
                        );
                        Navigator.push(
                          // Uncommented navigation
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            loginPrimaryGreen, // Use new green for the link
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Sign Up',
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
