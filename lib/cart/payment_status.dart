import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class PaymentStatus extends StatefulWidget {
  final bool paymentSuccess;
  final String orderId;
  PaymentStatus({Key key, this.paymentSuccess, this.orderId}) : super(key: key);

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  Map options = {};
  @override
  void initState() {
    MyApp.socket.emit("new-order", "New order Placed");
    print("${widget.orderId}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(children: [
              Image.asset(
                  (widget.paymentSuccess)
                      ? Constants.paymentSuccessImage
                      : Constants.paymentFailedImage,
                  width: MediaQuery.of(context).size.width),
              TextWidget(
                  (widget.paymentSuccess)
                      ? "Payment Successful"
                      : "Payment Failed",
                  textType: "title"),
              TextWidget(
                  (widget.paymentSuccess)
                      ? ""
                      : "Any money deducted will be refunded in 48 hours.",
                  textType: "title"),
              (widget.paymentSuccess)
                  ? SizedBox()
                  : TextButton(
                      child: Text("Contact Support"),
                      onPressed: () {},
                    ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("Your Order ID: ", textType: "title"),
                      TextWidget("${widget.orderId}", textType: "title"),
                    ]),
              ),
              (widget.paymentSuccess)
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextWidget(
                          "Your order will be delivered in 1 hour",
                          textType: "title"))
                  : SizedBox(),
              (widget.paymentSuccess)
                  ? Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextWidget(
                          "Everyone Frutte's crew are either fully or partially vacciated, We follow all the guidelines issued by the WHO & Ministry of Health.",
                          textType: "title"))
                  : SizedBox(),
              TextButton(
                child: Text("Continue Shopping"),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => DashboardTabs()));
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
