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
    return SizedBox(
      width: this.width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(this.backgroundColor)),
          onPressed: this.onPressed,
          child: Text(
            this.text,
            style: TextStyle(color: this.textColor),
          )),
    );
  }
}