import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/auth/login.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/explore_packs.dart';
import 'package:user_app/others/help.dart';
import 'package:user_app/others/order_history.dart';
import 'package:user_app/others/refer.dart';
import 'package:user_app/others/tandc.dart';
import 'package:user_app/others/settings.dart';
import 'package:user_app/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:user_app/widgets/text_widget.dart';

enum PAGE_INDEX {
  DASHBOARD,
}

class Platform extends StatefulWidget {
  static final String tag = Constants.platformTag;
  @override
  PlatformState createState() => PlatformState();
}

class PlatformState extends State<Platform> {
  PAGE_INDEX currentPage = PAGE_INDEX.DASHBOARD;

  static Widget getDrawer(BuildContext context) {
    // String authToken;
    // AccessMemory storage = AccessMemory();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.pop(context),
          ),
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TextWidget('Tryfrutte', textType: "heading"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: ListView(
            children: <Widget>[
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      Feather.home,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.homeTag, textType: "title"),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      MaterialCommunityIcons.newspaper_variant_outline,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title:
                      TextWidget(Constants.orderHistoryTag, textType: "title"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderHistory()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      FontAwesome5.smile_wink,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title:
                      TextWidget(Constants.explorePacksTag, textType: "title"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExplorePacks()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      Icons.settings,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.settingsTag, textType: "title"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      AntDesign.warning,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.tncTag, textType: "title"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TandC()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      Entypo.help,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.helpTag, textType: "title"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Help()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      Feather.gift,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.referTag, textType: "title"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Refer()));
                  }),
              Divider(
                color: Colors.transparent,
              ),
              ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Constants.drawerBgColor,
                    child: Icon(
                      SimpleLineIcons.logout,
                      color: Constants.drawerIconColor,
                    ),
                  ),
                  title: TextWidget(Constants.logoutTag, textType: "title"),
                  onTap: () {
                    MyApp.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.tag, (Route<dynamic> route) => false);
                  }),
              Divider(
                color: Colors.transparent,
              ),
              Center(
                  child:
                      TextWidget('Version : 1.0', textType: "subtitle-grey")),
              Divider(
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Dashboard();
    return Container();
  }
}
