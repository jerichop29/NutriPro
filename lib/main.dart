import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:nutripro/screen/splash.dart';
import 'components/notification/updater.dart'; // Adjust the import path as necessary

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the SpoilageUpdater service
  final spoilageUpdater = SpoilageUpdater();
  await spoilageUpdater.initializeService();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    null, // Ensure this matches the actual file path and name
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        icon: 'resource://drawable/ic_notification',
      ),
      NotificationChannel(
        channelKey: 'spoilage_channel',
        channelName: 'Spoilage Notifications',
        channelDescription: 'Notifications for vegetable spoilage alerts',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        icon: 'resource://drawable/ic_notification',
      ),
    ],
  );


  // Request notification permissions if not already allowed
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashscreenWidget(), // Reference to your splash screen
    );
  }
}
