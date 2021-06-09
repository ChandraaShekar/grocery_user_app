import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/cart/address_search.dart';
import 'package:user_app/cart/payments.dart';
import 'package:user_app/cart/place_service.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/userLocationOnMap.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:uuid/uuid.dart';
import 'package:google_maps_webservice/places.dart';

class CheckoutAddress extends StatefulWidget {
  @override
  _CheckoutAddressState createState() => _CheckoutAddressState();
}

class _CheckoutAddressState extends State<CheckoutAddress>
    with TickerProviderStateMixin {
  TextEditingController address, houseNo, landmark;
  String street1Err = '', cityErr = '', landmarkErr = '', stateErr = '';
  String kGoogleApiKey = "AIzaSyD7aAMNJZf52UsZ-ohLqiO5_76YeIC5Ez0";

  void initState() {
    super.initState();
    predictions();
    address = TextEditingController(text: MyApp.userInfo['address']);
    houseNo = TextEditingController(text: MyApp.userInfo['flat_no']);
    landmark = TextEditingController(text: MyApp.userInfo['landmark']);
  }

  void predictions() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "in")]);
    print(p);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar('Checkout', null, true),
      body: SingleChildScrollView(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            Padding(
                padding: EdgeInsets.all(15.0),
                child: Center(
                  child:
                      TextWidget("Delivery Location", textType: "subheading"),
                )),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18),
                    TextField(
                      controller: address,
                      readOnly: true,
                      onTap: () async {
                        // generate a new token here
                        final sessionToken = Uuid().v4();
                        final Suggestion result = await showSearch(
                          context: context,
                          delegate: AddressSearch(sessionToken),
                        );
                        // This will change the text displayed in the TextField
                        if (result != null) {
                          final placeDetails =
                              await PlaceApiProvider(sessionToken)
                                  .getPlaceDetailFromId(result.placeId);
                          setState(() {
                            address.text = result.description;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your shipping address",
                        contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                      ),
                    ),
                    SizedBox(height: 18),
                    Text('Flat No./House No.'),
                    TextFormField(
                      controller: houseNo,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (stateErr != '')
                      Text(
                        ' *Required',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 18),
                    Text('Landmark'),
                    TextFormField(
                      controller: landmark,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (landmarkErr != '')
                      Text(
                        ' *Required',
                        style: TextStyle(color: Colors.red),
                      ),
                    SizedBox(height: 10),
                    Center(
                        child: TextButton(
                            child: Text("Pick delivery location on Map"),
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UserLocationOnMap()));

                              print(result);
                            })),
                    SizedBox(height: 30),
                    Center(
                      child: PrimaryButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          Map<String, dynamic> exportData = {
                            "address": address.text,
                            "flat_no": houseNo.text,
                            "landmark": landmark.text,
                            "user_lat": MyApp.lat,
                            "user_lng": MyApp.lng
                          };
                          print("BEFORE: $exportData");
                          RegisterApiHandler updateHandler =
                              new RegisterApiHandler(exportData);

                          List resp = await updateHandler.updateAddress();

                          print("${resp[1]}");
                          MyApp.showToast(resp[1]['message'], context);
                          if (resp[0] == 200) {
                            // NaviMyApp.showToast(response[1]['message'], context);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(Constants.userInfo,
                                jsonEncode(resp[1]['user']));
                            MyApp.userInfo = resp[1]['user'];

                            sharedPreferences.setString(
                                Constants.authTokenValue,
                                jsonEncode(resp[1]['access_token']));
                            MyApp.authTokenValue = resp[1]['access_token'];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payments()));
                          }
                        },
                        backgroundColor: Constants.kButtonBackgroundColor,
                        textColor: Constants.kButtonTextColor,
                        width: MediaQuery.of(context).size.width * 0.5,
                        text: "CONTINUE",
                      ),
                    ),
                    SizedBox(height: 15),
                  ]),
            )
          ]))),
    );
  }
}

// ----------------------------------------------------
