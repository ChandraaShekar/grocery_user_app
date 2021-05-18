import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';

class NotificationCard extends StatelessWidget {
  
  final String title;
  final String subTitle;
  final String time;

  NotificationCard({this.title,this.subTitle,this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Card(
         child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children:[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child:Icon(Ionicons.ios_notifications_outline,color: Constants.drawerIconColor,)
                  ),
                  title: Text(this.title),
                  subtitle: Text(this.subTitle)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(this.time,style: TextStyle(color:Constants.drawerIconColor),)
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}