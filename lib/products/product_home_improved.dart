import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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

class HomePageProducts extends StatefulWidget {
  final Map homepageData;
  HomePageProducts({key, this.homepageData}) : super(key: key);

  @override
  _HomePageProductsState createState() => _HomePageProductsState();
}

class _HomePageProductsState extends State<HomePageProducts> {
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

  void loadData() async {
    // print("DEFAULT: ${widget.homepageData['banners']}");
    productsArround = int.parse(widget.homepageData['products_arround'] ?? "0");
    featured = widget.homepageData['featured'];
    sale = widget.homepageData['sale'];
    bestDeals = widget.homepageData['best_deals'];
    frutteChoice = widget.homepageData['frutte_choice'];
    topOffers = widget.homepageData['top_offers'];
    categories = widget.homepageData['categories'];
    banners = widget.homepageData['banners'];
    promoBanners = widget.homepageData['promotional_banners'];
    small_1 = promoBanners[0];
    small_2 = promoBanners[1];
    small_3 = promoBanners[2];
    small_4 = promoBanners[3];
    large_1 = promoBanners[4];
    large_2 = promoBanners[5];
    large_3 = promoBanners[6];
    large_4 = promoBanners[7];
  }

  @override
  Widget build(BuildContext context) {
    loadData();
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height * 0.2),
                          Container(
                            height: size.height * 0.4,
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Image.asset(Constants.locationNotFountImage),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 10),
                            child: Center(
                              child: TextWidget(
                                "We are currently not operating in your location. Hold tight, we are expanding quick.",
                                textType: "subheading",
                              ),
                            ),
                          ),
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
                                      child:
                                          (banners == null ||
                                                  banners.length == 0)
                                              ? Container(
                                                  width: size.width,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      child: Image.asset(
                                                          Constants
                                                              .comingSoonImage,
                                                          fit: BoxFit.fill)))
                                              : CarouselSlider(
                                                  options: CarouselOptions(
                                                    viewportFraction: 1,
                                                    autoPlay: true,
                                                    enableInfiniteScroll: false,
                                                    autoPlayInterval:
                                                        Duration(seconds: 6),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                                                    initialPage: 0,
                                                    height: 150,

                                                    onPageChanged:
                                                        (index, reason) {
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
                                                                  builder:
                                                                      (context) =>
                                                                          PackageDescription(
                                                                            packId:
                                                                                banners[index]['pack_id'],
                                                                            packName:
                                                                                banners[index]['pack_name'],
                                                                          )));
                                                        },
                                                        child: Container(
                                                            width: size.width,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                        imageUrl: banners[index]['pack_banner'].toString().replaceAll(
                                                                            'http://',
                                                                            'https://'),
                                                                        imageBuilder: (context,
                                                                                imageProvider) =>
                                                                            Container(
                                                                              height: 100,
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(
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
                                      CategoryGrid(
                                          categoriesList: categories,
                                          totalLength: categories.length),
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
                                        (small_1 != null &&
                                                small_1['status'] == 'active')
                                            ? smallCard(small_1)
                                            : SizedBox(),
                                        (small_2 != null &&
                                                small_2['status'] == 'active')
                                            ? smallCard(small_2)
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  (sale.length > 0)
                                      ? productList("Sale", "sale", sale)
                                      : SizedBox(),
                                  (large_1 != null &&
                                          large_1['status'] == 'active')
                                      ? bigCard(large_1)
                                      : SizedBox(),
                                  (frutteChoice.length > 0)
                                      ? productList("Frutte's Choice",
                                          "frutte_choice", frutteChoice)
                                      : SizedBox(),
                                  (large_2 != null &&
                                          large_2['status'] == 'active')
                                      ? bigCard(large_2)
                                      : SizedBox(),
                                  (bestDeals.length > 0)
                                      ? productList(
                                          "best_deals", "Best Deals", bestDeals)
                                      : SizedBox(),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (small_3 != null &&
                                                small_3['status'] == 'active')
                                            ? smallCard(small_3)
                                            : SizedBox(),
                                        (small_4 != null &&
                                                small_4['status'] == 'active')
                                            ? smallCard(small_4)
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                  (topOffers.length > 0)
                                      ? productList(
                                          "Top Offers", "top_offers", topOffers)
                                      : SizedBox(),
                                  (large_3 != null &&
                                          large_3['status'] == 'active')
                                      ? bigCard(large_3)
                                      : SizedBox(),
                                  (large_4 != null &&
                                          large_4['status'] == 'active')
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
                fit: BoxFit.contain,
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
                  fit: BoxFit.contain,
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
