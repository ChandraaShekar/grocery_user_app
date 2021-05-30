import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final String textType;
  TextWidget(this.text, {this.textType});

  TextStyle styler(String textType, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String x = textType.toLowerCase();
    TextStyle y;
    if (x == "heading") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          // letterSpacing: 0.2,
          fontSize: size.height / 36,
          color: Constants.headingTextBlack);
    } else if (x == "subheading") {
      y = TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: size.height / 40,
          color: Constants.headingTextBlack);
    } else if (x == "subheading-grey") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 44,
          color: Constants.secondaryTextColor);
    } else if (x == "title") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 45,
          color: Constants.headingTextBlack);
    } else if (x == "subtitle-black") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 54,
          color: Constants.headingTextBlack);
    } else if (x == "subtitle-grey") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 54,
          color: Constants.secondaryTextColor);
    } else if (x == "card-price") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 45,
          color: Constants.secondaryTextColor);
    } else if (x == "para") {
      y = TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontSize: size.height / 54,
          color: Constants.headingTextBlack);
    } else if (x == "label") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          fontSize: size.height / 54,
          color: Constants.headingTextBlack);
    }
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${this.text}",
      style: styler(this.textType, context),
    );
  }
}
