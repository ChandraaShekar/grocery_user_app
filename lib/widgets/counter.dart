import 'package:flutter/material.dart';
import 'package:user_app/widgets/text_widget.dart';

class CounterBtn extends StatelessWidget {
  final Function incPressed;
  final Function decPressed;
  final String text;
  final double widgetWidth;
  final double incDecheight;
  final double incDecwidth;
  final Color leftCounterColor;
  final Color rightCounterColor;

  const CounterBtn(
      {Key key,
      this.incPressed,
      this.decPressed,
      this.text,
      this.widgetWidth,
      this.leftCounterColor,
      this.rightCounterColor,
      this.incDecheight,
      this.incDecwidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.widgetWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
              width: this.incDecwidth,
              height: this.incDecheight,
              child: new FloatingActionButton(
                heroTag: UniqueKey(),
                onPressed: decPressed,
                child: new Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 15.0,
                ),
                backgroundColor: this.leftCounterColor,
              )),
          TextWidget(
            text,
            textType: "title",
          ),
          Container(
            width: this.incDecwidth,
            height: this.incDecheight,
            //color: Colors.red,
            child: new FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: incPressed,
              child: new Icon(
                Icons.add,
                color: Colors.white,
                size: 15.0,
              ),
              backgroundColor: this.rightCounterColor,
            ),
          ),
        ],
      ),
    );
  }
}
