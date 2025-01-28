import 'package:flutter/material.dart';
import '../../components/nav_bar/navigation_bar.dart'; // Adjust this import based on your file structure
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import for animations

class GuideIdentity extends StatefulWidget {
  @override
  _GuideIdentityState createState() => _GuideIdentityState();
}

class _GuideIdentityState extends State<GuideIdentity> {
  int _currentIndex = 1; // State variable for bottom navigation

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
        color: Color(0xFFFFFFFF), // Background color
        child: Center(
          child: SingleChildScrollView(
            child: AnimationLimiter( // Wrap with AnimationLimiter for staggered animations
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
                    // Info Box 1
                    _buildInfoBox(
                      context,
                      "Step 1: Ensure the entire vegetable is captured within the advised distance range",
                      "assets/images/guide1.png",
                    ),
                    // Info Box 2
                    _buildInfoBox(
                      context,
                      "Step 2: Retake if you are dissatisfied with the image, or proceed if it meets the required standards",
                      "assets/images/guide3.png",
                    ),
                    // Info Box 3
                    _buildInfoBox(
                      context,
                      "Step 3: After you proceed, please wait as the app processes your results",
                      "assets/images/guide4.png",
                    ),
                    // Info Box 4
                    _buildInfoBox(
                      context,
                      "Step 4: Once the app has finished processing, you can check the results",
                      "assets/images/guide5.png",
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
          // Handle navigation based on the selected index
        },
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, String text, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced vertical margin
      padding: const EdgeInsets.all(16), // Increased padding for more space
      decoration: BoxDecoration(
        color: Color(0x4C9CFFD9),
        borderRadius: BorderRadius.circular(12), // Reduced border radius
      ),
      constraints: BoxConstraints(minHeight: 150), // Set minimum height for the container
      child: Row(
        children: [
          Container(
            width: 60, // Reduced width
            height: 60, // Reduced height
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 36, // Reduced width
                height: 36, // Reduced height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath), // Use your asset image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), // Reduced space between image and text
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: text.split(":")[0] + ": ", // Step number part
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18, // Font size for step number
                    ),
                  ),
                  TextSpan(
                    text: text.split(":")[1], // Instruction part
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18, // Font size for instruction
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
