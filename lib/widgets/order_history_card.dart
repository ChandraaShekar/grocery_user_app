import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/cart/payment_status.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrderHistoryCard extends StatefulWidget {
  final String orderNumber;
  final String totalPrice;
  final String discountPrice;
  final String type;
  final Map orderInfo;
  final String paymentStatus;
  OrderHistoryCard(
      {this.orderNumber,
      this.totalPrice,
      this.type,
      this.orderInfo,
      this.paymentStatus,
      this.discountPrice});

  @override
  _OrderHistoryCardState createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  Razorpay _razorpay = new Razorpay();
  OrderApiHandler orderHandler = new OrderApiHandler();
  String payOrderId = '';
  Map<String, int> orderStatus = {
    "NONE": 0,
    "ORDER PLACED": 1,
    "ORDER PREPARED": 2,
    "PICKING UP": 3,
    "ON THE WAY": 4,
    "DELIVERED": 5
  };

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(
        "PAYMENT SUCCESS: ${response.orderId} / ${response.paymentId} / ${response.signature}");
    Map data = {
      'order_id': '${widget.orderNumber}',
      'payment_id': '${response.paymentId}',
      'signature': '${response.signature}',
      'payment_status': 'PAYMENT SUCCESS'
    };
    print(data);
    var resp = await orderHandler.updatePaymentStatus(data);
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentStatus(
                paymentSuccess: resp[0] == 200, orderId: widget.orderNumber)));
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    print("PAYMENT FAILED ERROR: ${response.message}");
    var resp = await orderHandler.updatePaymentStatus({
      'order_id': '${widget.orderNumber}',
      'payment_id': '${response.code}',
      'signature': '${response.message}',
      'payment_status': 'PAYMENT FAILED'
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => PaymentStatus(
                paymentSuccess: resp[0] == 200, orderId: widget.orderNumber)));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: $response");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                "#${this.widget.orderNumber}",
                textType: "title",
              ),
              SizedBox(height: 15),
              Text(
                "Rs. ${int.parse(this.widget.discountPrice) > 0 ? this.widget.discountPrice : this.widget.totalPrice}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Constants.kMain2),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  // Row(
                  //   children: [
                  StepProgressIndicator(
                    totalSteps: 5,
                    currentStep: orderStatus[widget.type],
                    roundedEdges: Radius.circular(10.0),
                    selectedColor: (widget.paymentStatus == "PAYMENT FAILED")
                        ? Constants.dangerColor
                        : (widget.type == "DELIVERED")
                            ? Constants.successColor
                            : Constants.primaryColor,
                  ),
                  // Container(
                  //   width: size.width * 0.2,
                  //   child: (widget.paymentStatus == "PAYMENT FAILED")
                  //       ? Icon(Icons.close_outlined,
                  //           color: Constants.dangerColor)
                  //       : (widget.type == "DELIVERED")
                  //           ? Icon(Icons.check_circle_outline,
                  //               color: Constants.successColor)
                  //           : Icon(Icons.watch_outlined,
                  //               color: Constants.primaryColor),
                  // ),
                  //   ],
                  // ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dispType(),
                      if (widget.paymentStatus == 'PAYMENT FAILED')
                        GestureDetector(
                          onTap: () {
                            int discountPrice = int.parse(
                                (double.parse(widget.discountPrice) * 100)
                                    .toStringAsFixed(0));
                            int totalPrice = int.parse(
                                (double.parse(widget.totalPrice) * 100)
                                    .toStringAsFixed(0));
                            try {
                              Map<String, dynamic> options = {
                                "key": "rzp_test_kL23yx68xeTo63",
                                "amount": discountPrice > 0
                                    ? discountPrice
                                    : totalPrice,
                                "name": "Order Id: #${widget.orderNumber}",
                                "description":
                                    "One final set to finish the order",
                                // "order_id": resp[1]['order_id'],
                                "timeout": 180,
                                "prefil": {
                                  "contact": MyApp.userInfo['phone_no'],
                                  "email": MyApp.userInfo['email']
                                },
                                "external": {
                                  "wallets": ["paytm"]
                                }
                              };

                              print("OPTIONS TO PAYMENT GATEWAY: $options");

                              _razorpay.open(options);
                            } catch (e) {
                              print(e);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PaymentStatus(
                                          paymentSuccess: false,
                                          orderId: widget.orderNumber)));
                            }
                          },
                          child: Container(
                            color: Constants.incDecColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RETRY PAYMENT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dispType() {
    if (widget.type == 'Delivered') {
      return Container(
        color: Constants.deliveredBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.type,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2),
          ),
        ),
      );
    } else {
      return Container(
        color: Constants.buttonBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.type,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2),
          ),
        ),
      );
    }
  }
}
