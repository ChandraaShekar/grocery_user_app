import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/banner_content.dart';
import 'package:user_app/others/banner_products.dart';
import 'package:user_app/others/pack_desc.dart';
import 'package:user_app/products/big_product_card.dart';
import 'package:user_app/products/category_details.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/products/product_list.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/CategoryGrid.dart';
import 'package:user_app/widgets/text_widget.dart';

class ProductsHome extends StatefulWidget {
  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  bool down = true;
  List featured,
      sale,
      bestDeals,
      frutteChoice,
      topOffers,
      categories,
      banners,
      promoBanners;
  int productsArround;
  Map small_1,
      small_2,
      small_3,
      small_4,
      large_1,
      large_2,
      large_3,
      large_4,
      large_5;
  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    if (MyApp.lat == null || MyApp.lng == null) {
      showLocationDialog();
    } else {
      loadData();
    }
    super.initState();
  }

  void loadData() async {
    ProductApiHandler productHandler =
        new ProductApiHandler(body: {"lat": MyApp.lat, "lng": MyApp.lng});
    var response = await productHandler.getHomeProducts();
    // print(response[1]);
    setState(() {
      productsArround = int.parse(response[1]['products_arround']);
      featured = response[1]['featured'];
      sale = response[1]['sale'];
      bestDeals = response[1]['best_deals'];
      frutteChoice = response[1]['frutte_choice'];
      topOffers = response[1]['top_offers'];
      categories = response[1]['categories'];
      banners = response[1]['banners'];
      promoBanners = response[1]['promotional_banners'];
      small_1 = promoBanners[0];
      small_2 = promoBanners[1];
      small_3 = promoBanners[2];
      small_4 = promoBanners[3];
      large_1 = promoBanners[4];
      large_2 = promoBanners[5];
      large_3 = promoBanners[6];
      large_4 = promoBanners[7];
    });
  }

  void showLocationDialog() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Stack(children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(color: Color(0x01000000))),
              ),
              AlertDialog(
                title: Text("Location Permission"),
                content: TextWidget(
                    "We would like to access your location inorder to show the products available in your location. Please enable the Location Access",
                    textType: "para"),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )
            ]);
          });
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return Stack(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(color: Color(0x01000000))),
                ),
                AlertDialog(
                  title: Text("Location Permission"),
                  content: TextWidget(
                      "Weneed to access your location inorder to show the products available in your location. Please enable the Location Access",
                      textType: "para"),
                  actions: [
                    TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                )
              ]);
            });
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Stack(children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(color: Color(0x01000000))),
              ),
              AlertDialog(
                title: Text("Location Permission"),
                content: TextWidget(
                    "We are unable to show you products since you have denied location permission, please turn on location permission to this app from settings.",
                    textType: "para"),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )
            ]);
          });
    }

    getUserCurrentPosition();
  }

  void getUserCurrentPosition() {
    Geolocator.getCurrentPosition().then((value) {
      MyApp.lat = value.latitude;
      MyApp.lng = value.longitude;
      loadData();
      MyApp.updateUserLocation(value.latitude, value.longitude);
    });
  }

  // Future<Position> _determinePosition() async {}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: (productsArround == null)
            ? Container(
                height: size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (productsArround == 0)
                ? Container(
                    height: size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            "We are currently not operating in your location.",
                            textType: "subheading",
                          ),
                          TextWidget("Hold tight, we are expanding quick.",
                              textType: "subheading"),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: size.height / 4.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      child: CarouselSlider(
                                          options: CarouselOptions(
                                            viewportFraction: 1,
                                            autoPlay: true,
                                            enableInfiniteScroll: false,
                                            autoPlayInterval:
                                                Duration(seconds: 6),
                                            scrollDirection: Axis.horizontal,
                                            //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                                            initialPage: 0,
                                            height: 150,

                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                _current = index;
                                              });
                                            },
                                          ),
                                          items: List.generate(
                                            banners.length,
                                            (index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PackageDescription(
                                                                packId: banners[
                                                                        index]
                                                                    ['pack_id'],
                                                                packName: banners[
                                                                        index][
                                                                    'pack_name'],
                                                              )));
                                                },
                                                child: Container(
                                                    width: size.width,
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                        child:
                                                            CachedNetworkImage(
                                                                imageUrl: banners[
                                                                            index]
                                                                        [
                                                                        'pack_banner']
                                                                    .toString()
                                                                    .replaceAll(
                                                                        'http://',
                                                                        'https://'),
                                                                imageBuilder:
                                                                    (context,
                                                                            imageProvider) =>
                                                                        Container(
                                                                          height:
                                                                              100,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        )))),
                                              );
                                            },
                                          ))),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            map<Widget>(banners, (index, url) {
                                          return _current == index
                                              ? Container(
                                                  width: 9,
                                                  height: 9,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Constants
                                                          .buttonBgColor),
                                                )
                                              : Container(
                                                  width: 9,
                                                  height: 9,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 4),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Constants
                                                              .buttonBgColor)),
                                                );
                                        })),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                          children: [
                                            TextWidget(
                                              'Categories',
                                              textType: "subheading",
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AllCatgories()));
                                              },
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                    "View all",
                                                    textType: "subheading-grey",
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Icon(
                                                    FontAwesome
                                                        .chevron_circle_right,
                                                    color: Constants
                                                        .secondaryTextColor,
                                                    size: size.height / 60,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CategoryGrid(categoriesList: categories),
                                    ],
                                  ),
                                  (featured.length > 0)
                                      ? productList(
                                          "Featured", "Featured", featured)
                                      : SizedBox(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (small_1['status'] == 'active')
                                            ? smallCard(small_1)
                                            : SizedBox(),
                                        (small_2['status'] == 'active')
                                            ? smallCard(small_2)
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  (sale.length > 0)
                                      ? productList("Sale", "sale", sale)
                                      : SizedBox(),
                                  (large_1['status'] == 'active')
                                      ? bigCard(large_1)
                                      : SizedBox(),
                                  (frutteChoice.length > 0)
                                      ? productList("Frutte's Choice",
                                          "Frutte Choice", frutteChoice)
                                      : SizedBox(),
                                  (large_2['status'] == 'active')
                                      ? bigCard(large_2)
                                      : SizedBox(),
                                  (bestDeals.length > 0)
                                      ? productList(
                                          "Best Deals", "Best Deals", bestDeals)
                                      : SizedBox(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (small_3['status'] == 'active')
                                            ? smallCard(small_3)
                                            : SizedBox(),
                                        (small_4['status'] == 'active')
                                            ? smallCard(small_4)
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  (topOffers.length > 0)
                                      ? productList(
                                          "Top Offers", "Top Offers", topOffers)
                                      : SizedBox(),
                                  (large_3['status'] == 'active')
                                      ? bigCard(large_3)
                                      : SizedBox(),
                                  (large_4['status'] == 'active')
                                      ? bigCard(large_4)
                                      : SizedBox(),
                                ],
                              )),
                              if (!down)
                                Container(
                                    height: MediaQuery.of(context).size.height +
                                        100,
                                    color: Colors.black38),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget smallCard(Map info) {
    Size size = MediaQuery.of(context).size;
    MaterialPageRoute route = new MaterialPageRoute(
        builder: (context) => (info['banner_type'] == 'content'
            ? BannerContent(content: info)
            : BannerProducts(content: info)));
    return (info['status'] == 'active')
        ? GestureDetector(
            onTap: () {
              Navigator.push(context, route);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                width: size.width * 0.44,
                 fit: BoxFit.cover,
                imageUrl: '${info['image_url']}',
              ),
            ),
          )
        : SizedBox;
  }

  Widget bigCard(Map info) {
    Size size = MediaQuery.of(context).size;
    MaterialPageRoute route = new MaterialPageRoute(
        builder: (context) => (info['banner_type'] == 'content'
            ? BannerContent(content: info)
            : BannerProducts(content: info)));
    return (info['status'] == 'active')
        ? GestureDetector(
            onTap: () {
              Navigator.push(context, route);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                width: size.width * 0.92,
                 fit: BoxFit.cover,
                imageUrl: '${info['image_url']}',
              ),
              ),
            ),
          )
        : SizedBox;
  }

  Widget productList(String title, String type, List data) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 5),
          child: Row(
            children: [
              SizedBox(width: 5),
              TextWidget(
                '$title',
                textType: "subheading",
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductList(title: "$title", type: "$type")));
                },
                child: Row(
                  children: [
                    TextWidget(
                      "View all",
                      textType: "subheading-grey",
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      FontAwesome.chevron_circle_right,
                      color: Constants.secondaryTextColor,
                      size: size.height / 60,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            height: size.width / 1.7,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length > 5 ? 5 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  var productInfo = data[index]['product_info'];
                  var productImages = data[index]['product_images'];
                  // print(productInfo);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  productId: productInfo[0]['product_id'])));
                    },
                    child: BigProductCard(
                      productInfo: productInfo,
                      productImages: productImages,
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
