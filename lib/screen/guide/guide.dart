// guide_screen.dart

import 'package:flutter/material.dart';
import '../../components/nav_bar/navigation_bar.dart';
import 'guide_select.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import for animations

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> with SingleTickerProviderStateMixin {
  var _currentIndex = 1;
  bool _isButtonPressed = false;

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
                    // Animated Image
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/guide.welcome.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing between the image and text

                    // Title Text
                    Text(
                      'Welcome to NutriPro',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10), // Spacing between the title and description

                    // Description Text
                    SizedBox(
                      width: 230,
                      child: Text(
                        'Experiencing difficulties with NutriPro?\nRest assured, we are here to provide you with assistance.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Spacing before the button

                    // Animated Button
                    GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GuideSelect()),
                        );
                      },
                      onTapCancel: () {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      },
                      child: AnimatedScale(
                        scale: _isButtonPressed ? 0.95 : 1.0,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: 258,
                          height: 83,
                          decoration: BoxDecoration(
                            color: Color(0xFF9CFFD9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Proceed',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
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
}
