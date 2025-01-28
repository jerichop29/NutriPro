import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../components/nav_bar/navigation_bar.dart';
import 'faq1.dart';
import 'faq2.dart';
import 'faq3.dart';
import 'faq4.dart';
import 'faq5.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int _currentIndex = 0; // Initialize the currentIndex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '⁉️ FAQ',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              const SizedBox(height: 20),
              // Introduction Section with Image
              Center(
                child: Image.asset(
                  'assets/images/faq.png', // Replace with your actual image path
                  height: 180,
                  width: 180,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Get Answers to Your Questions!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF3A3A3A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Here are the answers to some of the most frequently asked questions about NutriPro. Tap on any question below to explore more.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // FAQ List with New Design - Cards
              _buildFaqCard(
                'What is NutriPro?',
                'Get to know what NutriPro is all about!',
                'assets/images/question.png',
                const Faq1(),
              ),
              _buildFaqCard(
                'How does NutriPro work?',
                'Learn how NutriPro helps you with freshness!',
                'assets/images/question.png',
                const Faq2(),
              ),
              _buildFaqCard(
                'Who can benefit from using NutriPro?',
                'Find out who NutriPro is designed for.',
                'assets/images/question.png',
                const Faq3(),
              ),
              _buildFaqCard(
                'Is NutriPro available on both iOS and Android?',
                'Explore which platforms support NutriPro.',
                'assets/images/question.png',
                const Faq4(),
              ),
              _buildFaqCard(
                'How accurate is NutriPro\'s freshness classification?',
                'Discover how reliable NutriPro’s data is.',
                'assets/images/question.png',
                const Faq5(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex, // Pass the initialized index
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // Build Card for each FAQ with staggered animation
  Widget _buildFaqCard(String title, String subtitle, String iconPath, Widget faqScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.white,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return faqScreen;
            },
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4), // Shadow effect for depth
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon for each FAQ
              Image.asset(
                iconPath,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

