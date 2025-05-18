import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'home_screen.dart'; // Make sure this path is correct for your project

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin { // Add SingleTickerProviderStateMixin for animations
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Duration of the entrance animation
      vsync: this, // Provide the ticker
    );

    // Define the fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn, // Use an ease-in curve for fading
      ),
    );

    // Define the slide animation
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start slightly below the center
      end: Offset.zero, // End at the center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic, // Use an ease-out cubic curve for sliding
      ),
    );

    // Start the animation when the widget is initialized
    _controller.forward();

    // Timer to navigate to the HomeScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Use pushReplacement to replace the splash screen with the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller when the widget is removed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use a Container with a LinearGradient for a beautiful background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A1B9A), // A slightly brighter purple
              Color(0xFFAD1457), // A slightly brighter pink/maroon
            ],
            begin: Alignment.topLeft, // Start the gradient from top-left
            end: Alignment.bottomRight, // End the gradient at bottom-right
          ),
        ),
        child: Center(
          // Apply fade and slide animations to the content
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App logo/icon with enhanced styling
                  Container(
                    padding: const EdgeInsets.all(24), // Increased padding
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3), // More transparent background
                      shape: BoxShape.circle, // Circular shape
                      boxShadow: [ // Add a more prominent shadow
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.terminal, // Using a terminal icon
                      size: 90, // Slightly larger icon
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40), // Increased spacing

                  // App name with enhanced text style
                  const Text(
                    'LeetCode Tracker',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38, // Larger font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0, // Increased letter spacing
                      shadows: [ // Add text shadow
                        Shadow(
                          color: Colors.black54, // Darker shadow color
                          blurRadius: 6, // Increased blur
                          offset: Offset(3, 3), // Increased offset
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60), // Increased spacing

                  // Loading indicator with enhanced style
                  const SizedBox(
                    width: 60, // Set size for consistency
                    height: 60,
                    child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                  ),
                  ),
                  const SizedBox(height: 24), // Added spacing below indicator

                  // Loading text
                  const Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
