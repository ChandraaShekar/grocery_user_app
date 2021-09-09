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
          fontSize: size.height / 45,
          color: Constants.headingTextBlack);
    } else if (x == "subheading") {
      y = TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          fontSize: size.height / 50,
          color: Constants.headingTextBlack);
    } else if (x == "subheading-grey") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 50,
          color: Constants.secondaryTextColor);
    } else if (x == "platform-title") {
      y = TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontSize: size.height / 56,
          color: Constants.greyHeading
          );
    } else if (x == "title") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 56,
          color: Constants.headingTextBlack);
    } else if (x == "subtitle-black") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 60,
          color: Constants.headingTextBlack);
    } else if (x == "subtitle-grey") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 60,
          color: Constants.secondaryTextColor);
    } else if (x == "title-light") {
      y = TextStyle(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          fontSize: size.height / 56,
          color: Constants.headingTextBlack);
    } else if (x == "card-price") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 58,
          color: Constants.secondaryTextColor);
    } else if (x == "para") {
      y = TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          fontSize: size.height / 56,
          color: Constants.headingTextBlack);
    } else if (x == "para-bold") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          fontSize: size.height / 52,
          color: Constants.headingTextBlack);
    } else if (x == "label") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          fontSize: size.height / 60,
          color: Constants.headingTextBlack);
    } else if (x == "label-white") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          fontSize: size.height / 60,
          color: Colors.white);
    } else if (x == "label-light") {
      y = TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          fontSize: size.height / 60,
          color: Colors.grey[800]);
    } else if (x == "label-grey") {
      y = TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          fontSize: size.height / 60,
          color: Colors.grey[800]);
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
