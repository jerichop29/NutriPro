import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:scanning_effect/scanning_effect.dart';
import 'package:image/image.dart' as img;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../components/image_picker.dart';
import '../components/weight_measurement/dimensions_measurement.dart';
import '../components/weight_measurement/distance_estimator.dart';
import '../components/weight_measurement/weight_estimator.dart';
import '../model/recognition.dart';
import '../model/segmentation/segmentation.dart';
import '../model/segmentation/tf_segmentation.dart';
import '../model/tf_image_service.dart';
import 'output/result.dart';
import 'package:nutripro/functionalities/output/quality_description.dart';

class AlbumScreen extends StatefulWidget {
  final File image;
  final String selectedVegetable;

  AlbumScreen({required this.image, required this.selectedVegetable});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _applyScanningEffect = false;
  bool _isLoading = false;
  late TensorFlowImageService _tensorFlowService;
  late SegmentationService _segmentationService;
  late DistanceEstimator _distanceEstimator;
  late WeightEstimator _weightEstimator;
  late Measurement _measurement;
  Recognition? _bestRecognition;
  bool _objectDetected = false;
  late File _currentImage;

  @override
  void initState() {
    super.initState();
    _initializeEstimators();
    _currentImage = widget.image;
    _startDetectionProcess();
  }

  void _initializeEstimators() {
    _tensorFlowService = TensorFlowImageService();
    _segmentationService = SegmentationService();

    final realWidths = {
      'broccoli': 0.15,
      'cabbage': 0.15,
      'cauliflower': 0.10,
      'napa cabbage': 0.22,
      'capsicum': 0.07,
    };

    final realDistances = {
      'broccoli': 0.4,
      'cabbage': 0.4,
      'cauliflower': 0.4,
      'napa cabbage': 1.0,
      'capsicum': 0.4,
    };

    // Fixed focal lengths for each vegetable type
    final focalLengths = {
      'broccoli': 500.0,
      'cabbage': 550.0,
      'cauliflower': 500.0,
      'napa cabbage': 540.0,
      'capsicum': 510.0,
    };

    // Get the correct focal length for the selected vegetable
    double selectedFocalLength = focalLengths[widget.selectedVegetable.toLowerCase()] ?? 500.0;

    // Initialize the distance estimator with the selected focal length
    _distanceEstimator = DistanceEstimator(
      realWidths: realWidths,
      realDistances: realDistances,
      fixedFocalLength: selectedFocalLength, // Use fixed focal length based on the vegetable type
    );

    _weightEstimator = WeightEstimator();
    _measurement = Measurement(distanceEstimator: _distanceEstimator);
  }


  Future<void> _startDetectionProcess() async {
    setState(() {
      _applyScanningEffect = true;
    });

    try {
      Uint8List imageBytes = await _currentImage.readAsBytes();
      img.Image decodedImage = img.decodeImage(imageBytes)!;

      await _tensorFlowService.loadModel(widget.selectedVegetable);
      var recognition = await _tensorFlowService.runModelOnImage(
        imageBytes,
        decodedImage.height,
        decodedImage.width,
      );

      await _segmentationService.loadModel(widget.selectedVegetable);
      Segmentation? segmentationResult = await _segmentationService.runModelOnImage(
          imageBytes, decodedImage.height, decodedImage.width);

      if (recognition != null) {
        _objectDetected = true;
        String detectedClass = recognition.detectedClass.toLowerCase();

        double widthInPixels = segmentationResult != null
            ? _getObjectWidthFromPolygon(segmentationResult.polygons)
            : _getObjectWidthInPixels(recognition.rect);

        double heightInPixels = segmentationResult != null
            ? _getObjectHeightFromPolygon(segmentationResult.polygons)
            : _getObjectHeightInPixels(recognition.rect);

        double estimatedDistance = await _distanceEstimator.estimateDistance(widget.selectedVegetable, widthInPixels);

        Map<String, double> dimensions = await _measurement.measureDimensions(
            widget.selectedVegetable, widthInPixels, heightInPixels, estimatedDistance);

        double volume = _weightEstimator.estimateVolume(
            getShapeType(widget.selectedVegetable), dimensions['width']!, dimensions['height']!);
        double weight = _weightEstimator.estimateWeight(widget.selectedVegetable, volume, detectedClass);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.leftToRight,
              child: ResultScreen(
                image: _currentImage,
                recognitions: [recognition],
                weight: weight,
                quality: detectedClass,
                description: QualityDescription.getDescription(detectedClass),
                freshnessRate: QualityDescription.getFreshnessRate(detectedClass),
                segmentationResults: segmentationResult,
                selectedVegetable: widget.selectedVegetable,
              ),
            ),
          );
        }

