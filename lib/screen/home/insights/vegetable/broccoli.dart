import 'package:flutter/material.dart';
import '../../../../components/nav_bar/navigation_bar.dart';

class BroccoliPage extends StatefulWidget {
  const BroccoliPage({super.key});

  @override
  _BroccoliPageState createState() => _BroccoliPageState();
}

class _BroccoliPageState extends State<BroccoliPage> with SingleTickerProviderStateMixin {
  var _currentIndex = 0; // Track current tab index
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
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '👁️‍🗨️ Broccoli Facts',
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
                  'assets/images/broccoli.png',
                  width: 300,
                  height: 250,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Broccoli',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 0),
            const Text(
              'Nutritional Facts',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 0),
            const Text(
              'per 100 grams',
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 40),
            // Macronutrient information
            const NutrientRow(nutrient: 'Calories', value: '20 kcal', fontSize: 20),
            const NutrientRow(nutrient: 'Carbohydrates', value: '3.9 grams', fontSize: 20),
            const NutrientRow(nutrient: 'Protein', value: '2.2 grams', fontSize: 20),
            const NutrientRow(nutrient: 'Fat', value: '0.1 grams', fontSize: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index when a new tab is selected
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
