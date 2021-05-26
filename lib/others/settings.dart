import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';

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
    return Scaffold(
        appBar: Header.appBar(Constants.settingsTag, null, true),
        body: SingleChildScrollView(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Text('Email'),
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
                Text('Address'),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: address,
                ),
                SizedBox(
                  height: 3,
                ),
                if (addressErr != '')
                  Text(
                    ' enter proper phone number',
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('Store Location'),
                    Expanded(
                      child: Container(),
                    ),
                    Text(
                      'Edit Location',
                      style: TextStyle(color: Constants.kButtonTextColor),
                    ),
                    Icon(Entypo.location_pin, color: Constants.kButtonTextColor)
                  ],
                ),
                SizedBox(height: 10),
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
