import 'package:flutter/material.dart';
import 'package:user_app/api/orderApi.dart';
import 'package:user_app/others/order_history_info.dart';
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
    if (resp[0] == 200) {
      setState(() {
        orders = resp[1];
      });
      print('here');
    print(orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar('Order History', null, true, context, true),
        body: orders == null
            ? Center(child: CircularProgressIndicator())
            : (orders.length == 0)
                ? Center(
                    child: TextWidget("No Previous orders.", textType: "title"))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      String date = DateFormat('MMM dd, yyyy')
                          .format(DateTime.parse(orders[index]['created_at']));
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 5),
                              child: ((index > 0 &&
                                          orders[index]['created_at']
                                                  .toString()
                                                  .substring(0, 10) !=
                                              orders[index - 1]['created_at']
                                                  .toString()
                                                  .substring(0, 10)) ||
                                      index == 0)
                                  ? Center(
                                      child: TextWidget(
                                        '$date',
                                        textType: "label",
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OrderHistoryInfo(
                                            orderId: orders[index]['order_id'],
                                            orderInfo: orders[index]))).then(
                                    (value) => loadData());
                              },
                              child: OrderHistoryCard(
                                orderInfo: orders[index],
                                orderNumber: '${orders[index]['order_id']}',
                                totalPrice: orders[index]['total_price'],
                                discountPrice:
                                    '${orders[index]['price_after_discount']}',
                                type: '${orders[index]['order_status']}',
                                paymentStatus:
                                    '${orders[index]['payment_status']}',
                              ),
                            ),
                          ],
                        ),
                      );
                    }));
  }
}
