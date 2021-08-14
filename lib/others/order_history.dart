import 'package:flutter/material.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/order_history_card.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List orders;
  OrderApiHandler orderHandler = new OrderApiHandler();

  @override
  void initState() {
    loadData();
    super.initState();
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
                              orderInfo: orders[index],
                              orderNumber: '${orders[index]['order_id']}',
                              totalPrice: orders[index]['total_price'],
                              discountPrice:
                                  '${orders[index]['price_after_discount']}',
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
