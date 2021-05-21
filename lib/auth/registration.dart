import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController name, email, pincode;
  String nameErr = '', emailErr = '', pincodeErr = '';

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    pincode = TextEditingController();
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
                          ' *Required',
                          style: TextStyle(color: Colors.red),
                        ),
                      SizedBox(height: 35),
                      PrimaryButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardTabs()));
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
