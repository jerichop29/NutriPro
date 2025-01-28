import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart';

class BroccoliScreen extends StatefulWidget {
  const BroccoliScreen({super.key});

  @override
  _BroccoliScreenState createState() => _BroccoliScreenState();
}

class _BroccoliScreenState extends State<BroccoliScreen>
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
        backgroundColor: Colors.green.shade600, // Set background color
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Broccoli Benefits',
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
        color: Colors.white, // Set consistent background color for the entire body
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Hero section with engaging image and gradient
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.green, Color(0xFFffffff)],
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
                        'assets/images/benefits_broccoli.png', // Hero image for broccoli
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
                          'Broccoli',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nature’s Powerhouse of Nutrients',
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
                      'Why Broccoli?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Broccoli is packed with nutrients and offers numerous health benefits. It’s an excellent source of vitamins, minerals, fiber, and antioxidants.',
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
                      'Packed with vitamins C, K, folate, and fiber.',
                    ),
                    _buildBenefitItem(
                      Icons.shield_outlined,
                      'Antioxidant Power',
                      'Contains sulforaphane, reducing inflammation and chronic diseases.',
                    ),
                    _buildBenefitItem(
                      Icons.health_and_safety,
                      'Immune Support',
                      'Boosts immunity with high vitamin C levels.',
                    ),
                    _buildBenefitItem(
                      Icons.food_bank,
                      'Digestive Health',
                      'Fiber promotes gut health and regularity.',
                    ),
                    _buildBenefitItem(
                      Icons.fitness_center,
                      'Bone Strength',
                      'Rich in vitamin K and calcium for strong bones.',
                    ),
                    _buildBenefitItem(
                      Icons.scale,
                      'Weight Management',
                      'Low-calorie, high-fiber food that helps you stay full longer.',
                    ),
                    _buildBenefitItem(
                      Icons.favorite,
                      'Heart Health',
                      'Helps lower cholesterol and supports cardiovascular health.',
                    ),
                    _buildBenefitItem(
                      Icons.face_retouching_natural,
                      'Skin Health',
                      'Vitamins C and E protect skin and boost collagen.',
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
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 28, color: Colors.green),
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
