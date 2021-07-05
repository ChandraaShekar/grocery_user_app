import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:share/share.dart';

class Refer extends StatefulWidget {
  @override
  _ReferState createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar(Constants.referTag, null, true),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: TextWidget("Refer and Earn", textType: "heading")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextWidget(
                      "Your referal code: ${MyApp.userInfo['referal_code']}",
                      textType: "title"),
                  IconButton(
                      icon: Icon(Icons.share_rounded),
                      onPressed: () {
                        Share.share(
                            "Hey there! Download Frutte application today to avail exciting offers. Use my referal code \"${MyApp.userInfo['referal_code']}\" to get a wooping 50% offer on your first order.",
                            subject: 'Get 50% off on first order in Frutte');
                      })
                ],
              )),
            )
          ],
        ))));
  }
}
