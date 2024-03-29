import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/packsApi.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/counter.dart';
import 'package:user_app/widgets/pack_desc_card.dart';
import 'package:user_app/widgets/text_widget.dart';

class PackageDescription extends StatefulWidget {
  final String packId, packName;

  PackageDescription({this.packId, this.packName});

  @override
  _PackageDescriptionState createState() => _PackageDescriptionState();
}

class _PackageDescriptionState extends State<PackageDescription> {
  PacksApiHandler packsHandler = new PacksApiHandler();
  CartApiHandler cartHandler = new CartApiHandler();
  Map packInfo;
  List packProducts = [];
  bool loading = true;
  double orginalPrice = 0.0,
      packPrice = 0.0,
      tax = 0.0,
      totalPrice = 0.0,
      discount = 0.0,
      orginalFixedPrice = 0.0,
      packFixedPrice = 0.0;
  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    List resp = await packsHandler.getPackInfo(widget.packId);
    List resp2 = await cartHandler.getDeliveryPrice();
    // print(resp);
    if (resp[0] == 200 && resp2[0] == 200) {
      packInfo = resp[1];
      packProducts = resp[1]['products'];
      log("$packProducts");
      packProducts.forEach((element) {
        orginalPrice += double.parse(element['price']) *
            int.parse(element['item_pack_quantity']);
      });
      orginalFixedPrice = orginalPrice;
      packPrice = double.parse(packInfo['pack_info']['pack_offer_price']);
      packFixedPrice = packPrice;
      tax = (packPrice * double.parse(resp2[1][0]['tax_percentage'])).toInt() /
          100;
      totalPrice = packPrice + tax;
      discount = packPrice / orginalPrice;
      if (orginalFixedPrice > 0) {
        loading = false;
      }
    }
    setState(() {});
  }

  void calculateNewPrice() async {
    orginalPrice = 0;
    packProducts.forEach((element) {
      orginalPrice += double.parse(element['price']) *
          int.parse(element['item_pack_quantity']);
    });
    double offerLimit = double.parse(packInfo['pack_info']['limit_for_offer']);
    log("OFFER LIMIT $offerLimit");
    if (orginalPrice < offerLimit) {
      print("LESS THAN LIMIT");
      packPrice = orginalPrice;
    } else {
      packPrice =
          ((packFixedPrice / orginalFixedPrice) * orginalPrice * 100).toInt() /
              100;
    }
    tax = (packPrice * 5).toInt() / 100;
    totalPrice = ((packPrice + tax) * 100).toInt() / 100;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Header.appBar(widget.packName, null, true, context, true),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : packProducts.length > 0
              ? packInfo == null
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                          child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Ionicons.md_paper,
                              color: Constants.packDescIconColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Here’s what you get in the ' +
                                  widget.packName.toLowerCase() +
                                  "!",
                              style: TextStyle(
                                  color: Constants.packDescHeadingColor,
                                  fontSize: size.height / 58,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        packInfo['pack_info']['pack_description'] != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Expandable(
                                  primaryWidget: TextWidget("Pack Information",
                                      textType: "title"),
                                  elevation: 2,
                                  padding: EdgeInsets.all(10.0),
                                  animationDuration:
                                      Duration(milliseconds: 200),
                                  secondaryWidget: HtmlWidget(
                                      packInfo['pack_info']
                                          ['pack_description']),
                                  // Text(
                                  //   packInfo['pack_info']['pack_description'],
                                  //   maxLines: 3,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                  showArrowIcon: true,
                                  hoverOn: false,
                                  arrowLocation: ArrowLocation.right,
                                ),

                                // ExpandableText(
                                //   packInfo['pack_info']['pack_description'],
                                //   expandText: "show more",
                                //   collapseText: "hide",
                                //   maxLines: 1,
                                // ),
                              )
                            : SizedBox(),
                        (packInfo == null)
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: packProducts.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _productInfo(packProducts[index]);
                                    },
                                    child: PackDescCard(
                                      imgUrl:
                                          '${packProducts[index]['image_url']}'
                                              .replaceAll(
                                                  'http://', 'https://'),
                                      // onPressed: () {
                                      //   _displayTextInputDialog(context);
                                      // },
                                      name:
                                          '${packProducts[index]['product_name']}',
                                      qty:
                                          '${packProducts[index]['quantity']} ${packProducts[index]['metrics']}',
                                      itemCount: packProducts[index]
                                          ['item_pack_quantity'],
                                    ),
                                  );
                                }),
                        SizedBox(
                          height: 5,
                        ),
                        packInfo['pack_info']['pack_description'] == null ||
                                packInfo['pack_info']['pack_description'] == ""
                            ? SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                    child: Text(
                                        "Note: You can get an offer of ${(100 - ((packPrice / orginalPrice) * 100)).toStringAsFixed(2)}% on this pack only if the original price of this pack is greater than ${packInfo['pack_info']['limit_for_offer']}/-",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.height / 60,
                                          fontWeight: FontWeight.w600,
                                          color: Constants.packDescHeadingColor,
                                        ))),
                              ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Container(
                            height: size.height / 4.55,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          'Orginal Price',
                                          textType: "para",
                                        ),
                                        TextWidget(
                                          '₹ ' + orginalPrice.toString(),
                                          textType: "para-bold",
                                        )
                                      ]),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          'Pack Price',
                                          textType: "para",
                                        ),
                                        TextWidget(
                                          '₹ ' + packPrice.toString(),
                                          textType: "para-bold",
                                        )
                                      ]),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          'Tax',
                                          textType: "para",
                                        ),
                                        TextWidget(
                                          '₹ ' + tax.toString(),
                                          textType: "para-bold",
                                        )
                                      ]),
                                ),
                                Divider(),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextWidget(
                                          'Total',
                                          textType: "para-bold",
                                        ),
                                        Text(
                                          '₹ ' + totalPrice.toString(),
                                          style: TextStyle(
                                              color: Constants.headingTextBlack,
                                              letterSpacing: 0.5,
                                              fontSize: size.height / 45,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        PrimaryButton(
                          text: "Add to Cart",
                          backgroundColor: Constants.primaryColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            Map packCart = {};
                            packProducts.forEach((val) => {
                                  val.removeWhere((key, value) =>
                                      key == "product_description")
                                });
                            packCart['OriginalPrice'] = orginalPrice;
                            packCart['PackPrice'] = packPrice;
                            packCart['products'] = packProducts;

                            String jsonPackData = jsonEncode(packCart);
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                });

                            var resp = await cartHandler.addToCart({
                              'product_pack_id': packInfo['pack_info']
                                  ['pack_id'],
                              'itemType': 'pack',
                              'quantity': '1',
                              'pack_data': jsonPackData
                            });
                            if (resp[0] == 200) {
                              Navigator.pop(context);
                              MyApp.showToast(resp[1]['message'], context);
                              List getResp = await cartHandler.getCart();
                              setState(() {
                                MyApp.cartList = getResp[1];
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DashboardTabs(
                                            page: 'cart',
                                          )));
                            }
                            print(resp);
                          },
                        ),
                        SizedBox(height: size.height * 0.1)
                      ])),
                    )
              : Center(
                  child: TextWidget(
                    'This pack is empty',
                    textType: "para-bold",
                  ),
                ),
    );
  }

  void itemCountChanged(newCount, productId) async {
    var itemIndex = packProducts
        .indexWhere((element) => element['product_id'] == productId);
    packProducts[itemIndex]['item_pack_quantity'] = newCount.toString();
    calculateNewPrice();
    setState(() {});
  }

  void deleteFromList(productInfo) {
    print(productInfo);
    var index = packProducts.indexWhere(
        (element) => element['product_id'] == productInfo['product_id']);
    setState(() {
      packProducts.removeAt(index);
    });
    calculateNewPrice();
  }

  // TextEditingController _textFieldController = TextEditingController();

  Future<void> _productInfo(Map productInfo) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: productInfo['image_url']
                                            .toString()
                                            .replaceAll('http://', 'https://'),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 100,
                                          height: 100,
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
                                              height: 100, color: Colors.white),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.55,
                                              child: TextWidget(
                                                  productInfo['product_name'],
                                                  textType: "subheading"),
                                            ),
                                            SizedBox(height: 15),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Constants.qtyBgColor,
                                                  borderRadius:
                                                      BorderRadius.circular(3)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: TextWidget(
                                                    "${productInfo['quantity']} ${productInfo['metrics']}",
                                                    textType: "title"),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ])),
                              Divider(
                                color: Colors.grey[900],
                              ),
                              Row(children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    child: TextWidget("Price: ",
                                        textType: "subheading")),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text("${productInfo['price']}/-",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough)),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 5.0),
                                    child: TextWidget(
                                        "${(((this.packPrice / this.orginalPrice) * double.parse(productInfo['price']) * 100) / 100).toStringAsFixed(2)}/-",
                                        textType: "subheading")),
                                Expanded(child: Container()),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: CounterBtn(
                                      incDecheight: 25.0,
                                      incDecwidth: 25.0,
                                      text: productInfo['item_pack_quantity'],
                                      decPressed: () {
                                        var currentQuantity = int.parse(
                                            productInfo['item_pack_quantity']);
                                        if (currentQuantity > 1) {
                                          itemCountChanged(currentQuantity - 1,
                                              productInfo['product_id']);
                                          setState(() {});
                                        }
                                      },
                                      incPressed: () {
                                        var currentQuantity = int.parse(
                                            productInfo['item_pack_quantity']);
                                        if (currentQuantity < 10) {
                                          itemCountChanged(currentQuantity + 1,
                                              productInfo['product_id']);
                                          setState(() {});
                                        }
                                      }),
                                )
                              ]),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: TextWidget("Description",
                                    textType: "subtitle-grey"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                child: HtmlWidget(
                                  "${productInfo['product_description']}",
                                ),
                              )
                            ]),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                            onPressed: () {
                              print("HELLO");
                              deleteFromList(productInfo);
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.delete_forever,
                                color: Constants.dangerColor)),
                      ),
                    ],
                  ),
                ));
          });
        });
  }
}
