import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motivate_me/Utilities/utilities.dart';
import 'package:motivate_me/Models/quote.dart';

class QuoteScreen extends StatefulWidget {
  String emotion;

  QuoteScreen(this.emotion);

  @override
  State<StatefulWidget> createState() {
    return QuoteState(emotion);
  }
}

class QuoteState extends State {
  String emotion;
  Quote? quote;

  QuoteState(this.emotion);

  @override
  void initState() {
    getQuote();
  }

  getQuote() async {
    quote = await Utilities.getQuote(emotion);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utilities.getBackgroundColor(),
      body: buildBody(),
    );
  }

  popScreenDelay() async {
    Duration duration = Duration(seconds: 2);
    return Timer(duration, popScreen);
  }

  popScreen() {
    Navigator.of(context).pop();
  }

  buildBody() {
    if (quote == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (quote!.id == -1) {
      Fluttertoast.showToast(msg: "There is an unknown problem");

      popScreenDelay();
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (quote!.id == -2) {
      return const Center(
        child: Text(
          "We couldn't find any quotes for your feelings",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "Ic",
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: Image.network(
                    quote!.thumbnail.url,
                    fit: BoxFit.fitWidth,
                  )),
              SizedBox(
                height: double.parse(quote!.thumbnail.height.toString()) + 100,
                child: Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0, 0.6, 1],
                      colors: [
                        Utilities.getBackgroundColor().withAlpha(70),
                        Utilities.getBackgroundColor().withAlpha(220),
                        Utilities.getBackgroundColor().withAlpha(255),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: double.parse(quote!.thumbnail.height.toString()),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(58.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: "“ ",
                          style: const TextStyle(
                              fontFamily: "Ic",
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 22),
                          children: [
                            TextSpan(
                              text: quote!.body,
                              style: const TextStyle(
                                  fontFamily: "Ic",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            const TextSpan(
                              text: "”",
                              style: TextStyle(
                                  fontFamily: "Ic",
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22),
                            ),
                            TextSpan(
                              text: quote!.author.isEmpty
                                  ? ""
                                  : "\n${quote!.author}",
                              style: const TextStyle(
                                  fontFamily: "Ic",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: ()=>refreshPage(), icon: const Icon(Icons.refresh_rounded, size: 28,),),
                  const SizedBox(width: 15,),
                  IconButton(onPressed: ()=>copyQuote(), icon: const Icon(Icons.copy_rounded, size: 28,)),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  copyQuote() async{
    await Clipboard.setData(ClipboardData(text: '"${quote!.body}"\n-${quote!.author}'));

    Fluttertoast.showToast(msg: "Your motivation in your clipboard now 💪");
  }

  refreshPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => QuoteScreen(emotion),)
    );
  }
}
