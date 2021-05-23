import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/cart/cart_list.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/notifications.dart';
import 'package:user_app/products/product_search.dart';
import 'package:user_app/products/products_home.dart';
import 'package:user_app/products/wishlist_products.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/platform.dart';

class DashboardTabs extends StatefulWidget {
  static final String tag = Constants.homeTag;
  @override
  _DashboardTabsState createState() => _DashboardTabsState();
}

class _DashboardTabsState extends State<DashboardTabs>
    with TickerProviderStateMixin {
  TabController _controller;
  List<String> headings = ['Store', 'Cart', 'Favorites', 'Profile'];
  String currentHeading = "Welcome, ${MyApp.userInfo['name']}";
  List featured, sale, banners, categories;
  @override
  void initState() {
    // currentHeading = headings[0];
    _controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header.appBar(
          '$currentHeading',
          Row(
            children: [
              IconButton(
                  icon: Icon(Ionicons.ios_search),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductSearch()));
                  }),
              IconButton(
                icon: Icon(
                  Ionicons.ios_notifications_outline,
                  size: 26,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Notifications()));
                },
              ),
            ],
          ),
          false),
      drawer: PlatformState.getDrawer(context),
      body: Container(
        child: Column(
          children: [
            Container(
              child: new TabBar(
                onTap: (x) => setState(() {
                  currentHeading = headings[x];
                }),
                controller: _controller,
                labelColor: Constants.iconColor,
                isScrollable: true,
                indicatorColor: Constants.iconColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Tab(
                      icon: Icon(
                        Entypo.shop,
                        color: Constants.iconColor,
                        size: 26,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Tab(
                      icon: Icon(
                        AntDesign.shoppingcart,
                        color: Constants.iconColor,
                        size: 26,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Tab(
                      icon: Icon(
                        AntDesign.hearto,
                        color: Constants.iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    child: Tab(
                      icon: Icon(
                        Ionicons.md_person,
                        color: Constants.iconColor,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: new TabBarView(
                      controller: _controller,
                      children: <Widget>[
                    ProductsHome(),
                    CartList(),
                    WishListProducts(),
                    Container(
                      child: Center(
                        child: Text('home'),
                      ),
                    ),
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
