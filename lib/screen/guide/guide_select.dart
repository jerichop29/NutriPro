// guide_select.dart

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'; // Import for PageTransition
import 'guide_identity.dart';
import '../guide/guide_instant.dart';
import '../../components/nav_bar/navigation_bar.dart'; // Adjust this import based on your file structure
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import for animations

class GuideSelect extends StatefulWidget {
  @override
  _GuideSelectState createState() => _GuideSelectState();
}

class _GuideSelectState extends State<GuideSelect> {
  int _currentIndex = 1; // State variable for bottom navigation
  bool _isButtonPressedIdentify = false;
  bool _isButtonPressedInstant = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '📖 Guide',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        width: double.infinity, // Make the container fill the width
        height: double.infinity, // Make the container fill the height
        color: Color(0xFFFFFFFF), // Set the background color
        child: Center(
          child: SingleChildScrollView(
            child: AnimationLimiter( // Wrap with AnimationLimiter
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    // Introductory Text
                    SizedBox(
                      height: 50,
                      child: Text(
                        'Hi, how can we help you?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between the text and image

                    // Animated Image
                    Container(
                      width: 252,
                      height: 252,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/guide_select.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between the image and buttons

                    // Animated Option Buttons
                    AnimationConfiguration.staggeredList(
                      position: 0,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Identify Button
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isButtonPressedIdentify = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isButtonPressedIdentify = false;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GuideIdentity()),
                                  );
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _isButtonPressedIdentify = false;
                                  });
                                },
                                child: AnimatedScale(
                                  scale: _isButtonPressedIdentify ? 0.95 : 1.0,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                  child: _buildOptionButton(
                                    context,
                                    'Identify',
                                    'Image detection',
                                    'assets/images/identify.png',
                                  ),
                                ),
                              ),

                              // Instant Button
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isButtonPressedInstant = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isButtonPressedInstant = false;
                                  });
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: GuideInstant(),
                                    ),
                                  );
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _isButtonPressedInstant = false;
                                  });
                                },
                                child: AnimatedScale(
                                  scale: _isButtonPressedInstant ? 0.95 : 1.0,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeInOut,
                                  child: _buildOptionButton(
                                    context,
                                    'Instant',
                                    'Real-time detection',
                                    'assets/images/instant.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Add navigation logic based on index if necessary
        },
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, String subtitle, String imagePath) {
    return Container(
      width: 158.18,
      height: 240.07,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 74.44,
            height: 75.83,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath), // Use asset image
                fit: BoxFit.fill,
              ),
            ),
          ),
          SizedBox(height: 10), // Spacing between image and title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5), // Spacing between title and description
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
