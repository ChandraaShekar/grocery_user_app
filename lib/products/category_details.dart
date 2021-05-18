import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class CatgoryDetails extends StatefulWidget {
  @override
  _CatgoryDetailsState createState() => _CatgoryDetailsState();
}

class _CatgoryDetailsState extends State<CatgoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
     Container(color: Colors.white,
      child: Column(
        children: [
          Image.asset(
            Constants.beverageImage,
            width:MediaQuery.of(context).size.width,
            
            height: 150,
            )
        ],
      ),
     ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar:Header.appBar('Beverages', null, false),
        body:Container()
      )
    ],);
  }
}