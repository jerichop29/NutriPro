import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';
import '../model/recognition.dart';
import 'dart:async';

class TensorFlowFrameService {
  late FlutterVision _vision;
  bool _isProcessing = false;
  String? _currentModelPath;
  String? _currentLabelPath;

  TensorFlowFrameService() {
    _vision = FlutterVision();
  }

  Future<void> loadModels(String vegetable) async {
    String modelPath;
    String labelPath;

    // Choose model paths based on selected vegetable
    switch (vegetable.toLowerCase()) {
      case 'broccoli':
        modelPath = 'assets/model/detection/broccoli.tflite';
        labelPath = 'assets/model/detection/broccoli.txt';
        break;
      case 'cabbage':
        modelPath = 'assets/model/detection/cabbage.tflite';
        labelPath = 'assets/model/detection/cabbage.txt';
        break;
      case 'cauliflower':
        modelPath = 'assets/model/detection/cauliflower.tflite';
        labelPath = 'assets/model/detection/cauliflower.txt';
        break;
      case 'capsicum':
        modelPath = 'assets/model/detection/capsicum.tflite';
        labelPath = 'assets/model/detection/capsicum.txt';
        break;
      case 'napa cabbage':
        modelPath = 'assets/model/detection/napa.tflite';
        labelPath = 'assets/model/detection/napa.txt';
        break;
    // Add cases for other vegetables as needed
      default:
        throw Exception('Unsupported vegetable: $vegetable');
    }

    // If the same model is already loaded, skip loading
    if (_currentModelPath == modelPath) {
      print('Model already loaded: $modelPath');
      return;
    }

    try {
      // Close the currently loaded model if it exists
      if (_currentModelPath != null) {
        await close();
      }

      // Load the new model
      await _vision.loadYoloModel(
        labels: labelPath,
        modelPath: modelPath,
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: true,
      );
      print('Detection model loaded successfully: $modelPath');

      // Update current model paths
      _currentModelPath = modelPath;
      _currentLabelPath = labelPath;
    } catch (e) {
      print('Failed to load models: $e');
    }
  }

  Future<List<Recognition>> runModelsOnFrame(CameraImage img) async {
    if (_isProcessing) return [];
    _isProcessing = true;

    try {
      final detectionResult = await _vision.yoloOnFrame(
        bytesList: img.planes.map((plane) => plane.bytes).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.1,
      );

      print('Detection result: $detectionResult');

      double confidenceThreshold = 0.4;
      List<Recognition> recognitionList = detectionResult.map<Recognition>((item) {
        try {
          return Recognition.fromJson(item);
        } catch (e) {
          print('Error parsing detection item: $e');
          return null as Recognition;
        }
      }).whereType<Recognition>().where((recognition) {
        return recognition.confidenceInClass >= confidenceThreshold;
      }).toList();

      // Sort by confidence and only take the highest-confidence result
      recognitionList.sort((a, b) => b.confidenceInClass.compareTo(a.confidenceInClass));
      if (recognitionList.isNotEmpty) {
        recognitionList = [recognitionList.first]; // Keep only the highest-confidence detection
      }

      _isProcessing = false;
      return recognitionList;
    } catch (e) {
      print('Error running models on frame: $e');
      _isProcessing = false;
      return [];
    }
  }


  Future<void> close() async {
    await _vision.closeYoloModel();
    _currentModelPath = null; // Reset the current model path
    _currentLabelPath = null; // Reset the current label path
  }
}
