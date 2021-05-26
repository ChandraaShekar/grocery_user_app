import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/auth/login.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/platform.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String loginIdValue;
  static String authTokenValue;
  static Map userInfo;
  static List wishListIds = [];
  static List cartList = [];

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

  Future<Map> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    WishlistApiHandler wishlistHandler = new WishlistApiHandler();
    CartApiHandler cartHandler = new CartApiHandler();
    loginIdValue = preferences.getString(Constants.loginId);
    authTokenValue = preferences.getString(Constants.authTokenValue);
    var uinfo = preferences.getString(Constants.userInfo) ?? "{}";
    userInfo = jsonDecode(uinfo) ?? {};
    List wishListResp = await wishlistHandler.getWishlistIds();
    List cartListResp = await cartHandler.getCart();
    if (wishListResp[0] == 200) {
      wishListIds = wishListResp[1];
    }
    if (cartListResp[0] == 200) {
      cartList = cartListResp[1];
    }
    print(cartList);
    return userInfo;
  }

  final routes = <String, WidgetBuilder>{
    Platform.tag: (BuildContext context) => Platform(),
    DashboardTabs.tag: (BuildContext context) => DashboardTabs(),
    Login.tag: (BuildContext context) => Login()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Constants.primaryColor,
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.transparent),
          primaryColor: Constants.kMain,
          hintColor: Color(0xfff2f4f5),
          textTheme:
              GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)),
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
