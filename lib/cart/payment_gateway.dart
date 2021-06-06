import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_app/main.dart';

class PaymentGateway extends StatefulWidget {
  final Map response;
  PaymentGateway(this.response, {Key key}) : super(key: key);

  @override
  _PaymentGatewayState createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  Razorpay _razorpay = new Razorpay();
  Map options = {};
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
  }

  void makePayment() {
    options = {
      "key": "rzp_test_kL23yx68xeTo63",
      "amount": widget.response['amount'],
      "name": "Order Id: #${widget.response['order_id']}",
      "description": "One final set to finish the order",
      "prefil": {
        "contact": MyApp.userInfo['phone_no'],
        "email": MyApp.userInfo['email']
      },
      "external": {
        "wallets": ["paytm"]
      }
    };
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
