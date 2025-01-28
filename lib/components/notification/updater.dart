import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart'; // Import the notifications package
import '../../database/db_helper.dart';
import '../../components/notification/spoilage_criteria.dart';

class SpoilageUpdater {
  final DBHelper dbHelper = DBHelper();
  final SpoilageCriteria spoilageCriteria = SpoilageCriteria();

  Future<void> initializeService() async {
    // Check if the service is already running
    bool isRunning = await FlutterBackgroundService().isRunning();

    if (!isRunning) {
      await FlutterBackgroundService().configure(
        iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart, // This is now a top-level function
          onBackground: onIosBackground,
        ),
        androidConfiguration: AndroidConfiguration(
          autoStart: true,
          onStart: onStart, // This is now a top-level function
          isForegroundMode: true,
        ),
      );

      // Start the service
      FlutterBackgroundService().startService();
    }
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }
}

// Top-level function for the background service
@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  final dbHelper = DBHelper(); // Create instance of DBHelper
  final spoilageCriteria = SpoilageCriteria(); // Create instance of SpoilageCriteria

  Timer.periodic(Duration(minutes: 10), (timer) async {
    await checkAndUpdateSpoilageStatus(dbHelper, spoilageCriteria);
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process stopped");
  });
}

// Function to check and update spoilage status, and trigger notifications
Future<void> checkAndUpdateSpoilageStatus(
    DBHelper dbHelper, SpoilageCriteria spoilageCriteria) async {
  List<Map<String, dynamic>> collection = await dbHelper.fetchCollection();
  DateTime now = DateTime.now();

  if (collection.isEmpty) {
    print("No records found in the collection.");
    return; // Exit if no records
  }

  print("Found ${collection.length} records in the collection.");

  for (var record in collection) {
    String date = record['date'];
    String time = record['time'];
    String quality = record['quality'];
    String storage = record['temperatureCondition'] ?? 'refrigerated';
    String vegetableType = record['detectedClass'];

    DateTime spoilageDate = spoilageCriteria.calculateSpoilageDate(
      date,
      time,
      quality,
      storage,
      vegetableType,
    );

    print("Spoilage date for $vegetableType: $spoilageDate");

    // Define the time window of 1 minute after spoilage
    DateTime spoilageEndTime = spoilageDate.add(Duration(minutes: 1));

    // Notify only if the current time is within the 1-minute window after spoilage
    if (now.isAfter(spoilageDate) && now.isBefore(spoilageEndTime)) {
      await dbHelper.updateStatus(record['id'], 'Spoiled');
      print("Record ${record['id']} marked as Spoiled.");

      // Notify if the vegetable has spoiled within the 1-minute window
      await showNotification(
          "Vegetable Spoiled", "$vegetableType has spoiled.", record['id']);
    }
    // Check for 1 day before spoilage, but don't notify if already spoiled
    else if (spoilageDate.subtract(Duration(days: 1)).isBefore(now) && spoilageDate.isAfter(now)) {
      // Notify 1 day before spoilage
      await showNotification(
          "Vegetable Near Spoilage", "$vegetableType will spoil soon.", record['id']);
      await dbHelper.updateStatus(record['id'], 'Unspoiled');
      print("Record ${record['id']} marked as Unspoiled.");
    }
  }
}

// Function to show notifications
Future<void> showNotification(String title, String body, int id) async {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'basic_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
    ),
  );
}
