import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart'; // Assuming you have a custom nav bar

class ChineseCabbageScreen extends StatefulWidget {
  const ChineseCabbageScreen({super.key});

  @override
  _ChineseCabbageScreenState createState() => _ChineseCabbageScreenState();
}

class _ChineseCabbageScreenState extends State<ChineseCabbageScreen>
    with SingleTickerProviderStateMixin {
  var _currentIndex = 0; // Track the current navigation index

  late AnimationController _animationController; // Controller for the animation
  late Animation<double> _fadeAnimation; // Animation for the fade effect

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 1), // Animation duration
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    // Dispose of the controller to free up resources
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // AppBar color
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Napa Cabbage Benefits',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Consistent white background
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero section with an image
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Color(0xFFF8FFFC)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FadeTransition(
                      opacity: _fadeAnimation, // Apply the fade animation
                      child: Image.asset(
                        'assets/images/benefits_chinese_cabbage.png', // Hero image for Chinese cabbage
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: const [
                        Text(
                          'Napa Cabbage',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nutrient-Rich & Versatile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Introduction section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Why Chinese Cabbage?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Chinese cabbage, also known as Napa cabbage, is a leafy vegetable that is low in calories and high in essential nutrients. Its versatility makes it popular in many dishes, from salads to stir-fries.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Health Benefits',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Health benefits with icons
                    _buildBenefitItem(
                      Icons.local_florist,
                      'Rich in Nutrients',
                      'Packed with vitamins A, C, K, and minerals like calcium and potassium.',
                    ),
                    _buildBenefitItem(
                      Icons.shield_outlined,
                      'Supports Digestive Health',
                      'High in fiber, promoting healthy digestion and regularity.',
                    ),
                    _buildBenefitItem(
                      Icons.verified,
                      'Antioxidant Properties',
                      'Contains antioxidants that may help reduce inflammation and oxidative stress.',
                    ),
                    _buildBenefitItem(
                      Icons.favorite,
                      'Heart Health',
                      'May help lower cholesterol levels and improve overall heart health.',
                    ),
                    _buildBenefitItem(
                      Icons.accessibility_new,
                      'Weight Management',
                      'Low-calorie vegetable that helps promote fullness and aids in weight control.',
                    ),
                    _buildBenefitItem(
                      Icons.emoji_nature,
                      'Immune Support',
                      'Rich in vitamins A and C for a healthy immune system.',
                    ),
                    _buildBenefitItem(
                      Icons.clean_hands,
                      'Skin Health',
                      'Contains nutrients that support skin health and appearance.',
                    ),
                    const SizedBox(height: 20),
                  ],
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

  // Benefit item with icons
  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
