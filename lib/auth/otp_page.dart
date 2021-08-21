import 'dart:convert';
import 'dart:core';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/loginapi.dart';
import 'package:user_app/auth/login.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';

import '../main.dart';
import 'registration.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  OtpPage({Key key, @required this.phoneNumber}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String code = "";
  int maxLength = 6;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verfId;
  ConfirmationResult confirmationResult;
  TextEditingController otpController;

  @override
  void initState() {
    _load();
    otpController = TextEditingController();
    super.initState();
  }

  void _load() async {
    if (kIsWeb) {
      // running on the web!
      confirmationResult = await FirebaseAuth.instance
          .signInWithPhoneNumber('+91${widget.phoneNumber}');
      // .then(
      //   (value) => (PhoneAuthCredential credential) async {
      //     await FirebaseAuth.instance
      //         .signInWithCredential(credential)
      //         .then((value) async {
      //       if (value.user != null) {
      //         log("going here");
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => Registration()),
      //             (route) => false);
      //       }
      //     });
      //   },
      // );
    } else {
      // NOT running on the web! You can check for additional platforms here.
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91${widget.phoneNumber}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance
                .signInWithCredential(credential)
                .then((value) async {
              if (value.user != null) {
                final User user = auth.currentUser;
                final uid = user.uid;
                MyApp.loginIdValue = uid;
                MyApp.authTokenValue = "";
                setState(() {});
                var authToken = await user.getIdToken();
                LoginApiHandler loginHandler =
                    new LoginApiHandler({"auth_token": authToken});
                var response = await loginHandler.login();
                print(response);
                if (response[0] == 200) {
                  // NaviMyApp.showToast(response[1]['message'], context);
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString(
                      Constants.userInfo, jsonEncode(response[1]['user']));
                  MyApp.userInfo = response[1]['user'];

                  sharedPreferences.setString(Constants.authTokenValue,
                      jsonEncode(response[1]['access_token']));
                  MyApp.authTokenValue = response[1]['access_token'];
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DashboardTabs()));
                } else if (response[0] == 404) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Registration()));
                } else {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ()));
                }
              }
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e.message);
          },
          codeSent: (String verficationID, int resendToken) {
            setState(() {
              verfId = verficationID;
            });
          },
          codeAutoRetrievalTimeout: (String verificationID) {
            setState(() {
              verfId = verificationID;
            });
          },
          timeout: Duration(seconds: 120));
    }
  }

  String scode = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Verify your number",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "6 digit code sent to ",
                      style: TextStyle(
                          color: Constants.secondaryTextColor,
                          fontSize: size.height / 55),
                    ),
                    Text(
                      '+91 ' + widget.phoneNumber,
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: size.height / 55,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    controller: otpController,
                  ),
                ),
                // OtpTextField(
                //   textStyle: TextStyle(
                //       fontSize: size.height / 40, fontWeight: FontWeight.w600),
                //   numberOfFields: 6,
                //   enabledBorderColor: Colors.grey,
                //   focusedBorderColor: Constants.kMain,
                //   showFieldAsBox:
                //       false, //set to true to show as box or false to show as dash
                //   onCodeChanged: (String code) {
                //     //handle validation or checks here
                //   },
                //   onSubmit: (String verificationCode) {
                //     scode = verificationCode;
                //     setState(() {});
                //   }, // end onSubmit
                // ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: PrimaryButton(
                    backgroundColor: Constants.kButtonBackgroundColor,
                    textColor: Constants.kButtonTextColor,
                    text: "VERIFY",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => Center(
                                child: Container(
                                    child: CircularProgressIndicator()),
                              ));
                      scode = otpController.text;
                      if (scode.length < 6) {
                        MyApp.showToast('Enter valid otp', context);
                      } else if (verfId == null && !kIsWeb) {
                        MyApp.showToast('wait for few seconds', context);
                      } else if (kIsWeb) {
                        await confirmationResult
                            .confirm(scode)
                            .then((value) async {
                          if (value.user != null) {
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            MyApp.loginIdValue = uid;
                            MyApp.authTokenValue = "";
                            setState(() {});
                            var authToken = await user.getIdToken();
                            print(authToken);
                            LoginApiHandler loginHandler =
                                new LoginApiHandler({"auth_token": authToken});
                            var response = await loginHandler.login();
                            if (response[0] == 200) {
                              // NaviMyApp.showToast(response[1]['message'], context);
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString(Constants.userInfo,
                                  jsonEncode(response[1]['user']));
                              MyApp.userInfo = response[1]['user'];

                              sharedPreferences.setString(
                                  Constants.authTokenValue,
                                  jsonEncode(response[1]['access_token']));
                              MyApp.authTokenValue =
                                  response[1]['access_token'];
                              MyApp.isLoggedIn().then((_) {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardTabs()));
                              });
                            } else if (response[0] == 404) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registration()));
                            } else {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => ()));
                            }
                          }
                        });
                      } else if (verfId != null) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verfId, smsCode: scode))
                              .then((value) async {
                            if (value.user != null) {
                              final User user = auth.currentUser;
                              final uid = user.uid;
                              MyApp.loginIdValue = uid;
                              MyApp.authTokenValue = "";
                              setState(() {});
                              var authToken = await user.getIdToken();
                              LoginApiHandler loginHandler =
                                  new LoginApiHandler(
                                      {"auth_token": authToken});
                              var response = await loginHandler.login();
                              print(response);
                              if (response[0] == 200) {
                                // NaviMyApp.showToast(response[1]['message'], context);
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                sharedPreferences.setString(Constants.userInfo,
                                    jsonEncode(response[1]['user']));
                                MyApp.userInfo = response[1]['user'];

                                sharedPreferences.setString(
                                    Constants.authTokenValue,
                                    jsonEncode(response[1]['access_token']));
                                MyApp.authTokenValue =
                                    response[1]['access_token'];
                                MyApp.loadAddresses();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DashboardTabs()));
                              } else if (response[0] == 404) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Registration()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                            }
                          });
                        } catch (e) {
                          FocusScope.of(context).unfocus();
                          print("$e");
                          // MyApp.showToast('Invalid otp', context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
