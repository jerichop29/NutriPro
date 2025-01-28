import 'package:flutter/material.dart';

class Faq5 extends StatelessWidget {
  const Faq5({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6, // 60% of the screen height
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add an image or icon at the top for better engagement
              Center(
                child: Image.asset(
                  'assets/images/question.png', // Replace with your actual image path
                  height: 120, // Adjust image size for 60% screen
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Main question with larger text size and color
              const Text(
                'What types of produce can NutriPro detect?',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFF2C8960),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 20),

              // Engaging content with more structured text and added emphasis
              const Text(
                'NutriPro can currently recognize a few fruits and vegetables. Here’s a list of some produce it can detect:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5, // Adds better line spacing for readability
                ),
              ),
              const SizedBox(height: 20),

              // Bullet points or structured information with icons for engagement
              buildBulletPoint(
                'assets/images/answer.png', // Replace with actual icon
                'Fruits',
                'Dragon fruit, lemon, mango, pear, and mangosteen.',
              ),
              const SizedBox(height: 15),
              buildBulletPoint(
                'assets/images/answer.png', // Replace with actual icon
                'Vegetables',
                'Asparagus, capsicum, broccoli, cauliflower, and bottle gourd.',
              ),
              const SizedBox(height: 20),

              // Final call-to-action or motivational content
              const Text(
                'We are constantly updating our database to include more produce types, so stay tuned for updates!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2C8960),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Move textAlign here in the Text widget
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A helper function to create bullet points with an icon and text
  Widget buildBulletPoint(String iconPath, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          iconPath,
          width: 30,
          height: 30,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
