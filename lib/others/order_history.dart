import 'package:flutter/material.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/order_history_card.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar('Order History', null, true),
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5.0, top: 10, bottom: 5),
                      child: Text('Sept 13, 2021'),
                    ),
                    ListView.builder(
                        itemCount: 2,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return OrderHistoryCard(
                            orderNumber: 'OD - 428987 - N',
                            price: '₹ 300',
                            type: 'In Transit',
                          );
                        })
                  ],
                ),
              );
            }));
  }
}
