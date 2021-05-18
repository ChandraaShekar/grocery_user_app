import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:user_app/auth/registration.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';

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
 // FirebaseAuth auth = FirebaseAuth.instance;
  String verfId;

  @override
  void initState() {
  // _load();
    super.initState();
  }

  // void _load()async{
    
  //  await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+91${widget.phoneNumber}',
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await FirebaseAuth.instance
  //             .signInWithCredential(credential)
  //             .then((value) async {
  //           if (value.user != null) {
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => Registration()),
  //                 (route) => false);
  //           }
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         print(e.message);
  //       },
  //       codeSent: (String verficationID, int resendToken) {
  //         setState(() {
  //           verfId = verficationID;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationID) {
  //         setState(() {
  //           verfId = verificationID;
  //         });
  //       },
  //       timeout: Duration(seconds: 120));
  // }
  String scode='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text("Verify your number",style: TextStyle(fontWeight: FontWeight.w400),),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
         child: Container(
          child: Column(
            children: [
              SizedBox(height:20),
               Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                       Text("6 digit code sent to ",style: TextStyle(color: Colors.black54),),
                      Text('+91 '+widget.phoneNumber,style: TextStyle(color: Colors.blue),),
                    ],
                 ),
              SizedBox(height:8),
       OtpTextField(
            numberOfFields: 6,
            enabledBorderColor:Colors.grey,
            focusedBorderColor:Constants.kMain,
            showFieldAsBox: false, //set to true to show as box or false to show as dash
            onCodeChanged: (String code) {
                //handle validation or checks here           
            },
            onSubmit: (String verificationCode){
             scode=verificationCode;
             setState(() {});
            }, // end onSubmit
          ),
                SizedBox(height:8),
           Padding(
             padding: const EdgeInsets.all(25.0),
             child: PrimaryButton(
                                backgroundColor: Constants.kButtonBackgroundColor,
                                textColor: Constants.kButtonTextColor,
                                text: "VERIFY",
                                width: MediaQuery.of(context).size.width,
                                onPressed: () async{

                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Registration()),
                          );



                //             if(scode.length<6){
                //                 MyApp.showToast('Enter valid otp', context);
                //             }else if(verfId==null){
                //                 MyApp.showToast('wait for few seconds', context);
                //             }
                //             else if(verfId!=null){
                //                      try {
                //   await FirebaseAuth.instance
                //       .signInWithCredential(PhoneAuthProvider.credential(
                //           verificationId: verfId, smsCode: scode))
                //       .then((value) async {
                //     if (value.user != null) {
                     
                //       Navigator.pushAndRemoveUntil(
                //           context,
                //           MaterialPageRoute(builder: (context) => Registration()),
                //           (route) => false);
                //     }
                //   });
                // } catch (e) {
                //   FocusScope.of(context).unfocus();
                //   MyApp.showToast('Invalid otp', context);
                // }
                //             }
                                
                                },
                                ),
           ),

              ],
            ),
          ),
      )
    );
  }

}