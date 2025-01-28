import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nutripro/screen/home/insights/vegetable/broccoli.dart';
import 'package:nutripro/screen/home/insights/vegetable/cabbage.dart';
import 'package:nutripro/screen/home/insights/vegetable/capsicum.dart';
import 'package:nutripro/screen/home/insights/vegetable/cauliflower.dart';
import 'package:nutripro/screen/home/insights/vegetable/chinese_cabbage.dart';
import '../../../components/nav_bar/navigation_bar.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '👁️‍🗨️ Nutritional Insights',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adding the introductory text for the screen
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.touch_app, size: 28, color: Colors.green),
                    const SizedBox(width: 10),
                    Flexible(
                      child: const Text(
                        'Tap to Explore Nutritional Facts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Discover the unique nutrients of each vegetable. Tap any vegetable to learn more about its health impact!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 30),
                // Using staggered grid with animations
                Expanded(
                  child: AnimationLimiter(
                    child: GridView.builder(
                      itemCount: _vegetables.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Two columns in the grid
                        crossAxisSpacing: 15, // Spacing between columns
                        mainAxisSpacing: 15, // Spacing between rows
                        childAspectRatio: 0.7, // Adjust the size to avoid overflow issues
                      ),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          columnCount: 2,
                          child: ScaleAnimation(
                            scale: 0.5,
                            child: FadeInAnimation(
                              child: _buildVegetableCard(
                                context,
                                _vegetables[index]['title']!,
                                _vegetables[index]['imagePath']!,
                                _vegetables[index]['highlight']!, // Nutrient highlight
                                _vegetables[index]['color']!, // Background color for the card
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildVegetableCard(BuildContext context, String title, String imagePath, String highlight, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'Cabbage':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CabbagePage()));
            break;
          case 'Napa Cabbage':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChineseCabbagePage()));
            break;
          case 'Broccoli':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BroccoliPage()));
            break;
          case 'Capsicum':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CapsicumPage()));
            break;
          case 'Cauliflower':
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CauliflowerPage()));
            break;
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: title,
              child: Image.asset(
                imagePath,
                width: 100, // Reduced width to avoid overflow
                height: 100, // Reduced height to avoid overflow
              ),
            ),
            const SizedBox(height: 10),
            Flexible( // Wrap text in flexible to avoid overflow
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center text to keep the layout consistent
                overflow: TextOverflow.ellipsis, // Ellipsis to prevent text from overflowing
              ),
            ),
            const SizedBox(height: 5),
            _buildNutrientBadge(highlight),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientBadge(String highlight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        highlight,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> _vegetables = [
    {'title': 'Broccoli', 'imagePath': 'assets/images/broccoli.png', 'highlight': 'High in Vitamin C', 'color': Colors.green},
    {'title': 'Cabbage', 'imagePath': 'assets/images/cabbage.png', 'highlight': 'Rich in Fiber', 'color': Colors.purple},
    {'title': 'Capsicum', 'imagePath': 'assets/images/capsicum.png', 'highlight': 'High in Antioxidants', 'color': Colors.red},
    {'title': 'Cauliflower', 'imagePath': 'assets/images/cauliflower.png', 'highlight': 'High in Fiber', 'color': Colors.orange},
    {'title': 'Napa Cabbage', 'imagePath': 'assets/images/chinese_cabbage.png', 'highlight': 'Low in Calories', 'color': Colors.yellow},
  ];
}
