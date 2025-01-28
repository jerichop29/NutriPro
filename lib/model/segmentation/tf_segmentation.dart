import 'package:flutter_vision/flutter_vision.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:nutripro/model/segmentation/segmentation.dart';

class SegmentationService {
  late FlutterVision _vision;
  bool _isProcessing = false;

  SegmentationService() {
    _vision = FlutterVision();
  }

  // Load the appropriate model based on the selected vegetable
  Future<void> loadModel(String vegetableType) async {
    String modelPath = '';
    String labelsPath = '';

    // Assign model and labels path based on the selected vegetable
    switch (vegetableType.toLowerCase()) {
      case 'broccoli':
        modelPath = 'assets/model/segmentation/broccoli.tflite';
        labelsPath = 'assets/model/segmentation/broccoli.txt';
        break;
      case 'cauliflower':
        modelPath = 'assets/model/segmentation/cauliflower.tflite';
        labelsPath = 'assets/model/segmentation/cauliflower.txt';
        break;
      case 'cabbage':
        modelPath = 'assets/model/segmentation/cabbage.tflite';
        labelsPath = 'assets/model/segmentation/cabbage.txt';
        break;
      case 'napa cabbage':
        modelPath = 'assets/model/segmentation/napa.tflite';
        labelsPath = 'assets/model/segmentation/napa.txt';
        break;
      case 'capsicum':
        modelPath = 'assets/model/segmentation/capsicum.tflite';
        labelsPath = 'assets/model/segmentation/capsicum.txt';
        break;
      default:
        print('Vegetable type not recognized. Loading default model.');
        modelPath = 'assets/model/segmentation/broccoli.tflite';
        labelsPath = 'assets/model/segmentation/broccoli.txt';
        break;
    }

    try {
      await _vision.loadYoloModel(
        labels: labelsPath,
        modelPath: modelPath,
        modelVersion: "yolov8seg", // Specify segmentation model version
        quantization: false,
        numThreads: 1,
        useGpu: false,
      );
      print('Segmentation model for $vegetableType loaded successfully.');
    } catch (e) {
      print('Failed to load segmentation model for $vegetableType: $e');
    }
  }

  Future<Segmentation?> runModelOnImage(Uint8List imageBytes, int imageHeight, int imageWidth) async {
    if (_isProcessing) return null;
    _isProcessing = true;

    try {
      final result = await _vision.yoloOnImage(
        bytesList: imageBytes,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        iouThreshold: 0.8,
        confThreshold: 0.3,
        classThreshold: 0.7,
      );

      print('Raw segmentation result: $result');  // Print the raw result

      if (result.isEmpty) {
        _isProcessing = false;
        return null;
      }

      // Assuming you want the highest confidence segmentation result
      Segmentation? bestSegmentation;
      double highestConfidence = 0;

      for (var item in result) {
        try {
          final segmentation = Segmentation.fromJson(item); // Parse the item into Segmentation
          if (segmentation.confidenceInClass > highestConfidence) {
            highestConfidence = segmentation.confidenceInClass;
            bestSegmentation = segmentation; // Update the best segmentation result
          }
        } catch (e) {
          print('Error parsing segmentation item: $e');
        }
      }

      _isProcessing = false;
      return bestSegmentation;
    } catch (e) {
      print('Error running segmentation model on image: $e');
      _isProcessing = false;
      return null;
    }
  }

  Future<void> close() async {
    await _vision.closeYoloModel();
  }
}
