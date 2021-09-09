import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/api/reviewApi.dart';
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
  var deliveryPartnerInfo, deliveryReview;
  String payMethod;

  @override
  void initState() {
    super.initState();
    // print(widget.orderInfo);
    getOrderInfo();
  }

  getOrderInfo() async {
    var resp = await orderHandler.getOrderInfo(this.widget.orderId);
    // print(resp);
    products = resp[1]['products'];
    packs = resp[1]['packs'];
    deliveryPartnerInfo = resp[1]['delivery_partner'];
    deliveryReview = resp[1]['delivery_review'];
    print("DELIVERY REVIEW: ${resp[1]['delivery_review']}");
    print("DELIVERY PARTNER: ${resp[1]['delivery_partner']}");
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
                                    textType: "title-light"),
                              ],
                            ),
                            TextButton(
                              child:
                                  TextWidget("${widget.orderInfo['schedule_time']}", textType: "title",),
                              onPressed: null,
                            )
                          ],
                        ),
                      ),
                      deliveryPartnerInfo == null || deliveryPartnerInfo.isEmpty
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget("Order Status: ", textType: "title-light"),
                                  TextWidget(
                                      "${widget.orderInfo['order_status']}",
                                      textType: "title"),
                                ],
                              ),
                          )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          width: size.width * 0.2,
                                          height: size.width * 0.2,
                                          child: Image.network(
                                              deliveryPartnerInfo['photo'])),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                                "${deliveryPartnerInfo['name']}",
                                                textType: "title"),
                                            TextWidget(
                                                "Delivery Status: ${widget.orderInfo['delivery_status']}",
                                                textType: "title"),
                                            (widget.orderInfo[
                                                            'delivery_status'] ==
                                                        "DELIVERED" &&
                                                    deliveryReview.isEmpty)
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                        child: Text(
                                                            "Write a Review",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        onTap: () async {
                                                          await showRatingDialogue(
                                                              deliveryPartnerInfo[
                                                                  'uid'],
                                                              deliveryPartnerInfo[
                                                                  'name']);
                                                        }),
                                                  )
                                                : Row(
                                                    children: [
                                                      Icon(Icons.star_outlined),
                                                      Text(
                                                          "${deliveryReview['rating']}")
                                                    ],
                                                  )
                                          ],
                                        ),
                                      ),
                                    ),
                                    (widget.orderInfo['delivery_status'] !=
                                            "DELIVERED")
                                        ? GestureDetector(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  width: size.width * 0.05,
                                                  height: size.width * 0.05,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                  child: Icon(Icons
                                                      .phone_in_talk_outlined)),
                                            ),
                                            onTap: () async {})
                                        : SizedBox()
                                  ],
                                ),
                              ))),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget("Selected Payment Method: ",
                                  textType: "title-light"),
                              TextWidget(
                                  payMethod ??
                                      "${widget.orderInfo['payment_method']}",
                                  textType: "title"),
                            ]),
                      ),
                      SizedBox(height: 20),
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

  Future<void> showRatingDialogue(String deliveryId, String name) async {
    int rating = 0;
    Size size = MediaQuery.of(context).size;
    TextEditingController reviewController = new TextEditingController();
    List ratingDescription = [
      "Rate your Delivery",
      "Very Poor",
      "Poor",
      "Satisfactory",
      "Good",
      "Excellent"
    ];
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              Widget activeStar = Icon(Icons.star_rate_rounded,
                  color: Constants.successColor, size: 35);
              Widget inactiveStar = Icon(Icons.star_rate_outlined,
                  color: Constants.successColor, size: 35);
              return AlertDialog(
                  title: Text("Review for $name",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  actions: [
                    PrimaryCustomButton(
                      title: "Submit",
                      onPressed: () async {
                        ReviewApiHandler reviewHandler = new ReviewApiHandler();
                        Map<String, dynamic> data = {
                          "to": widget.orderInfo['delivery_person_id'],
                          "rating": rating,
                          "review": reviewController.text,
                          "order_id": widget.orderId
                        };
                        print("SENDING DATA: $data");
                        List resp = await reviewHandler.writeReview(data);
                        Navigator.pop(context);
                        MyApp.showToast("${resp[1]['message']}", context);
                      },
                    )
                  ],
                  content: Container(
                    height: 275,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: size.width,
                            child: Column(
                              children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                          child: rating >= 1
                                              ? activeStar
                                              : inactiveStar,
                                          onTap: () {
                                            setState(() {
                                              rating = 1;
                                            });
                                          }),
                                      GestureDetector(
                                          child: rating >= 2
                                              ? activeStar
                                              : inactiveStar,
                                          onTap: () {
                                            setState(() {
                                              rating = 2;
                                            });
                                          }),
                                      GestureDetector(
                                          child: rating >= 3
                                              ? activeStar
                                              : inactiveStar,
                                          onTap: () {
                                            setState(() {
                                              rating = 3;
                                            });
                                          }),
                                      GestureDetector(
                                          child: rating >= 4
                                              ? activeStar
                                              : inactiveStar,
                                          onTap: () {
                                            setState(() {
                                              rating = 4;
                                            });
                                          }),
                                      GestureDetector(
                                          child: rating >= 5
                                              ? activeStar
                                              : inactiveStar,
                                          onTap: () {
                                            setState(() {
                                              rating = 5;
                                            });
                                          }),
                                    ]),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("${ratingDescription[rating]}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Write a Review"),
                        ),
                        TextField(
                          maxLines: 5,
                          controller: reviewController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
              // return Container(
              //     color: Colors.white,
              //     child: Column(
              //       children: [
              //         Text("Review for $name",
              //             style: TextStyle(
              //                 fontSize: 18, fontWeight: FontWeight.bold))
              //       ],
              //     ));
            },
          );
        });
  }
}
