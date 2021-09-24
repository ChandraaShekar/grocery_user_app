import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:user_app/auth/otp_page.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/utils/circle_painter.dart';
import 'package:user_app/widgets/text_widget.dart';

import '../main.dart';

class Login extends StatefulWidget {
  static final String tag = Constants.loginTag;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _phoneNumberController = TextEditingController();
  double _height;
  List images = [
    Constants.welcomeScreen,
  ];
  String search;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            child: Stack(children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: size.height / 12.5,
                          width: size.width / 2,
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Welcome,",
                                style: TextStyle(
                                    fontSize: size.height / 30,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                "Sign in to Continue",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: size.height / 50,
                                    letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                child: CustomPaint(
                  painter: CirclePainter(25, Constants.topRightCircleColor),
                  size: Size(25, 25),
                ),
                top: size.height / 20,
                right: size.width / 10,
              ),
              Positioned(
                child: CustomPaint(
                  painter: CirclePainter(
                    25,
                    Constants.topLeftCircleColor,
                  ),
                  size: Size(25, 25),
                ),
                top: size.height / 8,
                left: size.width / 10,
              ),
              Positioned(
                child: CustomPaint(
                  painter: CirclePainter(15, Constants.bottomRightCircleColor),
                  size: Size(15, 15),
                ),
                top: size.height / 2,
                right: size.width / 16,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        autoPlayInterval: Duration(seconds: 3),
                        scrollDirection: Axis.horizontal,
                        //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                        initialPage: 0,
                        height: size.height / 2.6,
                      ),
                      items: images.map((imgUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: size.width,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Stack(children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(25.0),
                                      child: Image.asset(
                                        imgUrl,
                                        width: size.width,
                                        height: size.height / 4,
                                        fit: BoxFit.contain,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, top: 195),
                                    child: Container(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: TextWidget(
                                            "We are excited for having you here",
                                            textType: "para-bold",
                                          ),
                                        ),
                                        Center(
                                          child: TextWidget(
                                            "Login to place your order.",
                                            textType: "para-bold",
                                          ),
                                        ),
                                      ],
                                    )),
                                  )
                                ]));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Container(
                    height: _height,
                    width: size.width,
                    color: Colors.transparent,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Transform(
                                  transform:
                                      Matrix4.translationValues(0, 6, 0.0),
                                  child: TextWidget(
                                    "Please enter your phone number",
                                    textType: "para-bold",
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      width: size.width / 1.2,
                                      height: size.height / 12,
                                      child: TextField(
                                        style: TextStyle(
                                            fontSize: size.height / 30,
                                            color: Constants.headingTextBlack,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2.0),
                                        controller: _phoneNumberController,
                                        decoration: InputDecoration(
                                          // or  prefixIcon: Text('+91'),
                                          prefixText: '+91 ',
                                          prefixStyle: TextStyle(
                                              fontSize: size.height / 30,
                                              color: Constants.headingTextBlack,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.7),
                                          hintText: 'Enter Phone Number ',
                                          contentPadding: const EdgeInsets.only(
                                              top: 10, left: 15),
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 10),
                                TextWidget(
                                  'OTP Will be sent to your phone number',
                                  textType: "para-bold",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          PrimaryButton(
                            backgroundColor: Constants.kButtonBackgroundColor,
                            textColor: Constants.kButtonTextColor,
                            text: "CONTINUE",
                            width: size.width * 0.9 - 10,
                            onPressed: () {
                              if (_phoneNumberController.text.length < 10) {
                                MyApp.showToast(
                                    'Enter Valid Phone Number', context);
                              } else {
                                startPhoneAuth();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  startPhoneAuth() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OtpPage(phoneNumber: _phoneNumberController.text)));
  }
}
