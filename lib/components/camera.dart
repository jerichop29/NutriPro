import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../model/recognition.dart';
import '../model/tf_frame_service.dart';
import 'dart:async';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;
  final String selectedVegetable; // Add selectedVegetable parameter

  const CameraApp({Key? key, required this.camera, required this.selectedVegetable}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  late TensorFlowFrameService tensorFlowService;
  List<Recognition> recognitions = [];
  Timer? _timer;
  Duration _detectionTimeout = Duration(seconds: 3);
  bool _detectionInProgress = false;

  @override
  void initState() {
    super.initState();
    tensorFlowService = TensorFlowFrameService();
    tensorFlowService.loadModels(widget.selectedVegetable); // Load model based on selected vegetable
    initCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void initCamera() {
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) return;
      controller.startImageStream((CameraImage img) async {
        if (_detectionInProgress) {
          return;
        }

        _detectionInProgress = true;
        List<Recognition> newRecognitions = await tensorFlowService.runModelsOnFrame(img);

        setState(() {
          recognitions = newRecognitions;
          if (newRecognitions.isNotEmpty) {
            _resetDetectionTimeout();
          }
        });

        _detectionInProgress = false;
      });
    }).catchError((Object e) {
      // Handle camera exceptions here
    });
  }

  List<Recognition> getRecognitions() {
    return recognitions;
  }

  void _resetDetectionTimeout() {
    _timer?.cancel();
    _timer = Timer(_detectionTimeout, () {
      if (recognitions.isEmpty) {
        setState(() {
          recognitions.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // No UI here; only functionality
  }
}
