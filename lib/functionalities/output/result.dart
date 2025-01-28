import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../../components/image_picker.dart';
import '../../database/db_helper.dart';
import '../../model/recognition.dart';
import '../../model/segmentation/segmentation.dart';
import '../../components/nav_bar/navigation_bar.dart';
import '../album.dart';
import '../scan.dart';
import 'criteria.dart';
import 'nutritional.dart';

class ResultScreen extends StatefulWidget {
  final File image;
  final List<Recognition> recognitions;
  final double weight;
  final String quality;
  final String description;
  final double freshnessRate;
  final Segmentation? segmentationResults;
  final String selectedVegetable;

  ResultScreen({
    required this.image,
    required this.recognitions,
    required this.weight,
    required this.quality,
    required this.description,
    required this.freshnessRate,
    required this.segmentationResults,
    required this.selectedVegetable,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  File? selectedImage;

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
          child: AlbumScreen(image: selectedImage!, selectedVegetable: widget.selectedVegetable),
        ),
      );
    }
  }

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
          child: ScanScreen(image: selectedImage!, selectedVegetable: widget.selectedVegetable),
        ),
      );
    }
  }

  void _showIdentifyOptions(BuildContext context) {
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
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload the Image'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTemperatureOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.ac_unit), // Icon for Refrigerated
              title: const Text('Refrigerated 10-15°C'),
              onTap: () {
                Navigator.pop(context);
                _addToCollection('Refrigerated');
              },
            ),
            ListTile(
              leading: const Icon(Icons.stop_rounded), // Icon for Non-Refrigerated
              title: const Text('Non-Refrigerated 27-34°C'),
              onTap: () {
                Navigator.pop(context);
                _addToCollection('Non-Refrigerated');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _insertResult(); // Call the method to insert result into record
  }

  void _insertResult() {
    DBHelper().insertResult(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: DateFormat('HH:mm:ss').format(DateTime.now()),
      detectedClass: widget.selectedVegetable, // Use selectedVegetable directly
      quality: widget.quality,
      freshnessRate: getFreshnessRate(widget.quality),
      weight: widget.weight, // Convert to grams
      imagePath: widget.image.path, // Include the image path
    );
  }

  double getFreshnessRate(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return 9.0;
      case 'good':
        return 7.0;
      case 'fair':
        return 5.0;
      case 'poor':
        return 3.0;
      case 'non-edible':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String getGrade(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return 'A';
      case 'good':
        return 'B';
      case 'fair':
        return 'C';
      case 'poor':
      case 'non-edible':
        return 'F';
      default:
        return 'N/A';
    }
  }

  Map<String, double> getNutritionalFacts(String vegetable, double weight) {
    final nutritionInfo = nutritionFacts.firstWhere(
          (nutrient) => nutrient.vegetable.toLowerCase().trim() == vegetable.toLowerCase().trim(),
      orElse: () => Nutrition(vegetable: 'unknown', calories: 0, protein: 0, carbs: 0, fat: 0),
    );
    return nutritionInfo.calculateNutrition(weight);
  }

  void _addToCollection(String temperatureCondition) {
    final vegetableName = widget.selectedVegetable.toLowerCase(); // Use selectedVegetable directly

    // Determine the status based on the quality
    String status = _getStatus(widget.quality);

    DBHelper().insertCollection(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: DateFormat('HH:mm:ss').format(DateTime.now()),
      detectedClass: vegetableName,
      quality: widget.quality,
      freshnessRate: getFreshnessRate(widget.quality),
      weight: widget.weight, // Convert to grams
      imagePath: widget.image.path, // Include the image path
      temperatureCondition: temperatureCondition, // Add the selected temperature condition
      status: status, // Add the calculated status (Spoiled/Non-spoiled)
    );

    // Show the custom modal dialog
    _showAddedToStorageDialog();
  }

// Helper method to determine the status
  String _getStatus(String quality) {
    // If quality is 'poor' or 'non-edible', set status to 'Spoiled'
    if (quality.toLowerCase() == 'poor' || quality.toLowerCase() == 'non-edible') {
      return 'Spoiled';
    } else {
      // For other qualities, set status to 'Non-spoiled'
      return 'Unspoiled';
    }
  }


  // Custom method to show the "Added to Storage" dialog
  void _showAddedToStorageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
                SizedBox(height: 10),
                // Title
                Text(
                  'Added to Storage',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Content
                Text(
                  'Your item has been successfully added to storage!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // OK Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutritionalFacts = getNutritionalFacts(widget.selectedVegetable, widget.weight);
    var _currentIndex = 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'NutriPro',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Expanded(
            child: Stack(
              children: [
                InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Image.file(
                    widget.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
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
                DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.5,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 0.0),
                            Text(
                              widget.selectedVegetable.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5.0),
                            const Text(
                              'NutriPro provides estimation of quality and weight measurement of vegetables through computer vision. They should not be taken as completely precise figures and should not replace professional advice.',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10.0),
                            Table(
                              border: TableBorder.all(color: Colors.grey),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(color: Colors.green),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Attribute',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Value',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Quality:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text(widget.quality)), // Directly use widget.quality
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Freshness Rate:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${getFreshnessRate(widget.quality).toStringAsFixed(1)}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Class:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          getGrade(widget.quality),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Weight (g):')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${(widget.weight).toStringAsFixed(0)} g',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: const Color(0xFFdac22d)),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Nutritional Facts',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          'Value',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Calories:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${nutritionalFacts['calories']?.toStringAsFixed(1) ?? 'N/A'} kcal',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Protein:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${nutritionalFacts['protein']?.toStringAsFixed(2) ?? 'N/A'} g',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Carbohydrates:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${nutritionalFacts['carbs']?.toStringAsFixed(2) ?? 'N/A'} g',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Fat:')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '${nutritionalFacts['fat']?.toStringAsFixed(2) ?? 'N/A'} g',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.description,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 0.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: _showTemperatureOptions, // Show temperature options when clicked
                                  icon: const Icon(
                                    Icons.storage,
                                    color: Colors.white, // Change icon color
                                  ),
                                  label: const Text(
                                    'Add to Storage',
                                    style: TextStyle(color: Colors.white), // Change text color
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Background color
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    elevation: 5, // Shadow elevation
                                    shadowColor: Colors.black.withOpacity(0.5), // Shadow color
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _showIdentifyOptions(context),
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.white, // Change icon color
                                  ),
                                  label: const Text(
                                    'Try Again',
                                    style: TextStyle(color: Colors.white), // Change text color
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red, // Background color
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    elevation: 5, // Shadow elevation
                                    shadowColor: Colors.black.withOpacity(0.5), // Shadow color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
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
}
