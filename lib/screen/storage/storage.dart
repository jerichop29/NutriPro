import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nutripro/screen/storage/condition/status.dart';
import 'package:nutripro/screen/storage/condition/storage_item.dart';
import 'package:nutripro/screen/storage/view.dart';
import '../../database/db_helper.dart';
import '../../components/nav_bar/navigation_bar.dart';

class StorageScreen extends StatefulWidget {
  @override
  _StorageScreenState createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<Map<String, dynamic>> _collectionItems = [];
  String _selectedFilter = 'All'; // Track the selected filter

  @override
  void initState() {
    super.initState();
    _fetchCollection();
  }

  Future<void> _fetchCollection() async {
    final data = await DBHelper().fetchCollection();
    setState(() {
      _collectionItems = data;
    });
  }

  // Function to delete a record
  Future<void> _deleteItem(int id) async {
    await DBHelper().deleteCollectionItem(id);
    _fetchCollection(); // Refresh the collection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item deleted successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to show the confirmation dialog before deleting a record
  Future<void> _showDeleteConfirmationDialog(BuildContext context, int itemId) async {
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
                        _deleteItem(itemId); // Proceed with deletion
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

  List<Map<String, dynamic>> _filterItems() {
    if (_selectedFilter == 'Spoiled') {
      return _collectionItems.where((item) => item['status'] == 'Spoiled').toList();
    } else if (_selectedFilter == 'Unspoiled') {
      return _collectionItems.where((item) => item['status'] == 'Unspoiled').toList();
    }
    return _collectionItems; // 'All' or default
  }

  @override
  Widget build(BuildContext context) {
    var _currentIndex = 3; // Adjust based on your bottom navigation setup

    // Group items by date
    Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (var item in _filterItems()) {
      String date = item['date'] ?? 'Unknown Date';
      if (!groupedItems.containsKey(date)) {
        groupedItems[date] = [];
      }
      groupedItems[date]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600, // Retain the AppBar color
        elevation: 0, // Remove shadow
        title: const Text(
          '🗄 Storage',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true, // Center the title
      ),
      // Set the Scaffold background to white
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Enhanced Introduction Banner with Icon
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
                      'Track your vegetables and get notified before they spoil.',
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

            // Stylized Dropdown Filter within the body
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Filter:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 130, // Reduced width from 120 to 80
                    height: 28, // Fixed height
                    child: DropdownButtonFormField<String>(
                      value: _selectedFilter,
                      isExpanded: true, // Allows the DropdownButton to fill the width
                      decoration: InputDecoration(
                        isDense: true, // Reduces the height of the dropdown
                        filled: true,
                        fillColor: Colors.grey.shade100, // Light background for the dropdown
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2), // Reduced vertical padding
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: Colors.white, // Set the background color of the dropdown menu
                      style: const TextStyle(
                        color: Colors.black, // Text color of the selected item
                        fontSize: 14, // Reduced font size for smaller container
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'All',
                          child: Row(
                            children: [
                              Icon(Icons.all_inclusive, color: Colors.black54, size: 16), // Reduced icon size
                              SizedBox(width: 5), // Reduced spacing
                              Text(
                                'All',
                                style: TextStyle(color: Colors.black, fontSize: 14), // Consistent font size
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Spoiled',
                          child: Row(
                            children: [
                              Icon(Icons.warning, color: Colors.red, size: 16), // Reduced icon size
                              SizedBox(width: 5), // Reduced spacing
                              Text(
                                'Spoiled',
                                style: TextStyle(color: Colors.black, fontSize: 14), // Consistent font size
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Unspoiled',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 16), // Reduced icon size
                              SizedBox(width: 5), // Reduced spacing
                              Text(
                                'Unspoiled',
                                style: TextStyle(color: Colors.black, fontSize: 14), // Consistent font size
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _selectedFilter = value ?? 'All';
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Expanded Animated List View
            Expanded(
              child: _filterItems().isEmpty
                  ? const Center(
                child: Text(
                  'No records found.',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              )
                  : AnimationLimiter(
                child: ListView.builder(
                  itemCount: groupedItems.keys.length,
                  itemBuilder: (context, index) {
                    String date = groupedItems.keys.elementAt(index);
                    List<Map<String, dynamic>> items = groupedItems[date] ?? [];

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date Header with Icon
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, color: Colors.green.shade700, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      date,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // List of items under this date
                              ...items.map((item) => StorageItemCard(
                                item: item,
                                onView: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewScreen(collectionId: item['id']),
                                    ),
                                  );
                                },
                                onStatus: () {
                                  if (item['detectedClass'] == null ||
                                      item['quality'] == null ||
                                      item['temperatureCondition'] == null ||
                                      item['date'] == null ||
                                      item['time'] == null) {
                                    print('Error: One of the values is null.');
                                    return;
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatusScreen(
                                        vegetable: item['detectedClass'] ?? 'Unknown Vegetable',
                                        quality: item['quality'] ?? 'Unknown Quality',
                                        storage: item['temperatureCondition'] ?? 'Unknown Storage',
                                        date: item['date'] ?? 'Unknown Date',
                                        time: item['time'] ?? 'Unknown Time',
                                        imagePath: item['imagePath'],
                                        status: item['status'],
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () => _showDeleteConfirmationDialog(context, item['id']), // Show delete confirmation dialog
                              )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
}
