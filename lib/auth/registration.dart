import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';

import '../main.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController name, email, pincode;
  String nameErr = '', emailErr = '', pincodeErr = '';
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    name = new TextEditingController();
    email = new TextEditingController();
    pincode = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                      backgroundColor: Constants.dangerColor,
                      child: Icon(Icons.check, color: Colors.white)),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                        fontSize: size.height / 40,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Your mobile number verified successfully!',
                style: TextStyle(
                    fontSize: size.height / 66, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Constants.secondaryTextColor,
                thickness: 0.1,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'One Last Step',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text('Full Name'),
                      TextFormField(
                        controller: name,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      if (nameErr != '')
                        Text(
                          ' *Required',
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 18),
                      Text('Email(optional)'),
                      TextFormField(
                        controller: email,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      if (emailErr != '')
                        Text(
                          ' enter proper email id',
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 18),
                      Text('Pincode'),
                      TextFormField(
                        controller: pincode,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      if (pincodeErr != '')
                        Text(
                          pincodeErr,
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 35),
                      PrimaryButton(
                        onPressed: () async {
                          bool validated=true;
                          if(name.text.toString()==''){
                            nameErr='error';
                            validated=false;
                          }else{
                            nameErr='';
                          }
                          if(pincode.text.toString()==''){
                            pincodeErr=' *Required';
                            validated=false;
                          }else{
                            pincodeErr='';
                          }
                          if(pincode.text.toString().length<6){
                            pincodeErr=' enter proper pincode';
                            validated=false;
                          }else{
                            pincodeErr='';
                          }
                          setState(() {});
                          if(validated){
                            final User user = auth.currentUser;
                          String authToken = await user.getIdToken(true);
                          var data = {
                            'auth_token': authToken,
                            'name': name.text,
                            'address': "NONE",
                            'user_lat': "NONE",
                            'user_lng': "NONE",
                            'pincode': pincode.text,
                            'phone_no': user.phoneNumber,
                            'email': email.text!=null?email.text:''
                          };
                          RegisterApiHandler registerHandler =
                              new RegisterApiHandler(data);
                          var response = await registerHandler.register();
                          MyApp.showToast(response[1]['message'], context);
                          if (response[0] == 200) {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(Constants.userInfo,
                                jsonEncode(response[1]['user']));
                            MyApp.userInfo = response[1]['user'];

                            sharedPreferences.setString(
                                Constants.authTokenValue,
                                jsonEncode(response[1]['access_token']));
                            MyApp.authTokenValue = response[1]['access_token'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashboardTabs()));
                          }
                          // else if (response[0] == 400) {

                          // } else if (response[0] == 400) {
                          // }
                          else {
                            print(response);
                          }
                          }
                        },
                        backgroundColor: Constants.kButtonBackgroundColor,
                        textColor: Constants.kButtonTextColor,
                        text: "CONTINUE SHOPPING",
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(height: 15),
                    ]),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
