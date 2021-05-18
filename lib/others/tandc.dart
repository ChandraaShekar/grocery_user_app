import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class TandC extends StatefulWidget {

  @override
  _TandCState createState() => _TandCState();
}

class _TandCState extends State<TandC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar(Constants.tncTag,null,true),
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