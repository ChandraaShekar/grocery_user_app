import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:geolocator/geolocator.dart';

class UserLocationOnMap extends StatefulWidget {
  final Map<String, double> location;
  UserLocationOnMap({Key key, this.location}) : super(key: key);

  @override
  _UserLocationOnMapState createState() => _UserLocationOnMapState(location);
}

class _UserLocationOnMapState extends State<UserLocationOnMap> {
  final Map<String, double> location;
  Completer<GoogleMapController> _controller = Completer();
  LatLng currentPos;

  _UserLocationOnMapState(this.location);
  CameraPosition _hyderabadLocation;

  @override
  void initState() {
    _hyderabadLocation = getCameraData();
    if (MyApp.lat == null || MyApp.lng == null) {
      setState(() {
        MyApp.lat = 0.0;
        MyApp.lng = 0.0;
      });
    }
    print("MY SELECTED LOCATION: ${MyApp.lat}, ${MyApp.lng}");
    _determinePosition();
    super.initState();
  }

  CameraPosition getCameraData() {
    return CameraPosition(
      target: LatLng(17.4350, 78.4267),
      zoom: 15,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar("Pick Store Location", null, true),
      body: Stack(
        children: [
          Container(
            child: GoogleMap(
              padding: EdgeInsets.symmetric(vertical: 100),
              markers: {
                Marker(
                  markerId: MarkerId('UserPin'),
                  position: currentPos == null
                      ? LatLng(MyApp.lat, MyApp.lng)
                      : currentPos,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange),
                )
              },
              mapType: MapType.normal,
              initialCameraPosition: _hyderabadLocation,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (vals) {
                print(vals);
                _determinePosition().then((val) {
                  print("CURRENT POSITION: $val");
                });
                setState(() {
                  currentPos = vals;
                });
              },
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.05,
            left: MediaQuery.of(context).size.width * 0.125,
            child: TextButton(
                child: Text(
                  "SAVE",
                  style: TextStyle(
                      fontSize: 16, color: Constants.kButtonTextColor),
                ),
                onPressed: () async {
                  if (currentPos != null) {
                    location['latitude'] = currentPos.latitude;
                    location['longitude'] = currentPos.longitude;

                    MyApp.showToast("Selected Location", context);
                  }
                  Navigator.of(context).pop((location == null) ? {} : location);
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith((states) =>
                        Size(MediaQuery.of(context).size.width * 0.75, 42.0)),
                    elevation:
                        MaterialStateProperty.resolveWith((states) => 10),
                    shadowColor: MaterialStateColor.resolveWith(
                        (states) => Constants.kButtonBackgroundColor),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Constants.kButtonBackgroundColor))),
          ),
        ],
      ),
    );
  }
}
