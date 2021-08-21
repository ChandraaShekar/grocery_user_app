import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class OrderStatus extends StatefulWidget {
  final bool orderSuccess;
  final String orderId;
  OrderStatus({Key key, this.orderSuccess, this.orderId}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  Map options = {};
  @override
  void initState() {
    MyApp.socket.emit("new Order", "New order Placed");
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
        body: Center(
          child: Column(children: [
            Image.asset(
                (widget.orderSuccess)
                    ? Constants.paymentSuccessImage
                    : Constants.paymentFailedImage,
                width: MediaQuery.of(context).size.width),
            TextWidget(
                (widget.orderSuccess)
                    ? "Order Placed Successfully."
                    : "Failed to place order.",
                textType: "title"),
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
            (widget.orderSuccess)
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextWidget("Your order will be delivered in 1 hour",
                        textType: "title"))
                : SizedBox(),
            (widget.orderSuccess)
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
    );
  }
}
