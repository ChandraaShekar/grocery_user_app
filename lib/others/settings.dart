import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/others/userLocationOnMap.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/text_widget.dart';

import '../main.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController name, email, address;
  String nameErr = '', emailErr = '', addressErr = '';
  Map<String, double> location = {};

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: MyApp.userInfo['name']);
    email = TextEditingController(text: MyApp.userInfo['email']);
    address = TextEditingController(text: MyApp.userInfo['address']);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: Header.appBar(Constants.settingsTag, null, true),
        body: SingleChildScrollView(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  'Full Name',
                  textType: "label",
                ),
                TextFormField(
                  style: TextStyle(fontSize: size.height / 50),
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
                TextWidget(
                  'Email',
                  textType: "label",
                ),
                TextFormField(
                  style: TextStyle(fontSize: size.height / 50),
                  controller: email,
                ),
                SizedBox(
                  height: 3,
                ),
                if (emailErr != '')
                  Text(
                    ' Enter proper email id',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 18),
                TextWidget(
                  'Address',
                  textType: "label",
                ),
                TextFormField(
                  style: TextStyle(fontSize: size.height / 50),
                  keyboardType: TextInputType.text,
                  controller: address,
                ),
                SizedBox(
                  height: 3,
                ),
                if (addressErr != '')
                  Text(
                    ' Enter proper phone number',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 18),
                Row(
                  children: [
                    TextWidget(
                      'Your Location',
                      textType: "label",
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    TextButton(
                      onPressed: () {
                        print("Button Pressed");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UserLocationOnMap()));
                      },
                      child: Row(
                        children: [
                          Text(
                            'Edit Location',
                            style: TextStyle(
                                color: Constants.kButtonTextColor,
                                fontSize: size.height / 60,
                                fontWeight: FontWeight.w600),
                          ),
                          Icon(Entypo.location_pin,
                              color: Constants.kButtonTextColor)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                PrimaryButton(
                  onPressed: () async {
                    Map<String, dynamic> data = {
                      "name": name.text,
                      "user_lat": location['latitude'],
                      "user_lng": location['longitude'],
                      "email": email.text,
                      "address": address.text
                    };

                    RegisterApiHandler updateHandler = RegisterApiHandler(data);
                    List resp = await updateHandler.update();
                    if (resp[0] == 200) {
                      FocusScope.of(context).unfocus();
                      MyApp.userInfo = resp[1]['user'];
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          Constants.userInfo, jsonEncode(resp[1]['user']));
                      MyApp.authTokenValue = resp[1]['access_token'];
                      sharedPreferences.setString(
                          Constants.authTokenValue, resp[1]['access_token']);
                      MyApp.showToast(resp[1]['message'], context);
                    }
                  },
                  backgroundColor: Constants.kButtonBackgroundColor,
                  textColor: Constants.kButtonTextColor,
                  text: "SAVE CHANGES",
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        )));
  }
}
