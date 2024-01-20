import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:motivate_me/Screens/main_screen.dart';
import 'package:motivate_me/Screens/quote_screen.dart';
import 'package:motivate_me/Utilities/sql_utilities.dart';

import 'Utilities/notification_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SqlUtilities sqlUtilities = SqlUtilities();
    sqlUtilities.openEmotionDatabase();

    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'How are you',
              channelDescription: 'Notification channel for how are u',
              defaultColor: const Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        debug: false
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    return MaterialApp(
      initialRoute: "/",
      navigatorKey: MyApp.navigatorKey,
      onGenerateRoute: (settings) {
        switch(settings.name){
          case '/':
            return MaterialPageRoute(builder: (context) => MainScreen(),);
          case '/quotes':
            return MaterialPageRoute(builder: (context) {
              final String emotion = settings.arguments as String;
              return QuoteScreen(emotion);
            },);
          default:
            assert(false, "Page ${settings.name} not found");
            return null;
        }
      },
    );
  }
}
