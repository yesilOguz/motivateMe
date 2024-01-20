import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:motivate_me/Models/quote.dart';
import "dart:math";

import 'package:motivate_me/Models/thumbnail.dart';
import 'package:motivate_me/Utilities/notification_controller.dart';
import 'package:motivate_me/Utilities/sql_utilities.dart';
import 'package:path_provider/path_provider.dart';

class Utilities {
  static String wikipediaApiBaseUrl = "https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrlimit=1&prop=pageimages%7Cextracts&pithumbsize=400&format=json&gsrsearch=";
  static String favqsApiBaseUrl = "https://favqs.com/api/quotes/?filter=";

  static String favqsApiKey = "27c1d786a5334db3f2a2da97fe12ac4d";

  // EIf that function calls itself too many times, the problem may be caused by the favqs server or something,
  // it is more logical to throw it to the main screen.
  static int COUNTER_FOR_GET_QUOTE = 0;

  static List<String> positiveEmotions = [
    "Alertness",
    "Amusement",
    "Awe",
    "Gratitude",
    "Hope",
    "Joy",
    "Love",
    "Pride",
    "Satisfaction"
  ];

  static List<String> negativeEmotions = [
    "Anger",
    "Anxiety",
    "Contempt",
    "Disgust",
    "Embarrassment",
    "Fear",
    "Quilt",
    "Offense",
    "Sadness"
  ];

  static Color getBackgroundColor(){
    return const Color.fromRGBO(207, 207, 181, 1);
  }

  static Future<Thumbnail> getThumbnail(String name) async{
    String imageUrl = "";
    int height = 0;
    String url = wikipediaApiBaseUrl + name;

    var wikipediaResponse = await http.get(Uri.parse(url));
    var wikipediaJson = json.decode(wikipediaResponse.body);

    try{
      var res = wikipediaJson["query"]["pages"];
      res = res[res.keys.first];
      imageUrl = res["thumbnail"]["source"];
      height = res["thumbnail"]["height"];
    }catch(e){
      imageUrl = "";
    }

    return Thumbnail(imageUrl, height);
  }

  static Future<Quote> getQuote(String emotion) async{
    SqlUtilities sqlUtilities = SqlUtilities();

    if(COUNTER_FOR_GET_QUOTE == 10){
      COUNTER_FOR_GET_QUOTE = 0;
      return Quote.empty();
    } else {
      COUNTER_FOR_GET_QUOTE++;
    }

    // testing what happens when the function calls itself more than 10 times
    //return Quote.empty();

    String url = favqsApiBaseUrl + emotion;

    var quoteResponse = await http.get(Uri.parse(url),
                                      headers: {"Authorization": "Token token=$favqsApiKey"});
    var quoteJson = json.decode(quoteResponse.body);

    Random random = Random();

    var quotes =  quoteJson["quotes"];
    var randomQuote = quotes[random.nextInt(quotes.length)];

    if(randomQuote["body"] == "No quotes found") {
      // I don't think it's possible, but let's make sure.
      COUNTER_FOR_GET_QUOTE = 0;

      return Quote.noData();
    }

    if(randomQuote == null) return await getQuote(emotion);

    Thumbnail thumbnail = await getThumbnail(randomQuote["author_permalink"]);

    if(thumbnail.url == "") return await getQuote(emotion);

    Quote quote = Quote(randomQuote["id"], randomQuote["url"],
              randomQuote["author"], randomQuote["author_permalink"], randomQuote["body"], thumbnail);

    sqlUtilities.addEmotion(emotion);
    NotificationController.createSchedule();

    COUNTER_FOR_GET_QUOTE = 0;
    return quote;
  }

  static getSqlFilesPath() async{
    var dirs = await getExternalStorageDirectories(type: StorageDirectory.documents);

    return dirs!.last.path;
  }

}
