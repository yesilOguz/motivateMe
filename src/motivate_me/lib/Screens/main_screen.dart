import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:motivate_me/Screens/quote_screen.dart';
import 'package:motivate_me/Screens/history_screen.dart';
import 'package:motivate_me/Utilities/utilities.dart';

import '../Utilities/notification_controller.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {

    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Utilities.getBackgroundColor(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Motivate Me!"),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(175, 200, 173, 1),
    );
  }

  buildBody() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text("How are you ?",
              style: TextStyle(color: Colors.white70, fontSize: 45)),
        ),
        Expanded(
         // height: 400,
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1.20,
              children: generateList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () => loadHistoryScreen(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
                  ),
                  child: const Text("Show History", style: TextStyle(fontSize: 22),),
                ),
              )),
        ),
      ],
    );
  }

  List<Widget> generateList() {
    List<Widget> negativeWidgets =
        List.generate(Utilities.negativeEmotions.length, (index) {
      return GestureDetector(
        onTap: () => loadQuoteScrenn(Utilities.negativeEmotions[index]),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.redAccent),
              borderRadius: BorderRadius.circular(23)),
          child: Center(
              child: Text(
            Utilities.negativeEmotions[index],
            style: const TextStyle(color: Colors.redAccent),
          )),
        ),
      );
    });

    List<Widget> positiveWidgets =
        List.generate(Utilities.positiveEmotions.length, (index) {
      return GestureDetector(
        onTap: () => loadQuoteScrenn(Utilities.positiveEmotions[index]),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.circular(23)),
          child: Center(
              child: Text(
            Utilities.positiveEmotions[index],
            style: const TextStyle(color: Colors.lightBlue),
          )),
        ),
      );
    });

    List<Widget> widgets = List.from(positiveWidgets);
    widgets.addAll(negativeWidgets);

    return widgets;
  }

  loadQuoteScrenn(String emotion) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => QuoteScreen(emotion),)
    );
  }

  loadHistoryScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => HistoryScreen(),)
    );
  }
}
