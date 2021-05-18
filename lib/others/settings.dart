import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

TextEditingController name,email,phone;
   String nameErr='',emailErr='',phoneErr='';

   @override
  void initState() {
     super.initState();
    name=TextEditingController();
    email=TextEditingController();
    phone=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar(Constants.settingsTag,null,true),
      body:SingleChildScrollView(
        child:Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,10,20,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                     Text('Full Name'),
                     TextFormField(
                       controller: name,
                     ),
                     SizedBox(height: 3,),
                     if(nameErr!='')
                       Text(' *Required',style: TextStyle(color: Colors.red),),
                     SizedBox(height:18),
                     Text('Email'),
                     TextFormField(
                       controller: email,
                     ),
                     SizedBox(height: 3,),
                     if(emailErr!='')
                       Text(' enter proper email id',style: TextStyle(color: Colors.red),),
                     SizedBox(height:18),
                      Text('Alternate Phone Number'),
                     TextFormField(
                       keyboardType: TextInputType.number,
                       controller: phone,
                     ),
                      SizedBox(height: 3,),
                     if(phoneErr!='')
                     
                       Text(' enter proper phone number',style: TextStyle(color: Colors.red),),
                     SizedBox(height:10),
                     Row(
                      children: [
                        Text('Store Location'),
                        Expanded(child: Container(),),
                        Text('Edit Location',style: TextStyle(color: Constants.kButtonTextColor),),
                        Icon(Entypo.location_pin,color: Constants.kButtonTextColor)
                       ],
                     ),

                     SizedBox(height:10),
                     PrimaryButton(
                      onPressed:(){
                     
                        
                      },
                      backgroundColor: Constants.kButtonBackgroundColor,
                      textColor: Constants.kButtonTextColor,
                      text: "SAVE CHANGES",
                       width: MediaQuery.of(context).size.width,
                    ),
                    SizedBox(height:15),

              ],
            ),
          ),
        )
      )
    );
  }
}