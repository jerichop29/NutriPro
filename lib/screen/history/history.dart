// history.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'dart:io'; // For handling local file paths
import '../../database/db_helper.dart';
import '../../components/nav_bar/navigation_bar.dart';
import 'record.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // Import for animations

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Map<String, dynamic>>> _historyFuture;
  int _currentIndex = 2; // Initialize current index for the navigation bar

  @override
  void initState() {
    super.initState();
    _historyFuture = DBHelper().fetchAllRecords(); // Fetch all records, not just weekly
  }

  // Function to delete a record
  Future<void> _deleteRecord(int recordId) async {
    await DBHelper().deleteRecord(recordId);
    // Refresh the records after deletion
    setState(() {
      _historyFuture = DBHelper().fetchAllRecords();
    });
    // Show a SnackBar after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item deleted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a record
  Future<void> _showDeleteConfirmationDialog(BuildContext context, int recordId) async {
    return showDialog<void>(
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
                // Icon at the top
                Icon(
                  Icons.delete_forever,
                  color: Colors.redAccent,
                  size: 60,
                ),
                SizedBox(height: 10),
                // Title
                Text(
                  'Delete Item',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Content
                Text(
                  'Are you sure you want to delete this item?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // Delete Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
                        _deleteRecord(recordId); // Proceed with deletion
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Check if the imagePath is a network URL or local file
  Widget _buildImage(String imagePath, int recordId) {
    return Stack(
      children: [
        // Display the image
        if (Uri.tryParse(imagePath)?.isAbsolute ?? false)
          Image.network(
            imagePath,
            width: double.infinity,
            height: 120, // Increased image height for better visibility
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, size: 50); // Fallback if the image fails to load
            },
          )
        else
          Image.file(
            File(imagePath),
            width: double.infinity,
            height: 120, // Increased image height for better visibility
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.image, size: 50); // Fallback if the image fails to load
            },
          ),

        // Add the "X" delete icon in the upper right corner
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              _showDeleteConfirmationDialog(context, recordId); // Show confirmation dialog
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.5), // Background for the "X" button
              ),
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // A fresh green for the AppBar
        elevation: 0, // Remove shadow
        title: const Text(
          '⏳ History',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.green.shade50, // Subtle color to differentiate from white
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, color: Colors.green.shade800, size: 24),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Explore your past vegetable grading results',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // FutureBuilder for the history grid
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No records found.'));
                  }

                  final records = snapshot.data!;
                  final groupedRecords = _groupRecordsByDate(records); // Group records by date

                  return AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: groupedRecords.length,
                      itemBuilder: (context, index) {
                        final date = groupedRecords.keys.elementAt(index);
                        final recordsForDate = groupedRecords[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date Header
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                              child: Text(
                                DateFormat('MMMM dd, yyyy').format(date), // Format the date
                                style: TextStyle(
                                  fontSize: 20, // Increased font size for the date header
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            // Grid for records on this date with animations
                            AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 200),
                              columnCount: 2, // Number of columns in the grid
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(), // Disable scrolling inside the grid
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing: 10, // Spacing between columns
                                      mainAxisSpacing: 10, // Spacing between rows
                                      childAspectRatio: 0.75, // Aspect ratio for the grid items
                                    ),
                                    itemCount: recordsForDate.length,
                                    itemBuilder: (context, gridIndex) {
                                      final record = recordsForDate[gridIndex];

                                      return AnimationConfiguration.staggeredGrid(
                                        position: gridIndex,
                                        duration: const Duration(milliseconds: 500),
                                        columnCount: 2,
                                        child: ScaleAnimation(
                                          child: FadeInAnimation(
                                            child: InkWell(
                                              onTap: () {
                                                // Navigate to RecordScreen when tapped
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => RecordScreen(recordId: record['id']), // Pass the record ID
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(10), // Smaller border radius
                                                  border: Border.all(color: Color(0x99E0E8F1)),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center, // Center the content
                                                  children: [
                                                    _buildImage(record['imagePath'], record['id']), // Image with "X" button
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        record['detectedClass'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18, // Increased font size for detectedClass
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                        textAlign: TextAlign.center, // Center the text
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text(
                                                        'Quality: ${record['quality']}',
                                                        style: TextStyle(
                                                          fontSize: 12, // Increased font size for the subtitle
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: Text(
                                                        'Weight: ${double.parse(record['weight'].toString()).toStringAsFixed(0)} g',
                                                        style: TextStyle(
                                                          fontSize: 12, // Increased font size for the subtitle
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  // Helper function to group records by date
  Map<DateTime, List<Map<String, dynamic>>> _groupRecordsByDate(List<Map<String, dynamic>> records) {
    Map<DateTime, List<Map<String, dynamic>>> groupedRecords = {};

    for (var record in records) {
      DateTime date = DateTime.parse(record['date']); // Assuming 'date' is in ISO format
      DateTime formattedDate = DateTime(date.year, date.month, date.day); // Strip time part

      if (groupedRecords.containsKey(formattedDate)) {
        groupedRecords[formattedDate]!.add(record);
      } else {
        groupedRecords[formattedDate] = [record];
      }
    }

    return groupedRecords;
  }
}
