import 'package:flutter/material.dart';

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
      this.incDecwidth
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          width:this.widgetWidth,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
             Container(
              width: this.incDecwidth,
               height: this.incDecheight,
              child: new FloatingActionButton(
                heroTag:  UniqueKey(),
                onPressed:decPressed,
                child: new Icon(
                 Icons.remove,
                   color: Colors.white),
                backgroundColor: this.leftCounterColor,)
            ),
            Text(text,style: TextStyle(fontSize: 16),),
            Container(
              width: 48,
              height: 40,
              //color: Colors.red,
              child: new FloatingActionButton(
                 heroTag: UniqueKey(),
                onPressed: incPressed,
                child: new Icon(Icons.add, color: Colors.white,),
                backgroundColor: this.rightCounterColor,),
            ),
           
          ],
        ),
      );
  }
}
