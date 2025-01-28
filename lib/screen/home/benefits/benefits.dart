import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../components/nav_bar/navigation_bar.dart'; // CustomNavBar included
import 'package:nutripro/screen/home/benefits/vegetable/broccoli.dart';
import 'package:nutripro/screen/home/benefits/vegetable/cabbage.dart';
import 'package:nutripro/screen/home/benefits/vegetable/capsicum.dart';
import 'package:nutripro/screen/home/benefits/vegetable/cauliflower.dart';
import 'package:nutripro/screen/home/benefits/vegetable/chinese_cabbage.dart';

class BenefitsScreen extends StatefulWidget {
  const BenefitsScreen({super.key});

  @override
  _BenefitsScreenState createState() => _BenefitsScreenState();
}

class _BenefitsScreenState extends State<BenefitsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '👁️‍🗨️ Benefits',
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              // Image as a separate item
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(
                  'assets/images/benefits.png', // Replace with your actual image path
                  width: 120, // Smaller image
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing

              // Title text as a separate item
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Why Vegetables are Essential!',
                  style: TextStyle(
                    fontSize: 16, // Reduced font size
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5), // Reduced spacing

              // Description text as a separate item
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Packed with nutrients, vegetables help maintain a healthy lifestyle. Explore the benefits below!',
                  style: TextStyle(fontSize: 14, color: Colors.black87), // More compact text
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10), // Add space before the vegetable list

              // Vegetable Cards with tap animation
              VegetableItem(
                title: 'Broccoli',
                imagePath: 'assets/images/broccoli.png',
                color: Colors.greenAccent,
                destinationScreen: const BroccoliScreen(),
              ),
              _buildDivider(),
              VegetableItem(
                title: 'Cabbage',
                imagePath: 'assets/images/cabbage.png',
                color: Colors.purpleAccent,
                destinationScreen: const CabbageScreen(),
              ),
              _buildDivider(),
              VegetableItem(
                title: 'Capsicum',
                imagePath: 'assets/images/capsicum.png',
                color: Colors.redAccent,
                destinationScreen: const CapsicumScreen(),
              ),
              _buildDivider(),
              VegetableItem(
                title: 'Cauliflower',
                imagePath: 'assets/images/cauliflower.png',
                color: Colors.orangeAccent,
                destinationScreen: const CauliflowerScreen(),
              ),
              _buildDivider(),
              VegetableItem(
                title: 'Chinese Cabbage',
                imagePath: 'assets/images/chinese_cabbage.png',
                color: Colors.lightBlueAccent,
                destinationScreen: const ChineseCabbageScreen(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar( // Your custom navigation bar
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  // Custom divider to separate items with unique style
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.redAccent],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.star, color: Colors.orangeAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.redAccent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// VegetableItem StatefulWidget with tap animation
class VegetableItem extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color color;
  final Widget destinationScreen;

  const VegetableItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.destinationScreen,
  });

  @override
  _VegetableItemState createState() => _VegetableItemState();
}

class _VegetableItemState extends State<VegetableItem> {
  bool _isButtonPressed = false; // Track button press state

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isButtonPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isButtonPressed = false;
    });
    // Navigate to the destination screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget.destinationScreen),
    );
  }

  void _onTapCancel() {
    setState(() {
      _isButtonPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,   // Handle tap down
      onTapUp: _onTapUp,       // Handle tap up
      onTapCancel: _onTapCancel, // Handle tap cancel
      child: AnimatedScale(
        scale: _isButtonPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.7), // Semi-transparent vibrant colors
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular image container
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Text column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Tap to explore',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
