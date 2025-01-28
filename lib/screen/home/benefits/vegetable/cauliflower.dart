import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart'; // Assuming you have a custom nav bar

class CauliflowerScreen extends StatefulWidget {
  const CauliflowerScreen({super.key});

  @override
  _CauliflowerScreenState createState() => _CauliflowerScreenState();
}

class _CauliflowerScreenState extends State<CauliflowerScreen>
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
        backgroundColor: Colors.green.shade600, // Consistent green background
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cauliflower Benefits',
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
                        colors: [Colors.orange, Color(0xFFF8FFFC)],
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
                        'assets/images/benefits_cauliflower.png', // Hero image for cauliflower
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
                          'Cauliflower',
                          style: TextStyle(
                            fontSize: 40,
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
                      'Why Cauliflower?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cauliflower is a versatile and low-calorie vegetable that is a great source of vitamins and minerals. It can be used in a variety of dishes, making it a staple in many diets.',
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
                      'Nutrient-Rich',
                      'Low in calories, rich in vitamins C, K, B6, and minerals.',
                    ),
                    _buildBenefitItem(
                      Icons.shield_outlined,
                      'Antioxidant Power',
                      'Contains glucosinolates that protect cells and reduce chronic disease risks.',
                    ),
                    _buildBenefitItem(
                      Icons.scale,
                      'Weight Management',
                      'High-fiber food that helps in fullness and weight control.',
                    ),
                    _buildBenefitItem(
                      Icons.food_bank,
                      'Digestive Health',
                      'High fiber supports digestion and gut health.',
                    ),
                    _buildBenefitItem(
                      Icons.health_and_safety,
                      'Immune Boost',
                      'Rich in vitamin C for strong immunity.',
                    ),
                    _buildBenefitItem(
                      Icons.favorite,
                      'Heart Health',
                      'Improves cholesterol, circulation, and may reduce blood pressure.',
                    ),
                    _buildBenefitItem(
                      Icons.memory,
                      'Brain Health',
                      'Choline supports cognitive function and memory.',
                    ),
                    _buildBenefitItem(
                      Icons.local_fire_department,
                      'Detoxification',
                      'Helps the liver detoxify and remove toxins.',
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
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 28, color: Colors.orange),
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
