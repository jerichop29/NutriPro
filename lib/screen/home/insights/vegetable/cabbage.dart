import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart'; // Assuming you have a custom navigation bar

class CabbagePage extends StatefulWidget {
  const CabbagePage({super.key});

  @override
  _CabbagePageState createState() => _CabbagePageState();
}

class _CabbagePageState extends State<CabbagePage> with SingleTickerProviderStateMixin {
  var _currentIndex = 0; // Track current tab index for navigation
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // Fresh green AppBar for CabbagePage
        elevation: 0, // Remove shadow
        title: const Text(
          '👁️‍🗨️ Cabbage Facts',
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
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated image
            ScaleTransition(
              scale: _animation,
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  'assets/images/cabbage.png', // Replace with your image path
                  width: 250,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cabbage',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nutritional Facts',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'per 100 grams',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 40),
            // Macronutrient information
            const NutrientRow(nutrient: 'Calories', value: '25 kcal', fontSize: 20),
            const NutrientRow(nutrient: 'Carbohydrates', value: '5.8 grams', fontSize: 20),
            const NutrientRow(nutrient: 'Protein', value: '1.3 grams', fontSize: 20),
            const NutrientRow(nutrient: 'Fat', value: '0.1 grams', fontSize: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Handle navigation logic here based on the index selected
          });
        },
      ),
    );
  }
}

class NutrientRow extends StatelessWidget {
  final String nutrient;
  final String value;
  final double fontSize;

  const NutrientRow({
    super.key,
    required this.nutrient,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$nutrient: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