        setState(() {
          _bestRecognition = recognition;
        });
      } else {
        _objectDetected = false;
        _showErrorSnackbar('No ${widget.selectedVegetable} detected. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('An error occurred: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _applyScanningEffect = false;
        });
      }
    }
  }

  double _getObjectWidthFromPolygon(List<Map<String, double>> polygons) {
    double minX = polygons[0]['x']!;
    double maxX = polygons[0]['x']!;
    for (var point in polygons) {
      if (point['x']! < minX) minX = point['x']!;
      if (point['x']! > maxX) maxX = point['x']!;
    }
    return maxX - minX;
  }

  double _getObjectHeightFromPolygon(List<Map<String, double>> polygons) {
    double minY = polygons[0]['y']!;
    double maxY = polygons[0]['y']!;
    for (var point in polygons) {
      if (point['y']! < minY) minY = point['y']!;
      if (point['y']! > maxY) maxY = point['y']!;
    }
    return maxY - minY;
  }

  double _getObjectWidthInPixels(Rect rect) {
    return rect.right - rect.left;
  }

  double _getObjectHeightInPixels(Rect rect) {
    return rect.bottom - rect.top;
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black, // Red text color
                    fontSize: 12, // Smaller font size for a compact look
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Text(
                  'Dismiss',
                  style: TextStyle(
                    color: Colors.red, // Red text for the button as well
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white, // White background
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 6.0,
          margin: EdgeInsets.only(bottom: 50, left: 20, right: 20), // Positioned slightly above the bottom
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Reduced padding for a more compact design
          duration: Duration(seconds: 5),
        ),
      );
    }
  }


  String getShapeType(String vegetable) {
    if (['cauliflower', 'cabbage', 'capsicum'].contains(vegetable.toLowerCase())) {
      return 'circular';
    } else if (['napa cabbage'].contains(vegetable.toLowerCase())) {
      return 'oblong';
    }
    return 'irregular';
  }

  Future<void> _pickImageFromCamera() async {
    setState(() {
      _isLoading = true;
      _applyScanningEffect = true;
      _objectDetected = false;
    });

    final File? newImage = await ImagePickerHelper.pickImageCamera();

    if (newImage != null) {
      setState(() {
        _currentImage = newImage;
      });
      await _startDetectionProcess();
    } else {
      setState(() {
        _isLoading = false;
        _applyScanningEffect = false;
        _objectDetected = false;
      });
    }
  }

  @override
  void dispose() {
    _tensorFlowService.close();
    _segmentationService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '🕵️ Scan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30), // Reduced height to push content upwards
                Text(
                  _applyScanningEffect
                      ? 'Scanning Image'
                      : (_objectDetected ? 'Scan' : 'No ${widget.selectedVegetable}'),
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: _applyScanningEffect
                        ? Colors.lightGreen
                        : (_objectDetected ? Colors.lightGreen : Colors.redAccent),
                  ),
                ),
                SizedBox(height: 30), // Reduced space to push content up
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 0, bottom: 0),
                    color: Colors.transparent,
                    child: Center(
                      child: SizedBox(
                        width: 350,
                        height: 350,
                        child: _applyScanningEffect
                            ? ScanningEffect(
                          scanningColor: Colors.lightGreen,
                          borderLineColor: Colors.lightGreen,
                          delay: Duration(seconds: 0),
                          duration: Duration(seconds: 3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.file(
                              _currentImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.file(
                            _currentImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: _applyScanningEffect
                      ? LoadingAnimationWidget.dotsTriangle(
                    color: Colors.lightGreen,
                    size: 100,
                  )
                      : (_objectDetected
                      ? SizedBox.shrink()
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 0),
                      Text(
                        'No ${widget.selectedVegetable} detected.\nPlease try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromCamera,
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(
                          'Capture Image Again',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
