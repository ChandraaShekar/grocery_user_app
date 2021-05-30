import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class AllCatgories extends StatefulWidget {
  @override
  _AllCatgoriesState createState() => _AllCatgoriesState();
}

class _AllCatgoriesState extends State<AllCatgories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar("Categories", null, true),
    );
  }
}
