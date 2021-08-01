import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;

  NotificationCard({this.title, this.subTitle, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              ListTile(
                  leading: CircleAvatar(
                      backgroundColor: Constants.drawerBgColor,
                      child: Icon(
                        Ionicons.ios_notifications_outline,
                        color: Colors.pinkAccent,
                      )),
                  title: TextWidget(this.title, textType: "title"),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextWidget(
                      this.subTitle,
                      textType: "para",
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextWidget(
                    this.time,
                    textType: "label-light",
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
