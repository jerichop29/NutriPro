import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart'; // Assuming you have a custom nav bar

class CapsicumScreen extends StatefulWidget {
  const CapsicumScreen({super.key});

  @override
  _CapsicumScreenState createState() => _CapsicumScreenState();
}

class _CapsicumScreenState extends State<CapsicumScreen>
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
        backgroundColor: Colors.green.shade600, // Red background for Capsicum
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Capsicum Benefits',
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
                        colors: [Colors.red, Color(0xFFF8FFFC)],
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
                        'assets/images/benefits_capsicum.png', // Hero image for capsicum
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
                          'Capsicum',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nutrient-Rich & Flavorful',
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
                      'Why Capsicum?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Capsicum, also known as bell pepper, is loved for its sweet flavor and crunchy texture. It comes in a variety of colors and is packed with vitamins and antioxidants.',
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
                      'Rich in Vitamins',
                      'High in vitamins A and C for immune function and skin health.',
                    ),
                    _buildBenefitItem(
                      Icons.shield_outlined,
                      'Antioxidant Properties',
                      'Contains antioxidants like carotenoids, which fight oxidative stress.',
                    ),
                    _buildBenefitItem(
                      Icons.visibility,
                      'Supports Eye Health',
                      'Vitamin A contributes to good vision and overall eye health.',
                    ),
                    _buildBenefitItem(
                      Icons.scale,
                      'Weight Management',
                      'Low in calories and high in water content to promote fullness.',
                    ),
                    _buildBenefitItem(
                      Icons.food_bank,
                      'Digestive Health',
                      'Contains dietary fiber, aiding digestion and gut health.',
                    ),
                    _buildBenefitItem(
                      Icons.favorite,
                      'Heart Health',
                      'Rich in potassium, which helps regulate blood pressure.',
                    ),
                    _buildBenefitItem(
                      Icons.local_fire_department,
                      'Improves Metabolism',
                      'Contains capsaicin, which may boost metabolism and promote fat burning.',
                    ),
                    _buildBenefitItem(
                      Icons.face_retouching_natural,
                      'Supports Healthy Skin',
                      'Vitamins A and C help maintain skin health and reduce signs of aging.',
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
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 28, color: Colors.red),
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
