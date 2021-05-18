
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/cart/payments.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
class CheckoutAddress extends StatefulWidget {
  @override
  _CheckoutAddressState createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress> with TickerProviderStateMixin {
 
 TextEditingController street1,street2,city,landmark,state;
   String street1Err='',cityErr='',landmarkErr='',stateErr='';
 
  AnimationController animationController;
  Animation  p1, d2;
  
  void initState() {
    super.initState();
     street1=TextEditingController();
     street2=TextEditingController();
     city=TextEditingController();
     landmark=TextEditingController();
     state=TextEditingController();

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this,);
    
    p1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5,0.6)));
    d2 = ColorTween(begin: Colors.white, end: Constants.buttonBgColor).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6,0.8, curve: Curves.linear)));
    
    animationController.forward();
  }

@override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = 16.0;
    return Scaffold(
      appBar: Header.appBar('Checkout', null, true),
      body: SingleChildScrollView(
        child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) =>
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.5, color: Constants.buttonBgColor)),
                          width: dotSize + 12,
                          height: dotSize + 12,
                          child: Center(
                            child: Container(
                                width: dotSize,
                                height: dotSize,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        dotSize / 2),
                                    color: Constants.buttonBgColor)),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width *
                                  0.3,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                value: p1.value,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Constants.buttonBgColor),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.5, color: Colors.grey)),
                          width: dotSize + 12,
                          height: dotSize + 12,
                          child: Center(
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      dotSize / 2),
                                  color: d2.value),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Container(
                              height: 3,
                              width: MediaQuery.of(context).size.width *
                                  0.3,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.5, color: Colors.grey)),
                          width: dotSize + 12,
                          height: dotSize + 12,
                          child: Center(
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      dotSize / 2),
                                  color: Colors.grey),
                            ),
                          ),
                        ),
                        
                      ])),
                      Padding(
                        padding: const EdgeInsets.only(left:12.0,right: 8.0,top: 4,),
                        child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Text('Items'),
                           Expanded(child: Container()),
                           Text('Address'),
                           Expanded(child: Container()),
                           Text('Payment')
                         ],
                        ),
                      ),
                     SizedBox(height: 10,),
                   Padding(
                     padding: const EdgeInsets.fromLTRB(14, 25, 0, 20),
                     child: Row(
                       children: [
                         Icon(AntDesign.checkcircle,color: Constants.buttonBgColor,),
                         SizedBox(width:8),
                         Text('Save as Default Address')
                       ],
                     ),
                   ),

                     Padding(
                       padding: const EdgeInsets.all(15.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children:[
                           Text('Street 1'),
                       TextFormField(
                         controller: street1,
                       ),
                       SizedBox(height: 3,),
                       if(street1Err!='')
                         Text(' *Required',style: TextStyle(color: Colors.red),),
                       SizedBox(height:18),
                       Text('Street 2'),
                       TextFormField(
                         controller: street2,
                       ),
                       SizedBox(height:21),
                        Text('City'),
                       TextFormField(
                         keyboardType: TextInputType.number,
                         controller: city,
                       ),
                        SizedBox(height: 3,),
                       if(cityErr!='')                   
                         Text(' *Required',style: TextStyle(color: Colors.red),),
                       SizedBox(height:18),
                       Text('Landmark'),
                       TextFormField(
                         controller: landmark,
                       ),
                       SizedBox(height: 3,),
                       if(landmarkErr!='')
                         Text(' *Required',style: TextStyle(color: Colors.red),),
                       SizedBox(height:18),
                       Text('State'),
                       TextFormField(
                         controller: state,
                       ),
                       SizedBox(height: 3,),
                       if(stateErr!='')
                         Text(' *Required',style: TextStyle(color: Colors.red),),
                       SizedBox(height:30),
                       Center(
                         child: PrimaryButton(
                        onPressed:(){
                       
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>Payments()));
                        },
                        backgroundColor: Constants.kButtonBackgroundColor,
                        textColor: Constants.kButtonTextColor,
                        width: MediaQuery.of(context).size.width*0.5,
                        text: "CONTINUE",
                        
                    ),
                       ),
                    SizedBox(height:15),
                         ]
                       ),
                     )




                ],
              ),
            )
    ),
      ),
    );
  }
}

