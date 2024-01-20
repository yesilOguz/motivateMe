import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:motivate_me/Screens/quote_screen.dart';
import 'package:motivate_me/Utilities/sql_utilities.dart';
import 'package:motivate_me/Utilities/utilities.dart';

import '../main.dart';

class NotificationController {
  static createSchedule() async{
    SqlUtilities sqlUtilities = SqlUtilities();

    bool isThereHistory = await sqlUtilities.isThereHistory();
    if(!isThereHistory) return;

    await AwesomeNotifications().cancelAll();

    List<String> lastEmotions = await sqlUtilities.getLastThreeEmotion();

    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: "basic_channel",
          title: "Be Motivated!!",
          body: "How are you ?",
          wakeUpScreen: true,
      ),
      schedule: NotificationInterval(interval: 300, repeats: true),
      actionButtons: List.generate(lastEmotions.length, (index) {
        return NotificationActionButton(
          key: lastEmotions[index],
          label: lastEmotions[index],
        );
      },
      )
    );
  }

  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    String emotion = receivedAction.buttonKeyPressed;

    print(Utilities.positiveEmotions.contains(emotion));
    print(Utilities.negativeEmotions.contains(emotion));

    if(!Utilities.positiveEmotions.contains(emotion)
        && !Utilities.negativeEmotions.contains(emotion)){
      return;
    }

    SqlUtilities sqlUtilities = SqlUtilities();
    sqlUtilities.addEmotion(emotion);

    NotificationController.createSchedule();

    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/',
      (route) => false,
    );

    MyApp.navigatorKey.currentState!.pushNamed(
      "/quotes",
      arguments: emotion
    );

  }

}