import 'dart:ui';

import 'package:flutter/material.dart';

class Constants {
  static final String authTokenValue = "authTokenValue";
  static final String loginId = "LoginId";
  static final String userInfo = "userInfo";

  static final String baseUrl = "https://8bitchaps.com/gap_user/public/";

  // Images
  static final String splashScreen = "assets/images/splash.jpeg";
  static final String welcomeScreen = "assets/images/welcome.png";
  static final String moveupImage = "assets/images/move_up.png";
  static final String padImage = "assets/images/pad.png";
  static final String offerImage = "assets/images/offer1.png";
  static final String only4uImage = "assets/images/only4u.png";
  static final String beverageImage = "assets/images/beverage.png";

  static final String platformTag = "Platform";

  static final String homeTag = "Home";
  static final String orderHistoryTag = "Order History";
  static final String explorePacksTag = "Explore Packs";
  static final String paymentsTag = "Payments";
  static final String settingsTag = "Settings";
  static final String referTag = "Refer & Earn";
  static final String tncTag = "Terms & Conditions";
  static final String helpTag = "Help";
  static final String logoutTag = "Logout";
  static final String loginTag = "Login";

  //text styles
  static final header = new TextStyle(
      fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w400);

  static final header1 = new TextStyle(
    fontSize: 18.0,
    color: Colors.black,
    fontWeight: FontWeight.w800,
  );
  static final headerX = new TextStyle(
      fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w500);
  static final sideHeading2 =
      TextStyle(fontWeight: FontWeight.w600, fontSize: 18);

  static final sideHeading = new TextStyle(
      fontSize: 15.0, color: Colors.black, fontWeight: FontWeight.w500);
  //drawer color
  static const Color kMain = const Color(0xffFFD2CC);
  static final Color kMain2 = Color(0xff29C17E);

  static const Color kButtonBackgroundColor = const Color(0xffFFD2CC);
  static const Color kButtonTextColor = const Color(0xffE2374A);

  static final Color topLeftCircleColor =
      const Color(0xffFFF48F).withOpacity(0.51);
  static final Color topRightCircleColor = const Color(0xffEEE0F8);
  static final Color bottomLeftCircleColor =
      const Color(0xff82CCFB).withOpacity(0.35);
  static const Color bottomRightCircleColor = const Color(0xffEBF8EE);

  static final Color iconColor = const Color(0xffFF805D).withOpacity(0.9);

  static final Color sideHeadingColor = const Color(0xffFF805D);

  static final Color buttonBgColor = Color(0xffFB9082);

  static final Color transitBgColor = Color(0xffFFD157);
  static final Color deliveredBgColor = Color(0xff29C17E);

  static final Color wishListSelectedColor = Color(0xff29C17E);
  static final Color wishListUnSelectedColor = Colors.grey;

  static final Color qtyBgColor = Color(0xffE3E4E5);

  static final Color incDecColor = Color(0xff99A0B0);

  static final Color packDescHeadingColor = Color(0xffEE6A61);
  static final Color packDescIconColor = Color(0xffFF805D);

  static final Color drawerBgColor = Color(0xffFB9082).withOpacity(0.1);
  static final Color drawerIconColor = Color(0xffFB9082);

  static final String rupeeSymbol = '₹';
  static final Color headingTextBlack = const Color(0xff2D2D2D);
  static final Color greyHeading = const Color(0xff404040);
  static final Color secondaryTextColor = const Color(0xff707070);
  static final Color primaryColor = Color(0xffFB9082);
  static final Color secondaryColor = Color(0xff29C17E);
  static final Color warningColor = Color(0xffFFD157);
  static final Color dangerColor = Color(0xffE86775);
  static final Color infoColor = Color(0xffFB9082);
  static final Color successColor = Color(0xff29C17E);
}
