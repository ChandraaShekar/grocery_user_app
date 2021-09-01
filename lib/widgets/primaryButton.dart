import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';

class PrimaryCustomButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  final double width;
  PrimaryCustomButton({Key key, this.title, this.onPressed, this.width})
      : super(key: key);

  @override
  _PrimaryCustomButtonState createState() =>
      _PrimaryCustomButtonState(this.title, this.onPressed, this.width);
}

class _PrimaryCustomButtonState extends State<PrimaryCustomButton> {
  final String title;
  final Function onPressed;
  final double width;
  _PrimaryCustomButtonState(this.title, this.onPressed, this.width);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Container(
        height: size.width / 10,
        width: width ?? MediaQuery.of(context).size.width * 0.4,
        child: TextButton(
            child: Text('${this.title}',
                style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Constants.primaryColor)),
            onPressed: this.onPressed),
      ),
    );
  }
}
