import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> with TickerProviderStateMixin {
  TextEditingController street1, street2, city, landmark, state;
  String street1Err = '', cityErr = '', landmarkErr = '', stateErr = '';

  AnimationController animationController;
  Animation p1, d2;

  void initState() {
    super.initState();
    street1 = TextEditingController();
    street2 = TextEditingController();
    city = TextEditingController();
    landmark = TextEditingController();
    state = TextEditingController();

    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    p1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Interval(0.5, 0.6)));
    d2 = ColorTween(begin: Colors.white, end: Constants.buttonBgColor).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6, 0.8, curve: Curves.linear)));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = 16.0;
    return Scaffold(
      appBar: Header.appBar('Checkout', null, true),
      body: SingleChildScrollView(
        child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) => Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 0.5,
                                          color: Constants.buttonBgColor)),
                                  width: dotSize + 12,
                                  height: dotSize + 12,
                                  child: Center(
                                    child: Container(
                                        width: dotSize,
                                        height: dotSize,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                dotSize / 2),
                                            color: Constants.buttonBgColor)),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Container(
                                      height: 3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: LinearProgressIndicator(
                                        backgroundColor:
                                            Constants.buttonBgColor,
                                        // value: p1.value,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Constants.buttonBgColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 0.5, color: Colors.grey)),
                                  width: dotSize + 12,
                                  height: dotSize + 12,
                                  child: Center(
                                    child: Container(
                                      width: dotSize,
                                      height: dotSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              dotSize / 2),
                                          color: Constants.buttonBgColor),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: Container(
                                      height: 3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey,
                                        value: p1.value,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Constants.buttonBgColor),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 0.5, color: Colors.grey)),
                                  width: dotSize + 12,
                                  height: dotSize + 12,
                                  child: Center(
                                    child: Container(
                                      width: dotSize,
                                      height: dotSize,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              dotSize / 2),
                                          color: d2.value),
                                    ),
                                  ),
                                ),
                              ])),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 8.0,
                          top: 4,
                        ),
                        child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Items'),
                            Expanded(child: Container()),
                            Text('Address'),
                            Expanded(child: Container()),
                            Text('Payment')
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: PrimaryButton(
                          onPressed: () {},
                          backgroundColor: Constants.kButtonBackgroundColor,
                          textColor: Constants.kButtonTextColor,
                          width: MediaQuery.of(context).size.width * 0.5,
                          text: "CONTINUE",
                        ),
                      ),
                    ],
                  ),
                )),
      ),
    );
  }
}
