import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/cart/order_placed.dart';
import 'package:user_app/cart/payment_status.dart';
import 'package:user_app/main.dart';
import 'package:user_app/others/promo_codes.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/cart_card.dart';
import 'package:user_app/widgets/pack_desc_card.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Payments extends StatefulWidget {
  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> with TickerProviderStateMixin {
  LatLng currentPos;
  CameraPosition _hyderabadLocation;
  CartApiHandler cartHandler = new CartApiHandler();
  OrderApiHandler orderHandler = new OrderApiHandler();
  double subtotal = 0;
  double delivery = 0;
  double tax = 0;
  double total = 0;
  List packs = [];
  List coupons = [];
  bool couponApplied = false;
  bool couponValid = false;
  String couponCode = "";
  double newOfferPrice = 0.0;
  bool isScheduled = false;
  DateTime selectedDate = DateTime.now();
  String paymentMethod = "Cash on Delivery";
  Razorpay _razorpay = new Razorpay();
  String orderId = "";
  void loadPrice() async {
    subtotal = 0;
    MyApp.cartList['products'].forEach((element) {
      subtotal += double.parse(element['offer_price'] != '0'
              ? element['offer_price']
              : element['price']) *
          int.parse(element['cartQuantity']);
    });
    packs = MyApp.cartList['packs'];
    packs.forEach((element) {
      var jData = jsonDecode(element['pack_data']);
      subtotal += jData['OriginalPrice'] * int.parse(element['cartQuantity']);
      print("ELEMENT: $jData");
    });
    tax = (subtotal * 5).toInt() / 100;
    total = ((subtotal + tax + delivery) * 100).toInt() / 100;
    setState(() {});
  }

  void loadCoupons() async {
    var resp = await orderHandler.getCoupons();
    if (resp[0] == 200) {
      coupons = resp[1];
    }
  }

  void initState() {
    _hyderabadLocation = getCameraData();
    loadPrice();
    loadCoupons();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(
        "PAYMENT SUCCESS: ${response.orderId} / ${response.paymentId} / ${response.signature}");
    var resp = await orderHandler.updatePaymentStatus({
      'order_id': '$orderId',
      'payment_id': '${response.paymentId}',
      'signature': '${response.signature}',
      'payment_status': 'PAYMENT SUCCESS'
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentStatus(paymentSuccess: resp[0] == 200)));
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print("PAYMENT FAILED ERROR: ${response.message}");
    var resp = await orderHandler.updatePaymentStatus({
      'order_id': '$orderId',
      'payment_id': '${response.code}',
      'signature': '${response.message}',
      'payment_status': 'PAYMENT FAILED'
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentStatus(paymentSuccess: resp[0] == 200)));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: $response");
  }

  CameraPosition getCameraData() {
    return CameraPosition(
      target: LatLng(MyApp.lat, MyApp.lng),
      zoom: 17,
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 7)));
    if (picked != null)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<Map> calculateNewPrice(coupon) async {
    couponApplied = true;
    couponValid = true;
    couponCode = coupon['coupon_id'];
    Map outputMap = {};
    double offerAmount =
        total * (double.parse(coupon['discount_percent']) / 100);
    double maxLimit = double.parse(coupon['max_limit']);
    double minLimit = double.parse(coupon['min_limit']);
    if (total > minLimit) {
      if (offerAmount > maxLimit) {
        newOfferPrice = total - maxLimit;
        outputMap = {
          "status": true,
          "message": "Coupon Applied",
          "amount": maxLimit
        };
      } else {
        newOfferPrice = total - offerAmount;
        outputMap = {
          "status": true,
          "message": "Coupon Applied",
          "amount": offerAmount
        };
      }
    } else {
      couponValid = false;
      outputMap = {
        "status": false,
        "message": "Coupon Failed",
        "amount": maxLimit
      };
    }
    setState(() {});
    return outputMap;
  }

  void removeCoupon() {
    couponApplied = false;
    couponValid = false;
    couponCode = "";
    newOfferPrice = 0.0;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Header.appBar('Order Details', null, true),
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
                        child: TextWidget("Cart Items ", textType: "title"),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: MyApp.cartList['products'].length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return CartCard(
                              hideEdit: true,
                              name:
                                  '${MyApp.cartList['products'][index]['product_name']}',
                              imgUrl: MyApp.cartList['products'][index]
                                          ['image_url'] !=
                                      null
                                  ? MyApp.cartList['products'][index]
                                          ['image_url']
                                      .toString()
                                      .replaceAll("http://", "https://")
                                  : 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                              price:
                                  '${MyApp.cartList['products'][index]['offer_price'] != '0' ? MyApp.cartList['products'][index]['offer_price'] : MyApp.cartList['products'][index]['price']}',
                              qty:
                                  '${MyApp.cartList['products'][index]['quantity']} ${MyApp.cartList['products'][index]['metrics']}',
                              cartQuantity: MyApp.cartList['products'][index]
                                  ['cartQuantity'],
                              productId: MyApp.cartList['products'][index]
                                  ['product_pack_id'],
                              onDelete: (i) async {
                                print(MyApp.cartList['products'][index]
                                    ['product_id']);
                                List resp = await cartHandler.deleteFromCart(
                                    MyApp.cartList['products'][index]
                                        ['product_id']);
                                print(resp[1]);
                                MyApp.showToast(resp[1]['message'], context);
                                if (resp[0] == 200) {
                                  setState(() {
                                    MyApp.cartList['products'].removeAt(i);
                                  });
                                }
                                loadPrice();
                              },
                              onQuantityChange: (val) async {
                                List resp = await cartHandler.updateCart({
                                  "product_pack_id": MyApp.cartList['products']
                                      [index]['product_id'],
                                  "quantity": val.toString()
                                });
                                if (resp[0] == 200) {
                                  setState(() {
                                    MyApp.cartList['products'][index]
                                        ['cartQuantity'] = val.toString();
                                  });
                                } else {
                                  MyApp.showToast(resp[1]['message'], context);
                                }
                                loadPrice();
                              },
                            );
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: packs.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var jData = jsonDecode(
                                MyApp.cartList['packs'][0]['pack_data']);
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
                                                  filter: new ImageFilter.blur(
                                                      sigmaX: 3, sigmaY: 3),
                                                  child: Container(
                                                      color:
                                                          Color(0x01000000))),
                                            ),
                                            Center(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.8,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    color: Colors.white,
                                                    child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                    ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: jData['products'].length,
                                                    itemBuilder: (context,index){
                                                     return PackDescCard(
                                                       imgUrl: '${jData['products'][index]['image_url']}'
                                                           .replaceAll('http://', 'https://'),
                                                      
                                                       name: '${jData['products'][index]['product_name']}',
                                                       qty:
                                                           '${jData['products'][index]['quantity']} ${jData['products'][index]['metrics']}',
                                                       itemCount:jData['products'][index]
                                                           ['item_pack_quantity'],
                                                     );
                                                    }),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(onPressed: (){
                                                           Navigator.pop(context);
                                                        }, child: Text("Ok"))
                                                      ],
                                                    )
                                                     ],
                                                    )
                                                    ),
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
                                cartQuantity: packs[index]['cartQuantity'],
                                productId: packs[index]['product_id'],
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget("Offers", textType: "title"),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                        (couponValid)
                                            ? "'$couponCode' Applied"
                                            : "Apply coupon for exciting offers",
                                        textType: "para",
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(0.0),
                                        child: (couponValid)
                                            ? GestureDetector(
                                                child: Text("Remove Promo",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .dangerColor,
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                onTap: () async {
                                                  removeCoupon();
                                                })
                                            : GestureDetector(
                                                child: Text("View Offers",
                                                    style: TextStyle(
                                                        color: Constants
                                                            .dangerColor,
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w800)),
                                                onTap: () async {
                                                  var coupon = await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PromoCodes()));
                                                  if (coupon != null) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        });
                                                    calculateNewPrice(coupon)
                                                        .then((val) {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) {
                                                            return Material(
                                                              type: MaterialType
                                                                  .transparency,
                                                              child: Stack(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: BackdropFilter(
                                                                        filter: new ImageFilter.blur(
                                                                            sigmaX:
                                                                                3,
                                                                            sigmaY:
                                                                                3),
                                                                        child: Container(
                                                                            color:
                                                                                Color(0x01000000))),
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      child: Container(
                                                                          height: size.height * 0.28,
                                                                          width: size.width * 0.7,
                                                                          color: Colors.white,
                                                                          child: Column(
                                                                            children: [
                                                                              Image.asset(couponValid ? Constants.successImage : Constants.failedImage, width: (size.width * 0.7) / 2, height: (size.height * 0.15)),
                                                                              TextWidget("'${coupon['coupon_id']}' ${val['message']}", textType: "title"),
                                                                              TextWidget(couponValid ? "You have saved Rs. ${val['amount']}" : "", textType: "para-bold"),
                                                                              Divider(),
                                                                              Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                                                child: GestureDetector(
                                                                                    child: Text(
                                                                                      couponValid ? "Thanks!" : "Go back",
                                                                                      style: TextStyle(color: Colors.blue[600], fontSize: 18),
                                                                                    ),
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    }),
                                                                              )
                                                                            ],
                                                                          )),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    });
                                                  }
                                                }),
                                      )
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
                                        '₹ ' + subtotal.toString(),
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
                                        '₹ ' + delivery.toString(),
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
                                      (newOfferPrice != 0.0)
                                          ? Column(
                                              children: [
                                                Text(
                                                  "₹ $total",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                                Text(
                                                  "₹ $newOfferPrice",
                                                  style: TextStyle(
                                                      color: Constants
                                                          .successColor,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            )
                                          : Text(
                                              '₹ ' + total.toString(),
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
                                    value: isScheduled,
                                    onChanged: (val) {
                                      setState(() {
                                        isScheduled = val;
                                      });
                                    }),
                                TextWidget("Schedule Delivery: ",
                                    textType: "title"),
                              ],
                            ),
                            TextButton(
                              child: Text(
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                              onPressed: isScheduled
                                  ? () {
                                      _selectDate(context);
                                    }
                                  : null,
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
                        child: TextWidget(
                            "${MyApp.userInfo['flat_no']}, ${MyApp.userInfo['address']}",
                            textType: "title"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextWidget(
                            "Landmark: ${MyApp.userInfo['landmark']}",
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
                              initialCameraPosition: _hyderabadLocation,
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
                              child: TextWidget("Select Payment Method: ",
                                  textType: "title-light"),
                            ),
                            Container(
                              width: size.width * 0.4,
                              child: DropdownButton(
                                value: paymentMethod,
                                elevation: 16,
                                icon: Icon(Icons.arrow_drop_down),
                                isExpanded: true,
                                items: <String>[
                                  'Cash on Delivery',
                                  'Pay Online'
                                ].map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: TextWidget(e, textType: "title"),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    paymentMethod = value;
                                  });
                                },
                              ),
                            )
                          ])
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: PrimaryButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return Center(child: CircularProgressIndicator());
                      });
                  var resp = await orderHandler.placeOrder({
                    "applied_coupon": "$couponApplied",
                    "coupon_valid": "$couponValid",
                    "coupon_code": couponCode ?? "NONE",
                    "scheduled_order": "$isScheduled",
                    "schedule_time": "$selectedDate",
                    "user_lat": "${MyApp.lat}",
                    "user_lng": "${MyApp.lng}",
                    "user_address": "${MyApp.userInfo['address']}",
                    "payment_method": "$paymentMethod",
                  });
                  if (resp[0] == 200) {
                    Navigator.pop(context);
                    MyApp.showToast(resp[1]['message'], context);
                    setState(() {
                      orderId = resp[1]['order_id'];
                    });
                    if (paymentMethod == "Pay Online") {
                      Map<String, dynamic> options = {
                        "key": "rzp_test_kL23yx68xeTo63",
                        "amount":
                            (double.parse(resp[1]['amount'].toString()) * 100)
                                .toInt(),
                        "name": "Order Id: #${resp[1]['order_id']}",
                        "description": "One final set to finish the order",
                        // "order_id": resp[1]['order_id'],
                        "timeout": 120,
                        "prefil": {
                          "contact": MyApp.userInfo['phone_no'],
                          "email": MyApp.userInfo['email']
                        },
                        "external": {
                          "wallets": ["paytm"]
                        }
                      };

                      print("OPTIONS TO PAYMENT GATEWAY: $options");

                      try {
                        _razorpay.open(options);
                      } catch (e) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    PaymentStatus(paymentSuccess: false)));
                      }
                    } else {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderStatus(orderSuccess: true)));
                    }
                  } else {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OrderStatus(orderSuccess: false)));
                  }
                },
                backgroundColor: Constants.kButtonBackgroundColor,
                textColor: Constants.kButtonTextColor,
                width: MediaQuery.of(context).size.width * 0.5,
                text: "PLACE ORDER",
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      )),
    );
  }
}
