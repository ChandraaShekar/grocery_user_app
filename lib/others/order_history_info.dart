import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/cart/order_placed.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/cart_card.dart';
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/text_widget.dart';

class OrderHistoryInfo extends StatefulWidget {
  final String orderId;
  final Map orderInfo;
  OrderHistoryInfo({Key key, this.orderId, this.orderInfo}) : super(key: key);

  @override
  _OrderHistoryInfoState createState() => _OrderHistoryInfoState();
}

class _OrderHistoryInfoState extends State<OrderHistoryInfo> {
  List orderItems = [];
  OrderApiHandler orderHandler = new OrderApiHandler();
  List products = [];
  List packs = [];
  String payMethod;

  @override
  void initState() {
    super.initState();
    // print(widget.orderInfo);
    getOrderInfo();
  }

  getOrderInfo() async {
    var resp = await orderHandler.getOrderInfo(this.widget.orderId);
    print(resp);
    products = resp[1]['products'];
    packs = resp[1]['packs'];
    setState(() {});
  }

  CameraPosition _userLocation() {
    return CameraPosition(
      target: LatLng(double.parse(widget.orderInfo['user_lat']),
          double.parse(widget.orderInfo['user_lng'])),
      zoom: 17,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Header.appBar(this.widget.orderId, null, true),
      body: SingleChildScrollView(
          child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget(" ", textType: "title"),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return CartCard(
                                hideEdit: true,
                                name: '${products[index]['product_name']}',
                                imgUrl: products[index]['image_url'] != null
                                    ? products[index]['image_url']
                                        .toString()
                                        .replaceAll("http://", "https://")
                                    : 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                                price:
                                    '${products[index]['offer_price'] != '0' ? products[index]['offer_price'] : products[index]['price']}',
                                qty:
                                    '${products[index]['quantity']} ${products[index]['metrics']}',
                                cartQuantity: products[index]['cartQuantity'],
                                productId: products[index]['product_pack_id'],
                                onDelete: null);
                          }),
                      (packs.length > 0)
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: packs.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                var jData = jsonDecode(packs[0]['pack_data']);
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return StatefulBuilder(
                                              builder: (_, setState) {
                                            return Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: BackdropFilter(
                                                      filter:
                                                          new ImageFilter.blur(
                                                              sigmaX: 3,
                                                              sigmaY: 3),
                                                      child: Container(
                                                          color: Color(
                                                              0x01000000))),
                                                ),
                                                Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                        });
                                  },
                                  child: CartCard(
                                    hideEdit: true,
                                    name: '${packs[index]['pack_name']}',
                                    imgUrl: packs[index]['pack_banner'] != null
                                        ? packs[index]['pack_banner']
                                            .toString()
                                            .replaceAll("http://", "https://")
                                        : 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                                    price: '${jData['PackPrice']}',
                                    cartQuantity: packs[index]['quantity'],
                                    productId: packs[index]['product_id'],
                                  ),
                                );
                              })
                          : SizedBox(),
                      SizedBox(height: 20),
                      (widget.orderInfo['coupon_valid'] != "true")
                          ? SizedBox()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                width: size.width + 20,
                                height: size.height * 0.1,
                                decoration: BoxDecoration(
                                    color: Colors.indigo[50],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget("Offers", textType: "title"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextWidget(
                                              (widget.orderInfo[
                                                          'applied_coupon'] ==
                                                      'true')
                                                  ? "'${widget.orderInfo['coupon_code']}' Applied"
                                                  : "Coupon not applied",
                                              textType: "para",
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.22,
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
                                        'Sub Total',
                                        textType: "para",
                                      ),
                                      TextWidget(
                                        '₹ ' +
                                            widget.orderInfo['subtotal']
                                                .toString(),
                                        textType: "para-bold",
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        'Delivery',
                                        textType: "para",
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      TextWidget(
                                        '₹ ' +
                                            widget.orderInfo['delivery_price']
                                                .toString(),
                                        textType: "para-bold",
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        'Service Tax',
                                        textType: "para",
                                      ),
                                      TextWidget(
                                        '₹ ' +
                                            widget.orderInfo['tax'].toString(),
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
                                      (widget.orderInfo[
                                                  'price_after_discount'] !=
                                              '0')
                                          ? Column(
                                              children: [
                                                Text(
                                                  "₹ ${widget.orderInfo['total_price']}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                                Text(
                                                  "₹ ${widget.orderInfo['price_after_discount']}",
                                                  style: TextStyle(
                                                      color: Constants
                                                          .successColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            )
                                          : Text(
                                              '₹ ' +
                                                  widget
                                                      .orderInfo['total_price']
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Constants
                                                      .headingTextBlack,
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
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value:
                                        widget.orderInfo['scheduled_order'] ==
                                            'true',
                                    onChanged: null),
                                TextWidget("Schedule Delivery: ",
                                    textType: "title"),
                              ],
                            ),
                            TextButton(
                              child:
                                  Text("${widget.orderInfo['schedule_time']}"),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: TextWidget("Address: ", textType: "title-light"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextWidget("${widget.orderInfo['user_address']}",
                            textType: "title"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: size.height * 0.2,
                            child: GoogleMap(
                              zoomControlsEnabled: false,
                              markers: <Marker>{
                                Marker(
                                  markerId: MarkerId('UserPin'),
                                  position: LatLng(MyApp.lat, MyApp.lng),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange),
                                )
                              },
                              initialCameraPosition: _userLocation(),
                            )),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: TextWidget("Contact Information: ",
                            textType: "title-light"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextWidget(
                            "Name: ${MyApp.userInfo['name']} \nPhone: ${MyApp.userInfo['phone_no']} \n",
                            textType: "title"),
                      ),
                      Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 8.0),
                              child: TextWidget("Selected Payment Method: ",
                                  textType: "title-light"),
                            ),
                            Container(
                                width: size.width * 0.4,
                                child: TextWidget(
                                    payMethod ??
                                        "${widget.orderInfo['payment_method']}",
                                    textType: "para"))
                          ]),
                      (widget.orderInfo['payment_method'] == 'Pay Online' &&
                              (widget.orderInfo['payment_status'] ==
                                      'PAYMENT PENDING' ||
                                  widget.orderInfo['payment_status'] ==
                                      'PAYMENT FAILED'))
                          ? Center(
                              child: PrimaryCustomButton(
                                  title: "Change Payment Method",
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: TextWidget(
                                                "Change payment method to Cash on Delivery?",
                                                textType: "title"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No")),
                                              TextButton(
                                                  onPressed: () {
                                                    OrderApiHandler
                                                        orderHandler =
                                                        new OrderApiHandler();
                                                    orderHandler
                                                        .updatePaymentMethod(
                                                            "${widget.orderInfo['order_id']}")
                                                        .then((val) {
                                                      if (val[0] == 200) {
                                                        payMethod =
                                                            'Cash On Delivery';
                                                        setState(() {});

                                                        Navigator.pop(context);
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) => OrderStatus(
                                                                    orderSuccess:
                                                                        true,
                                                                    orderId: widget
                                                                        .orderId)));
                                                      } else {
                                                        MyApp.showToast(
                                                            "Failed to Update",
                                                            context);
                                                      }
                                                    });
                                                  },
                                                  child: Text("Yes"))
                                            ],
                                          );
                                        }).then((_) {
                                      getOrderInfo();
                                    });
                                  },
                                  width: size.width * 0.7),
                            )
                          : SizedBox()
                    ],
                  )),
            ),
            SizedBox(height: 30)
          ],
        ),
      )),
    );
  }
}
