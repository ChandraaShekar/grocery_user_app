import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/widgets/text_widget.dart';

import '../main.dart';

class ProductList extends StatefulWidget {
  final String title;
  final String type;
  final String categoryId;
  ProductList({
    Key key,
    this.title,
    this.type,
    this.categoryId,
  }) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List productList;
  CartApiHandler cartHandler = new CartApiHandler();
  List<int> quantities;
  List<bool> quantitiesLoading;
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    ProductApiHandler productHandler = new ProductApiHandler(body: {
      "lat": "${MyApp.lat}",
      "lng": "${MyApp.lng}",
      "type": "${widget.type}"
    });
    if (widget.type.isNotEmpty) {
      if (widget.type != "category") {
        List resp = await productHandler.getSpecialProducts();
        print("SPECIAL RESPONSE: $resp");
        if (resp[0] == 200) {
          setState(() {
            productList = resp[1];
          });
        }
      } else {
        List resp = await productHandler.getCategoryProducts(widget.categoryId);
        print("category response $resp");
        if (resp[0] == 200) {
          setState(() {
            productList = resp[1];
          });
        }
      }
    } else {
      setState(() {
        productList = [];
      });
    }
    quantities = List.filled(productList.length, 0);
    quantitiesLoading = List.filled(productList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Header.appBar(
          widget.title ?? "Product List", null, true, context, true),
      body: SingleChildScrollView(
        child: Container(
          height: size.height * 0.9,
          child: productList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: productList.length + 1,
                  itemBuilder: (_, i) {
                    if (i == productList.length) {
                      return Container(
                        height: size.height * 0.1,
                        child: Center(
                            child: TextWidget("No more products",
                                textType: "title")),
                      );
                    } else {
                      int y = MyApp.cartList['products'].indexWhere((elem) =>
                          elem['product_id'] ==
                          productList[i]['product_info'][0]['product_id']);
                      if (y != -1) {
                        quantities[i] = int.parse(
                            "${MyApp.cartList['products'][y]['cartQuantity']}");
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productId: productList[i]['product_info']
                                          [0]['product_id'])));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          child: CachedNetworkImage(
                                            imageUrl: (productList[i]
                                                        ['product_images']
                                                    .isNotEmpty)
                                                ? productList[i]
                                                            ['product_images']
                                                        [0]['image_url']
                                                    .toString()
                                                    .replaceAll(
                                                        "http://", "https://")
                                                : "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: size.width / 3.4,
                                              height: 105,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Container(
                                            height: 100,
                                            width: size.width / 1.8,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  child: TextWidget(
                                                    "${productList[i]['product_info'][0]['product_name']}",
                                                    textType: "title",
                                                  ),
                                                ),
                                                Container(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5.0,
                                                          horizontal: 8.0),
                                                      child: TextWidget(
                                                        "${productList[i]['product_info'][0]['quantity']} ${productList[i]['product_info'][0]['metrics']}",
                                                        textType: "label-grey",
                                                      ),
                                                    ),
                                                    color:
                                                        Constants.qtyBgColor),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      TextWidget(
                                                        "Rs. ${productList[i]['product_info'][0]['price']}",
                                                        textType: "label",
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
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
                                          (y != -1)
                                              ? Row(children: [
                                                  GestureDetector(
                                                      child: Container(
                                                        child: Center(
                                                            child: TextWidget(
                                                          "-",
                                                          textType:
                                                              "label-white",
                                                        )),
                                                        decoration: BoxDecoration(
                                                            color: Constants
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        width:
                                                            size.width * 0.08,
                                                        height:
                                                            size.width * 0.08,
                                                      ),
                                                      onTap: () async {
                                                        if (quantities[i] > 0) {
                                                          setState(() {
                                                            quantities[i] -= 1;
                                                            MyApp.cartList['products']
                                                                        [y][
                                                                    'cartQuantity'] =
                                                                quantities[i];
                                                          });
                                                          if (quantities[i] ==
                                                              0) {
                                                            List resp = await cartHandler
                                                                .deleteFromCart(
                                                                    MyApp.cartList[
                                                                            'products'][y]
                                                                        [
                                                                        'product_id']);
                                                            MyApp.showToast(
                                                                resp[1]
                                                                    ['message'],
                                                                context);
                                                            if (resp[0] ==
                                                                200) {
                                                              MyApp.cartList[
                                                                      'products']
                                                                  .removeAt(i);
                                                            }
                                                          } else {
                                                            List resp =
                                                                await cartHandler
                                                                    .updateCart({
                                                              "product_pack_id":
                                                                  MyApp.cartList[
                                                                          'products'][y]
                                                                      [
                                                                      'product_id'],
                                                              "quantity":
                                                                  quantities[i]
                                                            });
                                                            if (resp[0] ==
                                                                200) {
                                                              MyApp.cartList['products']
                                                                          [y][
                                                                      'cartQuantity'] =
                                                                  quantities[i];
                                                            } else {
                                                              quantities[i] +=
                                                                  1;
                                                              MyApp.showToast(
                                                                  resp[1][
                                                                      'message'],
                                                                  context);
                                                            }
                                                          }

                                                          setState(() {});
                                                        }
                                                      }),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: (quantitiesLoading[
                                                            i])
                                                        ? Image.asset(
                                                            Constants
                                                                .loadingImage,
                                                            width: size.width *
                                                                0.06)
                                                        : TextWidget(
                                                            "${MyApp.cartList['products'][y]['cartQuantity']}",
                                                            textType: "title"),
                                                  ),
                                                  GestureDetector(
                                                      child: Container(
                                                        child: Center(
                                                            child: TextWidget(
                                                          "+",
                                                          textType:
                                                              "label-white",
                                                        )),
                                                        decoration: BoxDecoration(
                                                            color: Constants
                                                                .primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        width:
                                                            size.width * 0.08,
                                                        height:
                                                            size.width * 0.08,
                                                      ),
                                                      onTap: () async {
                                                        setState(() {
                                                          quantities[i] += 1;
                                                          MyApp.cartList['products']
                                                                      [y][
                                                                  'cartQuantity'] =
                                                              quantities[i];
                                                        });
                                                        if (quantities[i] <
                                                            10) {
                                                          List resp =
                                                              await cartHandler
                                                                  .updateCart({
                                                            "product_pack_id": MyApp
                                                                        .cartList[
                                                                    'products'][
                                                                y]['product_id'],
                                                            "quantity":
                                                                quantities[i]
                                                          });
                                                          if (resp[0] == 200) {
                                                            MyApp.cartList['products']
                                                                        [y][
                                                                    'cartQuantity'] =
                                                                quantities[i];
                                                          } else {
                                                            quantities[i] -= 1;
                                                            MyApp.cartList['products']
                                                                        [y][
                                                                    'cartQuantity'] =
                                                                quantities[i];
                                                            MyApp.showToast(
                                                                resp[1]
                                                                    ['message'],
                                                                context);
                                                          }
                                                          setState(() {
                                                            // quantitiesLoading[
                                                            //     x] = false;
                                                          });
                                                        }
                                                      })
                                                ])
                                              : SizedBox(),
                                          (y == -1)
                                              ? GestureDetector(
                                                  child: Container(
                                                    padding: EdgeInsets.all(10),
                                                    color:
                                                        (quantitiesLoading[i])
                                                            ? Colors.white
                                                            : Constants
                                                                .primaryColor,
                                                    child: (quantitiesLoading[
                                                            i])
                                                        ? Image.asset(
                                                            Constants
                                                                .loadingImage,
                                                            width: size.width *
                                                                0.1)
                                                        : TextWidget(
                                                            'Add to Cart',
                                                            textType:
                                                                "label-white",
                                                          ),
                                                  ),
                                                  onTap: () async {
                                                    setState(() {
                                                      quantitiesLoading[i] =
                                                          true;
                                                    });
                                                    var resp = await cartHandler
                                                        .addToCart({
                                                      "product_pack_id":
                                                          productList[i][
                                                                  'product_info']
                                                              [0]['product_id'],
                                                      "quantity": "1"
                                                    });
                                                    MyApp.showToast(
                                                        resp[1]['message'],
                                                        context);
                                                    if (resp[0] == 200) {
                                                      List getResp =
                                                          await cartHandler
                                                              .getCart();
                                                      MyApp.cartList =
                                                          getResp[1];
                                                    }
                                                    setState(() {
                                                      quantitiesLoading[i] =
                                                          false;
                                                    });
                                                  })
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }
                  }),
        ),
      ),
    );
  }
}
