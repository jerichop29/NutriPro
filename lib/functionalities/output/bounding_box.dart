import 'package:flutter/material.dart';
import '../../model/recognition.dart';

class BoundingBox {
  // Threshold values for the minimum size of the bounding box
  static const double minBoxWidth = 80.0;
  static const double minBoxHeight = 80.0;

  static Widget drawBoundingBox(Recognition recognition, double scaleX, double scaleY, String selectedVegetable) {
    double left = recognition.rect.left * scaleX;
    double top = recognition.rect.top * scaleY;
    double width = recognition.rect.width * scaleX;
    double height = recognition.rect.height * scaleY;

    Color boxColor = Colors.black; // Default color
    String freshnessRate = 'Unknown'; // Default freshness rate
    String quality = 'Unknown'; // Default quality
    String grade = 'N/A'; // Default grade
    double confidence = recognition.confidenceInClass;

    // The detected class is now the quality (e.g., excellent, good, fair, poor, non-edible)
    String qualityClass = recognition.detectedClass.trim();

    // Determine freshness rate, box color, quality, and grade based on the detected class
    if (qualityClass == 'excellent') {
      freshnessRate = '9';
      quality = 'Excellent';
      grade = 'A';
      boxColor = Colors.green;
    } else if (qualityClass == 'good') {
      freshnessRate = '7';
      quality = 'Good';
      grade = 'B';
      boxColor = Colors.lightGreen;
    } else if (qualityClass == 'fair') {
      freshnessRate = '5';
      quality = 'Fair';
      grade = 'C';
      boxColor = Colors.yellow;
    } else if (qualityClass == 'poor') {
      freshnessRate = '3';
      quality = 'Poor';
      grade = 'F';
      boxColor = Colors.orange;
    } else if (qualityClass == 'non-edible') {
      freshnessRate = '1';
      quality = 'Non-edible';
      grade = 'F';
      boxColor = Colors.red;
    }

    // If the box is too small, dynamically adjust the font size based on the bounding box size
    double fontSize = _calculateFontSize(width, height);

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.transparent, // Interior is transparent
          border: Border.all(color: boxColor, width: 3),
          borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
          boxShadow: [
            BoxShadow(
              color: boxColor.withOpacity(0.4), // Slightly reduced opacity for the shadow
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedVegetable,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize, // Dynamically adjusted font size
                        shadows: [
                          Shadow(
                            blurRadius: 3.0,
                            color: Colors.black45,
                            offset: Offset(1.5, 1.5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    _buildInfoLabel('Freshness Rate', freshnessRate, boxColor, fontSize),
                    _buildInfoLabel('Quality', quality, boxColor, fontSize),
                    _buildInfoLabel('Class Grade', grade, boxColor, fontSize), // Display the grade
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to calculate font size based on bounding box size
  static double _calculateFontSize(double width, double height) {
    // Determine the font size based on the smaller dimension of the bounding box
    double minSize = width < height ? width : height;
    // Set font size proportional to the bounding box size, with a minimum size of 8 and maximum of 14
    return (minSize / 10).clamp(8.0, 14.0);
  }

  // Regular info label with dynamic font size for larger bounding boxes
  static Widget _buildInfoLabel(String title, String value, Color boxColor, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$title: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: fontSize, // Dynamic font size for the title
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: boxColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize, // Dynamic font size for the value
              ),
            ),
          ],
        ),
      ),
    );
  }
}
