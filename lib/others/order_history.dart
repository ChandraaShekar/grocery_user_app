import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/cart/payment_status.dart';
import 'package:user_app/main.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/order_history_card.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  Razorpay _razorpay = new Razorpay();
  List orders;
  OrderApiHandler orderHandler = new OrderApiHandler();
  String payOrderId = '';

  @override
  void initState() {
    loadData();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(
        "PAYMENT SUCCESS: ${response.orderId} / ${response.paymentId} / ${response.signature}");
    var resp = await orderHandler.updatePaymentStatus({
      'order_id': '$payOrderId',
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
      'order_id': '$payOrderId',
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

  void loadData() async {
    List resp = await orderHandler.getOrderHistory();
    print('hey' + resp[1].toString());
    if (resp[0] == 200) {
      setState(() {
        orders = resp[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar('Order History', null, true),
        body: orders == null
            ? Center(child: CircularProgressIndicator())
            : (orders.length == 0)
                ? Center(
                    child: TextWidget("No Previous orders.", textType: "title"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var date = DateFormat('MMM, dd yyyy')
                          .format(DateTime.parse(orders[index]['created_at']));
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 5),
                              child: TextWidget(
                                '$date',
                                textType: "label",
                              ),
                            ),
                            OrderHistoryCard(
                              funcCallback: (String h) {
                                int discountPrice = int.parse((double.parse(
                                            orders[index]['discount_price']) *
                                        100)
                                    .toStringAsFixed(0));
                                int totalPrice = int.parse((double.parse(
                                            orders[index]['total_price']) *
                                        100)
                                    .toStringAsFixed(0));

                                // if (orders[index]['discount_price'] == 0) {
                                //   totalAmount = int.parse((double.parse(
                                //               orders[index]['total_amount']
                                //                   .toString()) *
                                //           100)
                                //       .toStringAsFixed(2));
                                // } else {
                                //   totalAmount = int.parse((double.parse(
                                //               orders[index]['discount_price']
                                //                   .toString()) *
                                //           100)
                                //       .toStringAsFixed(2));
                                // }
                                // payOrderId = '${orders[index]['order_id']}';
                                try {
                                  Map<String, dynamic> options = {
                                    "key": "rzp_test_kL23yx68xeTo63",
                                    "amount": (discountPrice > 0)
                                        ? discountPrice
                                        : totalPrice,
                                    "name":
                                        "Order Id: #${orders[index]['order_id']}",
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
                                              paymentSuccess: false)));
                                }
                              },
                              orderInfo: orders[index],
                              orderNumber: '${orders[index]['order_id']}',
                              price:
                                  '₹ ${(orders[index]['price_after_discount'] == "0") ? orders[index]['total_price'] : orders[index]['price_after_discount']}',
                              type: '${orders[index]['order_status']}',
                              paymentStatus:
                                  '${orders[index]['payment_status']}',
                            ),
                          ],
                        ),
                      );
                    }));
  }
}
