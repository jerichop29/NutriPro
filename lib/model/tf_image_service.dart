import 'package:flutter_vision/flutter_vision.dart';
import '../model/recognition.dart';
import 'dart:async';
import 'dart:typed_data';

class TensorFlowImageService {
  late FlutterVision _vision;
  bool _isProcessing = false;

  TensorFlowImageService() {
    _vision = FlutterVision();
  }

  // Load the appropriate model based on the selected vegetable
  Future<void> loadModel(String vegetableType) async {
    String modelPath = '';
    String labelsPath = '';

    switch (vegetableType.toLowerCase()) {
      case 'broccoli':
        modelPath = 'assets/model/detection/broccoli.tflite';
        labelsPath = 'assets/model/detection/broccoli.txt';
        break;
      case 'cauliflower':
        modelPath = 'assets/model/detection/cauliflower.tflite';
        labelsPath = 'assets/model/detection/cauliflower.txt';
        break;
      case 'cabbage':
        modelPath = 'assets/model/detection/cabbage.tflite';
        labelsPath = 'assets/model/detection/cabbage.txt';
        break;
      case 'napa cabbage':
        modelPath = 'assets/model/detection/napa.tflite';
        labelsPath = 'assets/model/detection/napa.txt';
        break;
      case 'capsicum':
        modelPath = 'assets/model/detection/capsicum.tflite';
        labelsPath = 'assets/model/detection/capsicum.txt';
        break;
      default:
        print('Vegetable type not recognized. Loading default model.');
        modelPath = 'assets/model/detection/broccoli.tflite';
        labelsPath = 'assets/model/detection/broccoli.txt';
        break;
    }

    try {
      await _vision.loadYoloModel(
        labels: labelsPath,
        modelPath: modelPath,
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false,
      );
      print('Model for $vegetableType loaded successfully.');
    } catch (e) {
      print('Failed to load model for $vegetableType: $e');
    }
  }

  Future<Recognition?> runModelOnImage(Uint8List imageBytes, int imageHeight, int imageWidth) async {
    if (_isProcessing) return null;
    _isProcessing = true;

    try {
      final result = await _vision.yoloOnImage(
        bytesList: imageBytes,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        iouThreshold: 0.8,
        confThreshold: 0.1,
        classThreshold: 0.1,
      );

      print('Model result: $result');

      if (result.isEmpty) {
        _isProcessing = false;
        return null;
      }

      // Set minimum confidence threshold
      const double minConfidence = 0.1;
      Recognition? bestRecognition;
      double highestConfidence = minConfidence;

      for (var item in result) {
        try {
          final recognition = Recognition.fromJson(item);

          // Only consider recognitions with confidence greater than minConfidence
          if (recognition.confidenceInClass >= minConfidence &&
              recognition.confidenceInClass > highestConfidence) {
            highestConfidence = recognition.confidenceInClass;
            bestRecognition = recognition;
          }
        } catch (e) {
          print('Error parsing recognition item: $e');
        }
      }

      _isProcessing = false;
      return bestRecognition;
    } catch (e) {
      print('Error running model on image: $e');
      _isProcessing = false;
      return null;
    }
  }


  Future<void> close() async {
    await _vision.closeYoloModel();
  }
}
