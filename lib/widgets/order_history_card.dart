import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:user_app/others/order_history_info.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class OrderHistoryCard extends StatelessWidget {
  final StringCallback funcCallback;
  final String orderNumber;
  final String price;
  final String type;
  final Map orderInfo;
  final String paymentStatus;
  OrderHistoryCard({this.funcCallback,this.orderNumber, this.price, this.type, this.orderInfo,this.paymentStatus});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => OrderHistoryInfo(
                    orderId: this.orderNumber, orderInfo: this.orderInfo)));
      },
      child: Card(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  this.orderNumber,
                  textType: "title",
                ),
                SizedBox(height: 15),
                Text(
                  this.price,
                  style: TextStyle(
                    fontSize: 18,
                      fontWeight: FontWeight.w600, color: Constants.kMain2),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dispType(),
                   if(paymentStatus=='PAYMENT FAILED')
                    GestureDetector(
                      onTap: (){
                        funcCallback('clicked');
                      },
                      child: Container(
                            color: Constants.incDecColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'RETRY PAYMENT',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                              ),
                            ),
                          ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dispType() {
    if (type == 'Delivered') {
      return Container(
        color: Constants.deliveredBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            type,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2),
          ),
        ),
      );
    } else {
      return Container(
        color: Constants.buttonBgColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            type,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2),
          ),
        ),
      );
    }
  }
}
