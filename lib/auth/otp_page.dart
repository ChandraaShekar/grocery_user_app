import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                  (route) => false);
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

  String scode = '';

  @override
  Widget build(BuildContext context) {
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
                      style: TextStyle(color: Constants.secondaryTextColor),
                    ),
                    Text(
                      '+91 ' + widget.phoneNumber,
                      style: TextStyle(
                          color: Colors.blue[600], fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                OtpTextField(
                  numberOfFields: 6,
                  enabledBorderColor: Colors.grey,
                  focusedBorderColor: Constants.kMain,
                  showFieldAsBox:
                      false, //set to true to show as box or false to show as dash
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  onSubmit: (String verificationCode) {
                    scode = verificationCode;
                    setState(() {});
                  }, // end onSubmit
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: PrimaryButton(
                    backgroundColor: Constants.kButtonBackgroundColor,
                    textColor: Constants.kButtonTextColor,
                    text: "VERIFY",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if (scode.length < 6) {
                        MyApp.showToast('Enter valid otp', context);
                      } else if (verfId == null) {
                        MyApp.showToast('wait for few seconds', context);
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
                              //shared preferences store
                              MyApp.loginIdValue = uid;
                              MyApp.authTokenValue =
                                  "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdG9yZUluZm8iOnsiaWQiOiIxIiwic3RvcmVfaWQiOiJiZDgwNTczZi05MjZmLTQwYjItOTcxYS03MjI0NzBmZCIsInN0b3JlX25hbWUiOiJEb3lsZS1GbGF0bGV5Iiwic3RvcmVfYWRkcmVzcyI6Ijg1MTA0IExvb21pcyBDaXJjbGUiLCJzdG9yZV9nc3Rfbm8iOiI5NDM1NDYyMjk0Iiwic3RvcmVfbG9jYXRpb24iOiJmbG9hdCIsIm93bmVyX25hbWUiOiJCYXNpbGl1cyBNaXNzZWxicm9vayIsImNvbnRhY3Rfbm8iOiI0NTEtNjQyLTUzIiwiZW1haWwiOiJibWlzc2VsYnJvb2swQG1sYi5jb20iLCJub3RpZmljYXRpb25fdG9rZW4iOiI4NTUyMDQzOTM5Iiwibm90aWZpY2F0aW9uX3N1YnNjcmlwdGlvbiI6Ijc0OTI2NTQ2NzciLCJhY2NvdW50X3N0YXR1cyI6IjEiLCJzZWNvbmRhcnlfY29udGFjdCI6IjcxNSA3OTIgODIiLCJmb29kX2xpY2Vuc2Vfbm8iOiI2OTQ4NDY0OTU1Iiwib3duZXJfYWRoYXJfbm8iOiI4MzQ5ODc5NTIxIiwib3duZXJfcGFuX251bWJlciI6IjU1LTAzNi01MDUiLCJhZGRlZF9hdCI6IjIwMjEtMDUtMTAgMTQ6MjA6MzQiLCJ1cGRhdGVkX2F0IjoiMjAyMS0wNS0xMCAxODowNToyOSJ9LCJpYXQiOjE2MjA3MTY0NjcsImV4cCI6MTY1MTgyMDQ2N30.Du6El-lOA3Nc2vsdoEsDT8mY8y6kkUdaFBdRprW_Ub000";
                              setState(() {});
                              //for accessing it you can call directly at any place ex- MyApp.authTokenValue. if you want to add more shared preferences add in main at 2 places and give there names in constants page

                              print(MyApp.authTokenValue);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registration()),
                                  (route) => false);
                            }
                          });
                        } catch (e) {
                          FocusScope.of(context).unfocus();
                          MyApp.showToast('Invalid otp', context);
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
