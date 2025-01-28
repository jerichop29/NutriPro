// home.dart

import 'dart:io';
import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nutripro/screen/home/benefits/benefits.dart';
import 'package:nutripro/screen/home/insights/insights.dart';
import 'package:page_transition/page_transition.dart';
import 'package:nutripro/functionalities/album.dart';
import 'package:nutripro/functionalities/scan.dart';
import 'package:nutripro/functionalities/real_time.dart';
import 'package:nutripro/components/image_picker.dart';
import 'about/about.dart';
import 'faq/faq.dart';
import '../../components/nav_bar/navigation_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import the package

// Initialize the cameras
late List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false, // Optional: Remove debug banner
  ));
}

class Vegetable {
  final String name;
  final String imagePath;

  Vegetable({required this.name, required this.imagePath});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  File? selectedImage;
  int _currentIndex = 0;
  String? selectedVegetable;
  final List<Vegetable> vegetables = [
    Vegetable(name: 'Broccoli', imagePath: 'assets/images/broccoli.png'),
    Vegetable(name: 'Cauliflower', imagePath: 'assets/images/cauliflower.png'),
    Vegetable(name: 'Cabbage', imagePath: 'assets/images/cabbage.png'),
    Vegetable(name: 'Napa Cabbage', imagePath: 'assets/images/chinese_cabbage.png'),
    Vegetable(name: 'Capsicum', imagePath: 'assets/images/capsicum.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: AnimationLimiter( // Add AnimationLimiter
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'NutriPro',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildOptionButton(
                            context,
                            'Identify',
                            'Image detection',
                            'assets/images/identify.png',
                                () {
                              _showIdentifyOptions(context);
                            },
                          ),
                          _buildOptionButton(
                            context,
                            'Instant',
                            'Real-time detection',
                            'assets/images/instant.png',
                                () {
                              _showVegetableSelection(context, isRealTime: true);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SmallOptionButton(
                            title: 'About',
                            imagePath: 'assets/images/about.png',
                            color: const Color(0xFF8FB5FF),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const AboutScreen(),
                                ),
                              );
                            },
                          ),
                          SmallOptionButton(
                            title: 'Insights',
                            imagePath: 'assets/images/insight.png',
                            color: const Color(0xFFACFFD7),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: InsightsScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SmallOptionButton(
                            title: 'Benefits',
                            imagePath: 'assets/images/benefits.png',
                            color: const Color(0xFFEFB3FF),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const BenefitsScreen(),
                                ),
                              );
                            },
                          ),
                          SmallOptionButton(
                            title: 'FAQ',
                            imagePath: 'assets/images/faq.png',
                            color: const Color(0xFFFFB57F),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: const FaqScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final image = await ImagePickerHelper.pickImageGallery();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AlbumScreen(image: selectedImage!, selectedVegetable: selectedVegetable!),
        ),
      );
    }
  }

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final image = await ImagePickerHelper.pickImageCamera();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ScanScreen(image: selectedImage!, selectedVegetable: selectedVegetable!),
        ),
      );
    }
  }

  // Show vegetable selection modal
  void _showVegetableSelection(BuildContext context, {bool isRealTime = false}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: vegetables.map((vegetable) {
              return ListTile(
                leading: Image.asset(
                  vegetable.imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: Text(vegetable.name),
                onTap: () {
                  setState(() {
                    selectedVegetable = vegetable.name;
                  });
                  Navigator.pop(context);
                  if (isRealTime) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: RealTimeScreen(vegetable: selectedVegetable!),
                      ),
                    );
                  } else {
                    // Handle other navigation if needed
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Show identify options modal
  void _showIdentifyOptions(BuildContext context) {
    // Prompt the user to select a vegetable
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: vegetables.map((vegetable) {
              return ListTile(
                leading: Image.asset(
                  vegetable.imagePath,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                title: Text(vegetable.name),
                onTap: () {
                  setState(() {
                    selectedVegetable = vegetable.name;
                  });
                  Navigator.pop(context); // Close the vegetable selection
                  // After vegetable selection, show the image input options
                  _showImageInputOptions(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Show image input options modal
  void _showImageInputOptions(BuildContext context) {
    // Show the options to either capture an image or upload from the gallery
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture the Image'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload the Image'),
                onTap: () {
                  Navigator.pop(context); // Close the modal
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to build large option buttons
  Widget _buildOptionButton(
      BuildContext context, String title, String subtitle, String imagePath, VoidCallback onPressed) {
    return AnimatedButton(
      color: Colors.white,
      shadowDegree: ShadowDegree.light,
      duration: 50,
      height: 200,
      width: 150,
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

// Remove the old _buildSmallOptionButton method and use SmallOptionButton instead
}

// Define the SmallOptionButton widget with independent press animation
class SmallOptionButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback onPressed;

  const SmallOptionButton({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  _SmallOptionButtonState createState() => _SmallOptionButtonState();
}

class _SmallOptionButtonState extends State<SmallOptionButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) async {
    setState(() {
      _isPressed = false;
    });
    // Optional: Add a slight delay to allow the animation to complete before navigation
    await Future.delayed(const Duration(milliseconds: 5));
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  widget.imagePath,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
