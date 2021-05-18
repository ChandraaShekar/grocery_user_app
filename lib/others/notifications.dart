import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_app/widgets/notification_card.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon:Icon(Icons.clear),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
         backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Notifications',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body:ListView.builder(
        itemCount: 6,
        itemBuilder: (context,index){
          return NotificationCard(
            title: 'Fresh Food Fiesta',
            time: 'now',
            subTitle: 'Kraft Cheese Tin 200G was: Rs.825.00 Nexus Member Deal: Rs.618.00',
          );
      })
    );
  }
}