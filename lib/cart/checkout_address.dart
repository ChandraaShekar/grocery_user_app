import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/cart/payments.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/userLocationOnMap.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/text_widget.dart';

class CheckoutAddress extends StatefulWidget {
  @override
  _CheckoutAddressState createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress>
    with TickerProviderStateMixin {
  TextEditingController address, houseNo, landmark;
  String street1Err = '', cityErr = '', landmarkErr = '', stateErr = '';

  AnimationController animationController;
  Animation p1, d2;

  void initState() {
    super.initState();
    address = TextEditingController(text: MyApp.userInfo['address']);
    houseNo = TextEditingController(text: MyApp.userInfo['flat_no']);
    landmark = TextEditingController(text: MyApp.userInfo['landmark']);

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
                                Container(
                                  child: Center(
                                    child: Container(
                                      height: 3,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.grey),
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
                                          color: Colors.grey),
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
                        height: 20,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(14, 25, 0, 20),
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         AntDesign.checkcircle,
                      //         color: Constants.buttonBgColor,
                      //       ),
                      //       SizedBox(width: 8),
                      //       Text('Save as Default Address')
                      //     ],
                      //   ),
                      // ),
                      Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Center(
                            child: TextWidget("Delivery Location",
                                textType: "subheading"),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18),
                              Text('Address'),
                              TextFormField(
                                controller: address,
                              ),
                              SizedBox(height: 18),
                              Text('Flat No./House No.'),
                              TextFormField(
                                controller: houseNo,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              if (stateErr != '')
                                Text(
                                  ' *Required',
                                  style: TextStyle(color: Colors.red),
                                ),
                              SizedBox(height: 18),
                              Text('Landmark'),
                              TextFormField(
                                controller: landmark,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              if (landmarkErr != '')
                                Text(
                                  ' *Required',
                                  style: TextStyle(color: Colors.red),
                                ),
                              SizedBox(height: 10),
                              Center(
                                  child: TextButton(
                                      child:
                                          Text("Pick delivery location on Map"),
                                      onPressed: () async {
                                        var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserLocationOnMap()));

                                        print(result);
                                      })),
                              SizedBox(height: 30),
                              Center(
                                child: PrimaryButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    Map<String, dynamic> exportData = {
                                      "address": address.text,
                                      "flat_no": houseNo.text,
                                      "landmark": landmark.text,
                                      "user_lat": MyApp.lat,
                                      "user_lng": MyApp.lng
                                    };
                                    print("BEFORE: $exportData");
                                    RegisterApiHandler updateHandler =
                                        new RegisterApiHandler(exportData);

                                    List resp =
                                        await updateHandler.updateAddress();

                                    print("${resp[1]}");
                                    MyApp.showToast(
                                        resp[1]['message'], context);
                                    if (resp[0] == 200) {
                                      // NaviMyApp.showToast(response[1]['message'], context);
                                      SharedPreferences sharedPreferences =
                                          await SharedPreferences.getInstance();
                                      sharedPreferences.setString(
                                          Constants.userInfo,
                                          jsonEncode(resp[1]['user']));
                                      MyApp.userInfo = resp[1]['user'];

                                      sharedPreferences.setString(
                                          Constants.authTokenValue,
                                          jsonEncode(resp[1]['access_token']));
                                      MyApp.authTokenValue =
                                          resp[1]['access_token'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Payments()));
                                    }
                                  },
                                  backgroundColor:
                                      Constants.kButtonBackgroundColor,
                                  textColor: Constants.kButtonTextColor,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  text: "CONTINUE",
                                ),
                              ),
                              SizedBox(height: 15),
                            ]),
                      )
                    ],
                  ),
                )),
      ),
    );
  }
}
