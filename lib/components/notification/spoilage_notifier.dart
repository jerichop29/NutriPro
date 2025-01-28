// spoilage_notifier.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'spoilage_criteria.dart';

class SpoilageNotifier {
  final SpoilageCriteria spoilageCriteria = SpoilageCriteria();

  SpoilageNotifier() {
    _initializeAwesomeNotifications();
  }

  /// Initializes Awesome Notifications and sets up the notification channel
  void _initializeAwesomeNotifications() {
    AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelKey: 'spoilage_channel',
          channelName: 'Spoilage Notifications',
          channelDescription: 'Notifications for vegetable spoilage',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  /// Schedules notifications for upcoming spoilage and actual spoilage
  Future<void> scheduleSpoilageNotifications({
    required int collectionId,
    required String date,
    required String time,
    required String detectedClass,
    required String quality,
    required String storage,
  }) async {
    DateTime spoilageDate = spoilageCriteria.calculateSpoilageDate(
      date,
      time,
      quality,
      storage,
      detectedClass.toLowerCase(), // Ensure consistency
    );

    // Schedule notification one day before spoilage
    DateTime oneDayBeforeSpoilage = spoilageDate.subtract(Duration(days: 1));
    if (oneDayBeforeSpoilage.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: collectionId, // Use collectionId as notification ID
          channelKey: 'spoilage_channel',
          title: 'Upcoming Spoilage Alert',
          body: '$detectedClass will spoil soon!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: oneDayBeforeSpoilage,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    }

    // Schedule notification at spoilage date
    if (spoilageDate.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: collectionId + 100000, // Ensure unique ID
          channelKey: 'spoilage_channel',
          title: 'Spoilage Alert',
          body: '$detectedClass has just spoiled!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: spoilageDate,
          preciseAlarm: true,
          allowWhileIdle: true,
        ),
      );
    }
  }

  /// Cancels scheduled notifications when an item is deleted
  Future<void> cancelSpoilageNotifications(int collectionId) async {
    await AwesomeNotifications().cancel(collectionId);
    await AwesomeNotifications().cancel(collectionId + 100000);
  }
}
