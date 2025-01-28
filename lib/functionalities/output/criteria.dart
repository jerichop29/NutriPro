import 'package:flutter/material.dart';

class Criteria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width of the screen
      height: 500, // Adjusted height of the container
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 30), // Add margin to the top
      decoration: BoxDecoration(
        color: Color(0xFFF8FFFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(50), bottom: Radius.circular(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the left
        children: [
          Center(
            child: Text(
              'Freshness Rates',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16, // Reduced font size for the title
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 150, // Width of the image container
              height: 150,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(0xFFE9FFF6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "assets/images/grade_icon.png", // Using local asset image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Scrollable Table for ratings
          Expanded(
            child: SingleChildScrollView(
              child: Table(
                columnWidths: {
                  0: FixedColumnWidth(50), // Width for Color column
                  1: FixedColumnWidth(50), // Width for Rate column
                  2: FixedColumnWidth(80), // Width for Quality column
                  3: FixedColumnWidth(50), // Width for Grade column
                },
                children: [
                  // Column titles
                  TableRow(
                    children: [
                      Center(child: Text('Color', style: TextStyle(fontWeight: FontWeight.bold))),
                      Center(child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold))),
                      Center(child: Text('Quality', style: TextStyle(fontWeight: FontWeight.bold))),
                      Center(child: Text('Class', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                  ..._buildRatingRows(), // Add rating rows
                ],
              ),
            ),
          ),
          SizedBox(height: 10), // Spacing before buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.40,
                child: TextButton(
                  onPressed: () {
                    // Action for 'See more'
                  },
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12, // Reduced font size for the button text
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the modal
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12, // Reduced font size for the button text
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<TableRow> _buildRatingRows() {
    final ratings = [
      {'score': '9', 'quality': 'Excellent', 'grade': 'A', 'color': Colors.green},
      {'score': '8', 'quality': 'Excellent', 'grade': 'A', 'color': Colors.green},
      {'score': '7', 'quality': 'Good', 'grade': 'B', 'color': Colors.lightGreen},
      {'score': '6', 'quality': 'Good', 'grade': 'B', 'color': Colors.lightGreen},
      {'score': '5', 'quality': 'Fair', 'grade': 'C', 'color': Colors.yellow},
      {'score': '4', 'quality': 'Fair', 'grade': 'C', 'color': Colors.yellow},
      {'score': '3', 'quality': 'Poor', 'grade': 'F', 'color': Colors.orange},
      {'score': '2', 'quality': 'Poor', 'grade': 'F', 'color': Colors.orange},
      {'score': '1', 'quality': 'Non-edible', 'grade': 'F', 'color': Colors.red},
    ];

    return ratings.map((rating) {
      return TableRow(
        children: [
          Container(
            width: 30,
            height: 30,
            color: rating['color'] as Color, // Colored box for rating
          ),
          Center(
            child: Text(
              rating['score'] as String, // Explicitly casting to String
              style: TextStyle(
                color: Colors.black,
                fontSize: 14, // Reduced font size for score
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: Text(
              rating['quality'] as String, // Explicitly casting to String
              style: TextStyle(
                color: Colors.black,
                fontSize: 14, // Reduced font size for quality
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Center(
            child: Text(
              rating['grade'] as String, // Explicitly casting to String
              style: TextStyle(
                color: Colors.black,
                fontSize: 14, // Reduced font size for grade
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}

// Usage example
void showCriteriaModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Criteria();
    },
  );
}
