// Custom Widget for Storage Item Card with Enhanced Design
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StorageItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onView;
  final VoidCallback onStatus;
  final VoidCallback onDelete;

  const StorageItemCard({
    Key? key,
    required this.item,
    required this.onView,
    required this.onStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the status color and icon
    Color statusColor = item['status'] == 'Spoiled' ? Colors.red : Colors.green;
    IconData statusIcon = item['status'] == 'Spoiled' ? Icons.warning : Icons.check_circle;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Card(
        color: Colors.white, // White card to stand out against white background
        elevation: 4, // Add elevation for shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onView, // Navigate to RecordScreen on tap
          borderRadius: BorderRadius.circular(15),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white, // Ensure the card background remains white
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                // Image and Status Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the image if available
                    item['imagePath'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(item['imagePath']),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey, size: 40),
                    ), // Placeholder for missing images
                    const SizedBox(width: 12),

                    // Item details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['detectedClass'] ?? 'Unknown Vegetable',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 5),
                              Text(
                                '${item['time'] ?? 'Unknown Time'}',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.thermostat, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 5),
                              Text(
                                'Storage: ${item['temperatureCondition'] ?? 'Unknown'}',
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status and Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Indicator
                    Row(
                      children: [
                        Icon(statusIcon, color: statusColor, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          item['status'] ?? 'Unknown',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // Action Buttons with Tooltips
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                          onPressed: onView,
                          tooltip: 'View Details',
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.orange),
                          onPressed: onStatus,
                          tooltip: 'Current Status',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
