import 'dart:io';

import 'package:motivate_me/Utilities/utilities.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/utils/utils.dart';

import 'notification_controller.dart';

class SqlUtilities{
  static SqlUtilities? _instance;

  late Database emotionHistoryDatabase;

  SqlUtilities._internal();

  factory SqlUtilities(){
    if(_instance == null){
      _instance = SqlUtilities._internal();
    }

    return _instance!;
  }

  openEmotionDatabase() async{
    var dbPath = await Utilities.getSqlFilesPath();

    Directory dir = Directory(dbPath);
    if(!await dir.exists()) await dir.create(recursive: true);

    String emotionDatabase = Path.join(dbPath, "emotionHistory.db");

    emotionHistoryDatabase = await openDatabase(emotionDatabase, version: 1,
      onCreate: (db, version) async{
        await db.execute("CREATE TABLE emotions (id INTEGER PRIMARY KEY, date INTEGER, emotion TEXT)");
      },);

    NotificationController.createSchedule();
  }

  addEmotion(String emotion) async{
    int date = DateTime.now().microsecondsSinceEpoch;

    await emotionHistoryDatabase.transaction((txn) async{
      txn.rawInsert(
        "INSERT INTO emotions(date, emotion) VALUES(?, ?)",
        [date, emotion]
      );
    },);
  }

  getEmotions() async{
    String query = "SELECT * FROM emotions";

    List<Map> emotions = await emotionHistoryDatabase.rawQuery(query);

    return emotions;
  }

  Future<List<String>> getLastThreeEmotion() async{
    String query = "SELECT DISTINCT emotion FROM emotions";

    List<String> emotionList = List<String>.empty(growable: true);

    List<Map> emotions = await emotionHistoryDatabase.rawQuery(query);

    for(Map i in emotions){
      if(emotionList.length == 3) break;

      emotionList.add(i["emotion"]);
    }

    return emotionList;
  }

  isThereHistory() async{
    String query = "SELECT COUNT(*) FROM emotions";

    int? count = firstIntValue(await emotionHistoryDatabase.rawQuery(query));

    if(count! != 0) return true;

    return false;
  }

}