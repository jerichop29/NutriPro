import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../components/nav_bar/navigation_bar.dart'; // Custom navigation bar import

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  var _currentIndex = 0; // Track current tab index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          'ℹ️ About',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: AnimationLimiter(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              // Add a top header image or icon for NutriPro branding
              Image.asset(
                'assets/images/vegetables.png', // Replace with a relevant image
                height: 120,
              ),
              const SizedBox(height: 20),

              // Main title text
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Freshness at Your Fingertips!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Feature items
              _buildFeatureItem(
                icon: Icons.camera_alt,
                color: Colors.green,
                title: 'Vegetable Scanning',
                description:
                'Scan vegetables instantly using your device\'s camera and get results.',
              ),
              _buildFeatureItem(
                icon: Icons.star,
                color: Colors.orange,
                title: 'Freshness Rating',
                description:
                'Receive detailed feedback on the freshness and quality of your vegetables.',
              ),
              _buildFeatureItem(
                icon: Icons.lightbulb,
                color: Colors.blue,
                title: 'Smart Suggestions',
                description:
                'Get expert tips on storing and maintaining the freshness of vegetables.',
              ),
              _buildFeatureItem(
                icon: Icons.face,
                color: Colors.purple,
                title: 'User-Friendly',
                description:
                'NutriPro is designed to be simple, intuitive, and accessible for all users.',
              ),
              const SizedBox(height: 30),

              // Bottom description or call to action
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Text(
                  'At NutriPro, we strive to make healthy eating smarter and easier. Join us in bringing freshness to your plate!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Widget to build each feature item with icon and description
  Widget _buildFeatureItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          _buildFeatureIcon(icon, color),
          const SizedBox(width: 10),
          Expanded(
            child: _buildFeatureDescription(title, description),
          ),
        ],
      ),
    );
  }

  // Widget to build an icon for each feature
  Widget _buildFeatureIcon(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 30,
        color: color,
      ),
    );
  }

  // Widget to build each feature description
  Widget _buildFeatureDescription(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
