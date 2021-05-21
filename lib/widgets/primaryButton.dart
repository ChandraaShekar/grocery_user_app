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
    return Container(
      child: Container(
        height: 40,
        width: width ?? MediaQuery.of(context).size.width * 0.4,
        child: TextButton(
            child: Text('${this.title}',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => Constants.primryColor)),
            onPressed: this.onPressed),
      ),
    );
  }
}
