import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/registerapi.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/auth/login.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/platform.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notification',
    'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A BG MSGL ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String loginIdValue;
  static String authTokenValue;
  static Map userInfo;
  static List wishListIds = [];
  static Map cartList = {};
  static double lat, lng;
  static IO.Socket socket;

  static showToast(String msg, BuildContext context) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  static logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    loginIdValue = "";
    authTokenValue = "";
    userInfo.clear();
    wishListIds.clear();
    cartList.clear();
    sharedPreferences.clear();
    FirebaseAuth.instance.signOut();
  }

  socketIOHandler() {
    socket = IO.io('https://socket.8bitchaps.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    print(socket.connected);
    socket.connect();
    socket.onConnect((data) => {print("SOCKET CONNECTED")});
    socket.onConnectError((data) => print("SOCKET STATUS: $data"));
    // socket.on('message', (data) {
    //   print("SOCKET MESSAGE: $data");
    // });
  }

  Future<Map> isLoggedIn() async {
    socketIOHandler();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    WishlistApiHandler wishlistHandler = new WishlistApiHandler();
    reloadCart();
    loginIdValue = preferences.getString(Constants.loginId);
    authTokenValue = preferences.getString(Constants.authTokenValue);
    var uinfo = preferences.getString(Constants.userInfo) ?? "{}";
    userInfo = jsonDecode(uinfo) ?? {};
    if (userInfo.isNotEmpty) {
      try {
        lat = double.parse(userInfo['user_lat']);
        lng = double.parse(userInfo['user_lng']);
      } catch (exception) {
        lat = null;
        lng = null;
      }
    }
    List wishListResp = await wishlistHandler.getWishlistIds();
    if (wishListResp[0] == 200) {
      wishListIds = wishListResp[1];
    }
    // print(userInfo);
    return userInfo;
  }

  final routes = <String, WidgetBuilder>{
    Platform.tag: (BuildContext context) => Platform(),
    DashboardTabs.tag: (BuildContext context) => DashboardTabs(),
    Login.tag: (BuildContext context) => Login()
  };

  static Future<Map> reloadCart() async {
    // print("AUTHTOKEN: $authTokenValue");
    cartList.clear();
    CartApiHandler cartHandler = new CartApiHandler();
    List cartListResp = await cartHandler.getCart();
    if (cartListResp[0] == 200) {
      cartList['products'] = cartListResp[1]['products'];
      cartList['packs'] = cartListResp[1]['packs'];
    }
    return cartList;
  }

  static Future<bool> updateUserLocation(double lat, double lng) async {
    RegisterApiHandler updateHandler =
        new RegisterApiHandler({"user_lat": lat, "user_lng": lng});
    var resp = await updateHandler.updateLocation();
    // print("UPDATE RESP: ${resp[1]}");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        Constants.userInfo, jsonEncode(resp[1]['user']));
    MyApp.userInfo = resp[1]['user'];

    sharedPreferences.setString(
        Constants.authTokenValue, jsonEncode(resp[1]['access_token']));
    MyApp.authTokenValue = resp[1]['access_token'];
    if (resp[0] == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Constants.primaryColor,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          primaryColor: Constants.kMain,
          scaffoldBackgroundColor: Color(0xffF9F9F9),
          hintColor: Color(0xfff2f4f5),
          textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme)),
      home: new FutureBuilder(
          future: isLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                {
                  return Scaffold(
                    body: Container(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Image.asset(
                              Constants.splashScreen,
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        )),
                  );
                }
              default:
                {
                  if (snapshot.hasError ||
                      snapshot.data.isEmpty ||
                      userInfo == null)
                    return Login();
                  else if (snapshot.data.isNotEmpty &&
                      userInfo['account_status'] == 'ACTIVE')
                    return DashboardTabs();
                  else
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                }
            }
          }),
      routes: routes,
    );
  }
}
