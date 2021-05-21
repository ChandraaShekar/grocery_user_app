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
          child: Container(
        // color: Constants.kDrawerBackground,
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: ListView(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                    'Grocery Shopping',
                    style: Constants.header,
                  ))),
                ],
              ),
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
                  title: Text(
                    Constants.homeTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.orderHistoryTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.explorePacksTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.settingsTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.tncTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.helpTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.referTag,
                    style: Constants.sideHeading,
                  ),
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
                  title: Text(
                    Constants.logoutTag,
                    style: Constants.sideHeading,
                  ),
                  onTap: () {
                    MyApp.logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.tag, (Route<dynamic> route) => false);
                  }),
              Divider(
                color: Colors.transparent,
              ),
              Center(
                  child: Text(
                'Version : 1.0',
                style: Constants.headerX,
              )),
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
