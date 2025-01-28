// condition_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:intl/intl.dart';
import 'package:nutripro/components/nav_bar/navigation_bar.dart';
import 'package:nutripro/components/notification/spoilage_criteria.dart';

class StatusScreen extends StatefulWidget {
  final String vegetable;
  final String quality;
  final String storage;
  final String date;
  final String time;
  final String? imagePath;
  final String status;

  StatusScreen({
    required this.vegetable,
    required this.quality,
    required this.storage,
    required this.date,
    required this.time,
    this.imagePath,
    required this.status,
  });

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  int _currentIndex = 3; // Initial index for the bottom nav bar

  @override
  Widget build(BuildContext context) {
    SpoilageCriteria criteria = SpoilageCriteria();

    // Calculate spoilage date and time based on provided criteria
    DateTime spoilageDateTime = criteria.calculateSpoilageDate(
      widget.date,
      widget.time,
      widget.quality,
      widget.storage,
      widget.vegetable,
    );

    // Calculate remaining days until spoilage and set to 0 if less than 0
    int remainingDays = criteria.getRemainingDaysUntilSpoilage(spoilageDateTime);
    remainingDays = remainingDays > 0 ? remainingDays : 0;


    // Set the system overlay style to have a light status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));

    // Format spoilageDateTime to a readable string with month names and time
    String spoilageDateString = DateFormat('MMMM dd, yyyy').format(spoilageDateTime);
    String spoilageTimeString = DateFormat('hh:mm a').format(spoilageDateTime); // Added time formatting

    // Combine stored date and time into a single DateTime object
    DateTime storedDateTimeObj = DateFormat('yyyy-MM-dd HH:mm').parse('${widget.date} ${widget.time}');
    String storedDateTime = DateFormat('MMMM dd, yyyy HH:mm').format(storedDateTimeObj);

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
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Image with Interactive Viewer
          widget.imagePath != null
              ? InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 5.0,
            child: Image.file(
              File(widget.imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
              : Container(
            color: Colors.grey[300],
            child: Center(
              child: Icon(Icons.image, color: Colors.grey[700], size: 100),
            ),
          ),

          // Draggable Scrollable Sheet for Details
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.8,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Handle Indicator
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Vegetable Name
                    Text(
                      widget.vegetable.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12.0),

                    // Note
                    Text(
                      'Note: NutriPro condition tracking can sometimes make mistakes. Always verify the condition before use.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),

                    // Attributes Section using Cards and ListTiles
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Current Status
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(
                                  widget.status == 'Spoiled' ? Icons.warning : Icons.check_circle,
                                  color: widget.status == 'Spoiled' ? Colors.red : Colors.green,
                                ),
                                title: Text('Current Status'),
                                subtitle: Text(widget.status),
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Remaining Days
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.timer, color: Colors.red),
                                title: Text('Remaining Days'),
                                subtitle: Text(remainingDays.toString()),
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Stored Date and Time
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.calendar_today, color: Colors.orange),
                                title: Text('Stored Date & Time'),
                                subtitle: Text(storedDateTime),
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Spoilage Date and Time
                            Card(
                              color: Color(0xFFdac22d),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.warning, color: Colors.white),
                                title: Text(
                                  'Spoilage Date & Time',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '$spoilageDateString at $spoilageTimeString',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12.0),

                            // Storage
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                leading: Icon(Icons.thermostat, color: Colors.blue),
                                title: Text('Storage'),
                                subtitle: Text(widget.storage),
                              ),
                            ),
                            const SizedBox(height: 24.0),
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
