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
  final String page;
  DashboardTabs({this.page});
  @override
  _DashboardTabsState createState() => _DashboardTabsState();
}

class _DashboardTabsState extends State<DashboardTabs>
    with TickerProviderStateMixin {
  TabController _controller;
  List<String> headings = ['Store', 'Cart', 'Favorites'];
  String currentHeading = "Welcome, ${MyApp.userInfo['name']}";
  List featured, sale, banners, categories;
  int cartCount = 0;
  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    if (widget.page == 'cart') {
      _controller.animateTo(1);
    }
    super.initState();
  }

  loadCartCount() {
    setState(() {
      cartCount = MyApp.cartList.isNotEmpty
          ? (MyApp.cartList['products'].length + MyApp.cartList['packs'].length)
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    loadCartCount();
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
              // IconButton(
              //   icon: Icon(
              //     Ionicons.ios_notifications_outline,
              //     size: 26,
              //   ),
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Notifications()));
              //   },
              // ),
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
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Tab(
                      icon: Icon(
                        Entypo.shop,
                        color: Constants.iconColor,
                        size: size.height / 32,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Feather.shopping_cart,
                            color: Constants.iconColor,
                            size: size.height / 35,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.primaryColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 5.0),
                                  child: Text("$cartCount",
                                      style: TextStyle(color: Colors.white)),
                                )),
                          )
                        ],
                      ),
                      // icon: ,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Tab(
                      icon: Icon(
                        AntDesign.hearto,
                        color: Constants.iconColor,
                        size: size.height / 35,
                      ),
                    ),
                  ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width * 0.15,
                  //   child: Tab(
                  //     icon: Icon(
                  //       Ionicons.md_person,
                  //       color: Constants.iconColor,
                  //       size: size.height / 30,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  child: new TabBarView(
                      controller: _controller,
                      children: <Widget>[
                    ProductsHome(),
                    CartList(
                      onCountChange: (x) => setState(() {
                        cartCount = x;
                      }),
                    ),
                    WishListProducts(),
                    // Container(
                    //   child: Center(
                    //     child: Text('home'),
                    //   ),
                    // ),
                  ])),
            )
          ],
        ),
      ),
    );
  }
}
