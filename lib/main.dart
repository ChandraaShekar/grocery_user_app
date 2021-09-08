import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user_app/api/addressApi.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/auth/login.dart';
import 'package:user_app/cart/address_search_map.dart';
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
  static String displayAddress;
  static Map userInfo;
  static List wishListIds = [];
  static List addresses = [];
  static Map cartList = {};
  static Map homePage = {};
  static int selectedAddressId = 0;
  static double lat, lng;
  static IO.Socket socket;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

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
    addresses.clear();
    sharedPreferences.clear();
    FirebaseAuth.instance.signOut();
  }

  static socketIOHandler() {
    socket = IO.io('https://socket.8bitchaps.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => {print("SOCKET CONNECTED")});
    socket.onConnectError((data) => print("SOCKET STATUS: $data"));
  }

  static Future<Map> isLoggedIn() async {
    socketIOHandler();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    WishlistApiHandler wishlistHandler = new WishlistApiHandler();
    loginIdValue = preferences.getString(Constants.loginId);
    authTokenValue = preferences.getString(Constants.authTokenValue);
    var uinfo = preferences.getString(Constants.userInfo) ?? "{}";
    userInfo = jsonDecode(uinfo) ?? {};
    selectedAddressId = await getDefaultAddress();
    loadAddresses();
    reloadCart();
    displayAddress =
        addresses[selectedAddressId == -1 ? 0 : selectedAddressId]['address'];
    lat = double.parse(addresses[MyApp.selectedAddressId]['lat']);
    lng = double.parse(addresses[MyApp.selectedAddressId]['lng']);
    loadHomePage(lat, lng).then((val) => print("HOMEPAGE LOADED $homePage"));
    messaging
        .subscribeToTopic(userInfo['uid'])
        .then((value) => print("SUBBSCRIBED TO ${userInfo['uid']}"));
    List wishListResp = await wishlistHandler.getWishlistIds();
    if (wishListResp[0] == 200) {
      wishListIds = wishListResp[1];
    }
    log("$userInfo");
    return userInfo;
  }

  final routes = <String, WidgetBuilder>{
    Platform.tag: (BuildContext context) => Platform(),
    DashboardTabs.tag: (BuildContext context) => DashboardTabs(),
    Login.tag: (BuildContext context) => Login()
  };

  static Future<bool> setDefaultAddress(int addressId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    MyApp.selectedAddressId = addressId;
    MyApp.lat = double.parse(MyApp.addresses[MyApp.selectedAddressId]['lat']);
    MyApp.lng = double.parse(MyApp.addresses[MyApp.selectedAddressId]['lng']);
    loadHomePage(lat, lng);
    return await sharedPreferences.setInt(
        Constants.currentAddressId, addressId);
  }

  static Future<int> getDefaultAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    selectedAddressId = sharedPreferences.getInt(Constants.currentAddressId);
    if (selectedAddressId == null) {
      setDefaultAddress(0);
      return 0;
    } else {
      print("selected Address: $selectedAddressId");
      return selectedAddressId;
    }
  }

  static Future<Map> loadHomePage(latx, lngy) async {
    ProductApiHandler productHandler =
        new ProductApiHandler(body: {"lat": latx, "lng": lngy});
    var response = await productHandler.getHomeProducts();
    MyApp.homePage = response[1];
    MyApp.loadAddresses();
    return response[1];
  }

  static Future<Map> reloadCart() async {
    cartList.clear();
    CartApiHandler cartHandler = new CartApiHandler();
    List cartListResp = await cartHandler.getCart();
    if (cartListResp[0] == 200) {
      cartList['products'] = cartListResp[1]['products'];
      cartList['packs'] = cartListResp[1]['packs'];
    }
    return cartList;
  }

  static loadAddresses() async {
    print("Loding address");
    AddressApiHandler addressApiHandler = AddressApiHandler();
    List resp = await addressApiHandler.getAddresses();
    selectedAddressId = await getDefaultAddress();
    MyApp.addresses = resp[1];
    MyApp.lat = double.parse(resp[1][MyApp.selectedAddressId]['lat']);
    MyApp.lng = double.parse(resp[1][MyApp.selectedAddressId]['lng']);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    isLoggedIn().then((val) => print("USER INFO: $val"));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Constants.primaryColor,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          primaryColor: Constants.kMain,
          scaffoldBackgroundColor: Color(0xffFFFFFF),
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
                      userInfo == null) {
                    print("${snapshot.data} |||| $userInfo");
                    return Login();
                  } else if (snapshot.data.isNotEmpty &&
                      userInfo['account_status'] == 'ACTIVE') {
                    return addresses == null || addresses.length == 0
                        ? AddressSearchMap(
                            onSave: DashboardTabs(),
                          )
                        : DashboardTabs();
                  } else {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                }
            }
          }),
      routes: routes,
    );
  }
}
