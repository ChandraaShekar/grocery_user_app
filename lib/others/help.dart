import 'package:flutter/material.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/url_launcher.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  String phone = "+91-8977900118";
  String email = "support@tryfrutte.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar('Help', null, true, context, false),
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
                        launchURL('tel:' + phone);
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
                        launchURL('mailto:' + email);
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
