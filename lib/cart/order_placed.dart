import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/primary_button.dart';
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
    MyApp.socket.emit("new-order", "New order Placed");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(
            child: Column(children: [
              SizedBox(height: 30),
              Image.asset(
                  (widget.orderSuccess)
                      ? Constants.paymentSuccessImage
                      : Constants.paymentFailedImage,
                  width: MediaQuery.of(context).size.width),
              TextWidget(
                (widget.orderSuccess)
                    ? "Order Placed Successfully!"
                    : "Failed to place order!",
                textType: "heading-green",
              ),
              // Divider(),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget("Your Order ID: ", textType: "subtitle-grey"),
                      TextWidget("${widget.orderId}", textType: "subheading"),
                    ]),
              ),
              (widget.orderSuccess)
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      child: TextWidget(
                          "Your order will be delivered in 1 hour",
                          textType: "subheading"))
                  : SizedBox(),
              (widget.orderSuccess)
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: TextWidget(
                          "Everyone in Frutte's crew are either fully or partially vaccinated, We follow all the guidelines issued by the WHO & Ministry of Health.",
                          textType: "title-light"))
                  : SizedBox(),
              SizedBox(height: 30),
              PrimaryButton(
                backgroundColor: Constants.kButtonBackgroundColor,
                textColor: Constants.kButtonTextColor,
                width: MediaQuery.of(context).size.width * 0.6,
                text: "CONTINUE SHOPPING",
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => DashboardTabs()));
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
