import 'package:flutter/material.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/url_launcher.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  String phone = "+91-9890987889";
  String phone2 = "+91-9890987889";
  String email = "app@mail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar('Help', null, true),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Text(
                "Got any Queries ?",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Call us at ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        launchURL(phone);
                      },
                      child: Text(
                        phone,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.blue),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "or",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                phone2,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.blue),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Email to - ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        launchURL(email);
                      },
                      child: Text(
                        email,
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Colors.blue),
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
