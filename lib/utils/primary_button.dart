import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double width;

  const PrimaryButton(
      {Key key,
      this.text,
      this.onPressed,
      this.backgroundColor,
      this.textColor,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 20,
      width: this.width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(this.backgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.height / 150),
              ))),
          onPressed: this.onPressed,
          child: Text(
            this.text,
            style: TextStyle(
                color: this.textColor,
                fontSize: size.height / 50,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700),
          )),
    );
  }
}
