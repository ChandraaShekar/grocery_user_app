import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/api/addressApi.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:user_app/api/registerapi.dart';
// import 'package:user_app/cart/payments.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/text_widget.dart';

class AddressSearchMap extends StatefulWidget {
  final Widget onSave;
  AddressSearchMap({key, this.onSave}) : super(key: key);

  @override
  _AddressSearchMapState createState() => _AddressSearchMapState();
}

class _AddressSearchMapState extends State<AddressSearchMap> {
  double latitude = MyApp.lat;
  double longitude = MyApp.lng;
  String myAddress = "";
  GoogleMapController mapController;
  AddressApiHandler addressApiHandler = AddressApiHandler();
  TextEditingController addressType = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController landMark = new TextEditingController();
  List addressTypes = ["Home", "Work", "Other"];

  @override
  void initState() {
    addressType.text = (MyApp.addresses.length == 0 || MyApp.addresses == null)
        ? addressTypes[0]
        : (MyApp.addresses.length == 1)
            ? addressTypes[1]
            : addressTypes[2];
    super.initState();
  }

  Future<List> getFromAddress(String address) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${Constants.mapApiKey}&components=country:IN|locality:hyderabad";

    var resp = await http.get(url);
    print(resp.body);
    return jsonDecode(resp.body)["results"];
    // if (resp.statusCode == 200) {}
  }

  getFromCoords(lat, lng) async {
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Constants.mapApiKey}";
    var resp = await http.get(url);
    var data = jsonDecode(resp.body);
    // data["results"][0]['address_components'].forEach((val) => setState(() {
    //       myAddress = val['formatted_address'];
    //     }));
    print(data["results"][0]['geometry']);
    setState(() {
      myAddress = data["results"][0]['formatted_address'];
      address.text = myAddress;
    });

    // print(data["results"][0]['address_components']);
  }

  onLocationChange(LatLng newPosition) {
    setState(() {
      latitude = newPosition.latitude;
      longitude = newPosition.longitude;
    });
    FocusScope.of(context).unfocus();
    getFromCoords(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Header.appBar('Pick your location', null, true),
        body: Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: size.height * 0.75,
                  child: GoogleMap(
                      onMapCreated: (_controller) {
                        mapController = _controller;
                      },
                      myLocationButtonEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(MyApp.lat, MyApp.lng), zoom: 14),
                      markers: {
                        Marker(
                          markerId: MarkerId("398233"),
                          position: LatLng(latitude, longitude),
                        )
                      },
                      onTap: onLocationChange),
                ),
                Expanded(
                  child: Container(
                    height: size.height * 0.14,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: TextWidget("$myAddress",
                                        textType: "title"))
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Container(
                              // padding: EdgeInsets.all(12),
                              height: size.height * 0.08,
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                  color: Constants.primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 10,
                                    top: size.height * 0.025,
                                    child: Text("Select",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: size.height * 0.01,
                                    child: Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        size: 50,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              showModalBottomSheet(
                                  isDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return SingleChildScrollView(
                                        child: Container(
                                            height: size.height * 0.5,
                                            padding: EdgeInsets.all(15.0),
                                            color: Colors.white,
                                            child: Column(children: [
                                              TextWidget("Enter Landmark",
                                                  textType: "heading"),
                                              TextField(
                                                  controller: addressType,
                                                  decoration: InputDecoration(
                                                      labelText: "Address Type",
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Colors.black))),
                                              TextField(
                                                  controller: address,
                                                  decoration: InputDecoration(
                                                      labelText: "Address",
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Colors.black))),
                                              TextField(
                                                  controller: landMark,
                                                  decoration: InputDecoration(
                                                      labelText: "Landmark",
                                                      labelStyle: TextStyle(
                                                          color:
                                                              Colors.black))),
                                              SizedBox(height: 20),
                                              PrimaryCustomButton(
                                                  title: "Save",
                                                  onPressed: () async {
                                                    var resp =
                                                        await addressApiHandler
                                                            .addAddress({
                                                      "address_name":
                                                          addressType.text,
                                                      "address": address.text,
                                                      "lat": latitude,
                                                      "lng": longitude,
                                                      "landmark": landMark.text
                                                    });

                                                    MyApp.showToast(
                                                        resp[1]['message'],
                                                        context);
                                                    if (resp[0] == 200) {
                                                      MyApp.setDefaultAddress(
                                                          MyApp.addresses
                                                              .length);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  widget
                                                                      .onSave));
                                                    }
                                                  })
                                            ])),
                                      );
                                    });
                                  });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 30,
              left: size.width * 0.85 * 0.1,
              child: Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x66898989),
                            offset: Offset.zero,
                            blurRadius: 15,
                            spreadRadius: 10)
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: size.width * 0.85,
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          autofocus: true,
                          style: TextStyle(fontSize: 15.0),
                          decoration: InputDecoration(
                              hintText: "Search your address...",
                              hintStyle: TextStyle(color: Color(0xFF000000)),
                              // helperText: "Search your address...",
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none)),
                      suggestionsCallback: (pattern) async {
                        print(pattern);
                        return await getFromAddress(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                            title: Text(suggestion['formatted_address']));
                      },
                      onSuggestionSelected: (suggestion) {
                        myAddress = suggestion['formatted_address'];
                        onLocationChange(LatLng(
                            suggestion['geometry']['location']['lat'],
                            suggestion['geometry']['location']['lng']));
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: LatLng(
                                    suggestion['geometry']['location']['lat'],
                                    suggestion['geometry']['location']['lng']),
                                zoom: 20.0),
                          ),
                        );
                        setState(() {});
                        print(suggestion['geometry']);
                      },
                    )),
              ),
            )
          ],
        ));
  }
}
