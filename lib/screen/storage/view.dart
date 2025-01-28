import 'dart:io';
import 'package:flutter/material.dart';
import '../../database/db_helper.dart';
import '../../functionalities/output/nutritional.dart';
import '../../functionalities/output/quality_description.dart'; // Import the quality description
import '../../components/nav_bar/navigation_bar.dart';

class ViewScreen extends StatefulWidget {
  final int collectionId;

  const ViewScreen({Key? key, required this.collectionId}) : super(key: key);

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  Map<String, dynamic>? _record;

  @override
  void initState() {
    super.initState();
    _fetchCollectionRecord();
  }

  Future<void> _fetchCollectionRecord() async {
    final record = await DBHelper().fetchCollectionRecord(widget.collectionId);
    setState(() {
      _record = record;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Record Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final vegetableName = _record!['detectedClass'];
    final weight = _record!['weight'];
    final freshnessRate = _record!['freshnessRate'];
    final imagePath = _record!['imagePath'];
    final quality = _record!['quality'];

    final nutritionalFacts = getNutritionalFacts(vegetableName, weight);
    final qualityDescription = QualityDescription.getDescription(quality); // Get quality description

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
          InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 5.0,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
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
                child: Column(
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0),
                            Text(
                              vegetableName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              qualityDescription, // Display quality description
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16.0),
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
                                      child: Center(child: Text(quality)),
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
                                          '${freshnessRate.toStringAsFixed(1)}',
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
                                          '${weight.toStringAsFixed(2)} g',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: BoxDecoration(color: Color(0xFFdac22d)),
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
                                      child: Center(child: Text('Calories (kcal):')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('${nutritionalFacts['calories']?.toStringAsFixed(2)} kcal'),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Protein (g):')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('${nutritionalFacts['protein']?.toStringAsFixed(2)} g'),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Carbohydrates (g):')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('${nutritionalFacts['carbs']?.toStringAsFixed(2)} g'),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  decoration: const BoxDecoration(color: Colors.white),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(child: Text('Fat (g):')),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text('${nutritionalFacts['fat']?.toStringAsFixed(2)} g'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3,
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Map<String, double> getNutritionalFacts(String vegetable, double weight) {
    final nutritionInfo = nutritionFacts.firstWhere(
          (nutrient) => nutrient.vegetable.toLowerCase() == vegetable.toLowerCase(),
      orElse: () => Nutrition(vegetable: 'unknown', calories: 0, protein: 0, carbs: 0, fat: 0),
    );
    return nutritionInfo.calculateNutrition(weight);
  }
}
