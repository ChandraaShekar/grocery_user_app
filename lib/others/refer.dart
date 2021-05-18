import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class Refer extends StatefulWidget {

  @override
  _ReferState createState() => _ReferState();
}

class _ReferState extends State<Refer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar(Constants.referTag,null,true),
      body:SingleChildScrollView(
        child:Container(
          child:Column(
            children: [
         
            ],
          )
        )
      )
    );
  }
}