import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/api/addressApi.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/cart/address_search_map.dart';
import 'package:user_app/cart/cart_list.dart';
import 'package:user_app/main.dart';
import 'package:user_app/products/product_search.dart';
import 'package:user_app/products/products_home.dart';
import 'package:user_app/products/wishlist_products.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/platform.dart';
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/text_widget.dart';

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
  List featured, sale, banners, categories;
  int cartCount = MyApp.cartList.isNotEmpty
      ? (MyApp.cartList['products'].length + MyApp.cartList['packs'].length)
      : 0;
  CartApiHandler cartHandler = new CartApiHandler();
  AddressApiHandler addressApi = AddressApiHandler();
  String displayAddress = MyApp.addresses.length > 0
      ? MyApp.addresses[MyApp.selectedAddressId]['address']
      : "";
  @override
  void initState() {
    _controller = new TabController(length: 3, vsync: this);
    if (widget.page == 'cart') {
      _controller.animateTo(1);
    }
    super.initState();
    MyApp.getAddresses();
  }

  changeDisplayAddress(int i) {
    if (MyApp.addresses.length > 0) {
      MyApp.setDefaultAddress(i);
      displayAddress = MyApp.addresses[i]['address'];
      setState(() {});
    }
  }

  loadCartCount() async {
    List getResp = await cartHandler.getCart();
    MyApp.cartList = getResp[1];
    cartCount = MyApp.cartList.isNotEmpty
        ? (MyApp.cartList['products'].length + MyApp.cartList['packs'].length)
        : 0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    loadCartCount();
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: GestureDetector(
            onTap: () {
              print(MyApp.addresses);
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return Container(
                          height: size.height * 0.5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  new Expanded(
                                    child: ListView.builder(
                                        itemCount: MyApp.addresses.length,
                                        itemBuilder: (_, i) {
                                          // return Text(
                                          //     "${jsonEncode(MyApp.addresses[i])}");
                                          //       print(MyApp.addresses[i]);
                                          return ListTile(
                                              title: TextWidget("Other",
                                                  textType: "title"),
                                              subtitle: TextWidget(
                                                  MyApp.addresses[i]['address'],
                                                  textType: "para"),
                                              trailing: (MyApp
                                                          .addresses.length <=
                                                      1)
                                                  ? SizedBox()
                                                  : (MyApp.selectedAddressId ==
                                                          i)
                                                      ? SizedBox()
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons.delete,
                                                              color: Constants
                                                                  .dangerColor),
                                                          onPressed: () async {
                                                            var resp = await addressApi
                                                                .deleteAddress(
                                                                    MyApp.addresses[
                                                                            i]
                                                                        ['id']);
                                                            if (resp[0] ==
                                                                200) {
                                                              MyApp.addresses
                                                                  .removeAt(i);
                                                            }
                                                            setState(() {});
                                                          }),
                                              onTap: () {
                                                changeDisplayAddress(i);
                                                // setState(() {});
                                                Navigator.pop(context);
                                                // displayAddress =
                                                //     MyApp.addresses[MyApp
                                                //             .selectedAddressId]
                                                //         ['address'];
                                              });
                                        }),
                                  ),
                                  SizedBox(height: 5),
                                  Divider(),
                                  SizedBox(height: 5),
                                  PrimaryCustomButton(
                                      title: "Add New",
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AddressSearchMap(
                                                        onSave:
                                                            DashboardTabs())));
                                      })
                                ]),
                          ));
                    });
                  });
            },
            child: Row(children: [
              Icon(Icons.location_pin),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextWidget("$displayAddress...", textType: "title"),
              )
            ]),
          ),
          actions: [
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
              ],
            ),
          ]),
      // Header.appBar(
      //     '$currentHeading',
      //     Row(
      //       children: [
      //         IconButton(
      //             icon: Icon(Ionicons.ios_search),
      //             onPressed: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => ProductSearch()));
      //             }),
      //       ],
      //     ),
      //     false),
      drawer: PlatformState.getDrawer(context),
      body: Container(
        child: Column(
          children: [
            Container(
              child: new TabBar(
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
