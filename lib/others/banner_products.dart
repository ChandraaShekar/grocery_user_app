import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/text_widget.dart';

class BannerProducts extends StatefulWidget {
  final Map content;
  BannerProducts({Key key, this.content}) : super(key: key);

  @override
  _BannerProductsState createState() => _BannerProductsState();
}

class _BannerProductsState extends State<BannerProducts> {
  List items;
  List<int> quantities;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    ProductApiHandler productHandler = new ProductApiHandler();
    List resp = await productHandler
        .getBannerProducts({"products": "${widget.content['content']}"});
    print(resp[1]);
    items = resp[1];
    quantities = List.filled(items.length, 0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: Header.appBar("${widget.content['banner_name']}", null, true),
        body: (items == null)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, x) {
                      // if (MyApp.cartList['products'] != null) {
                      //   int y = MyApp.cartList['products'].indexWhere((elem) =>
                      //       items[x]['product_id'] == elem['product_id']);
                      //   if (y != -1) {
                      //     quantities[x] = int.parse(
                      //         "${MyApp.cartList['products'][y]['quantity']}");
                      //   }
                      // }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productId: items[x]['product_id'])));
                        },
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: (items[x]['product_images']
                                            .isNotEmpty)
                                        ? items[x]['product_images'][0]
                                                ['image_url']
                                            .toString()
                                            .replaceAll("http://", "https://")
                                        : "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: size.width / 3.4,
                                      height: 105,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.white,
                                      child: Container(
                                        width: size.width / 3.4,
                                        height: 105,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Container(
                                        height: 100,
                                        width: size.width / 1.8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              "${items[x]['product_name']}",
                                              textType: "title",
                                            ),
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8.0),
                                                  child: TextWidget(
                                                      "${items[x]['quantity']} ${items[x]['metrics']}",
                                                      textType: "label-light",),
                                                ),
                                                color: Constants.qtyBgColor),
                                            Container(
                                              child: Row(
                                                children: [
                                                  TextWidget(
                                                      "Rs. ${items[x]['price']}",
                                                      textType: "label",)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Row(children: [
                                      GestureDetector(
                                          child: Container(
                                            child: Center(
                                                child: Text("-",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                            decoration: BoxDecoration(
                                                color: Constants.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: size.width * 0.06,
                                            height: size.width * 0.06,
                                          ),
                                          onTap: () {
                                            if (quantities[x] > 0) {
                                              setState(() {
                                                quantities[x] -= 1;
                                              });
                                            }
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextWidget("${quantities[x]}",
                                            textType: "title"),
                                      ),
                                      GestureDetector(
                                          child: Container(
                                            child: Center(
                                                child: Text("+",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                            decoration: BoxDecoration(
                                                color: Constants.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            width: size.width * 0.06,
                                            height: size.width * 0.06,
                                          ),
                                          onTap: () {
                                            if (quantities[x] < 10) {
                                              setState(() {
                                                quantities[x] += 1;
                                              });
                                            }
                                          })
                                    ]),
                                    GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          color: Constants.primaryColor,
                                          child: Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        onTap: () async {
                                          if (quantities[x] > 0) {
                                            CartApiHandler cartHandler =
                                                new CartApiHandler();
                                            var resp = await cartHandler
                                                .addToCart({
                                              "product_pack_id": items[x]
                                                  ['product_id'],
                                              "quantity": "${quantities[x]}"
                                            });
                                            MyApp.showToast(
                                                resp[1]['message'], context);

                                            List getResp =
                                                await cartHandler.getCart();
                                            setState(() {
                                              MyApp.cartList = getResp[1];
                                            });
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                      );
                    }),
              ));
  }
}
