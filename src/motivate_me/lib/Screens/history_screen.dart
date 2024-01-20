import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:motivate_me/Utilities/notification_controller.dart';
import 'package:motivate_me/Utilities/sql_utilities.dart';
import 'package:motivate_me/Utilities/utilities.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map> history = List.empty(growable: true);
  bool isHistoryLoaded = false;

  SqlUtilities sqlUtilities = SqlUtilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Utilities.getBackgroundColor(),
      body: buildBody(),
    );
  }

  @override
  initState() {
    super.initState();
    getHistory();
  }

  getHistory() async {
    history = await sqlUtilities.getEmotions();
    isHistoryLoaded = true;
    setState(() {});
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("When Did You Get Motivated!"),
      centerTitle: true,
      backgroundColor: const Color.fromRGBO(175, 200, 173, 1),
    );
  }

  buildBody() {
    if (!isHistoryLoaded) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (history.isEmpty) {
      return const Center(
        child: Text(
          "You aren't motivated yet!!",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Ic",
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        children: generateHistory(),
      ),
    );
  }

  generateHistory() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(createEmotionContainer("Date"));
    widgets.add(createEmotionContainer("Emotion"));
    
    for (Map emotions in history.reversed) {
      DateTime time = DateTime.fromMicrosecondsSinceEpoch(emotions["date"]);
      String dateString = "${time.month}/${time.day}/${time.year}\n${time.hour}:${time.minute}";

      widgets.add(createEmotionContainer(dateString));
      widgets.add(createEmotionContainer(emotions["emotion"]));
    }

    return widgets;
  }
  
  createEmotionContainer(String text){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
