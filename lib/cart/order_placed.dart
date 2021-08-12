import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class OrderStatus extends StatefulWidget {
  final bool orderSuccess;
  OrderStatus({Key key, this.orderSuccess}) : super(key: key);

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
