import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:nutripro/functionalities/output/criteria.dart';
import '../model/recognition.dart';
import '../model/tf_frame_service.dart';
import '../components/nav_bar/navigation_bar.dart';
import 'dart:async';

import 'output/bounding_box.dart';

class RealTimeScreen extends StatefulWidget {
  final String vegetable;
  const RealTimeScreen({super.key, required this.vegetable});

  @override
  _RealTimeScreenState createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends State<RealTimeScreen> {
  late Future<List<CameraDescription>> _cameraFuture;
  CameraController? controller;
  late TensorFlowFrameService tensorFlowService;
  List<Recognition> recognitions = [];
  Timer? _timer;
  final Duration _detectionTimeout = const Duration(seconds: 3);
  bool _detectionInProgress = false;

  @override
  void initState() {
    super.initState();
    _cameraFuture = availableCameras();
    tensorFlowService = TensorFlowFrameService();
    tensorFlowService.loadModels(widget.vegetable);
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void initCamera(CameraDescription camera) async {
    controller = CameraController(camera, ResolutionPreset.max);
    await controller!.initialize().then((_) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {}); // Refresh UI to show camera preview
      controller!.startImageStream((CameraImage img) async {
        if (_detectionInProgress) return;

        _detectionInProgress = true;
        try {
          List<Recognition> newRecognitions = await tensorFlowService.runModelsOnFrame(img);
          if (!mounted) return; // Check if the widget is still mounted
          setState(() {
            recognitions = newRecognitions;
            if (newRecognitions.isNotEmpty) {
              _resetDetectionTimeout();
            }
          });
        } catch (e) {
          // Handle exceptions during detection
        } finally {
          _detectionInProgress = false; // Ensure the detection flag is reset
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        // Handle camera exceptions if needed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CameraDescription>>(
      future: _cameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text('No cameras found.'),
            ),
          );
        } else if (snapshot.hasData) {
          if (controller == null || !controller!.value.isInitialized) {
            initCamera(snapshot.data![0]); // Initialize camera if not already done
          }

          var _currentIndex = 0; // Maintain current index for bottom navigation
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                controller != null && controller!.value.isInitialized
                    ? SizedBox.expand(
                  child: AspectRatio(
                    aspectRatio: controller!.value.aspectRatio,
                    child: CameraPreview(controller!),
                  ),
                )
                    : const Center(child: CircularProgressIndicator()),
                if (recognitions.isNotEmpty)
                  Stack(
                    children: recognitions.map((recognition) {
                      double scaleX = MediaQuery.of(context).size.width / controller!.value.previewSize!.height;
                      double scaleY = MediaQuery.of(context).size.height / controller!.value.previewSize!.width;
                      return BoundingBox.drawBoundingBox(recognition, scaleX, scaleY, widget.vegetable);
                    }).toList(),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                    title: const Text(
                      'NutriPro',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                        fontSize: 35,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30, color: Color(0xFFFFFFFF)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 100.0, // Adjust this value for vertical positioning
                  right: 10.0, // Adjust this value for horizontal positioning
                  child: Container(
                    width: 40.0, // Set the width of the container
                    height: 40.0, // Set the height of the container
                    child: FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent, // Make the background transparent
                              child: Criteria(), // Show the Criteria widget
                            );
                          },
                        );
                      },
                      backgroundColor: Colors.green, // Background color of the FAB
                      child: Center( // Center the image inside the FAB
                        child: Image.asset(
                          'assets/images/grade.png', // Your asset image path
                          color: Colors.white,
                          fit: BoxFit.contain, // Ensure the whole image is contained
                          width: 30.0, // Set the width of the image
                          height: 30.0, // Set the height of the image
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
        } else {
          return const Scaffold(
            body: Center(
              child: Text('Unknown error occurred.'),
            ),
          );
        }
      },
    );
  }

  void _resetDetectionTimeout() {
    _timer?.cancel();
    _timer = Timer(_detectionTimeout, () {
      if (mounted) {
        setState(() {
          recognitions.clear();
        });
      }
    });
  }
}
