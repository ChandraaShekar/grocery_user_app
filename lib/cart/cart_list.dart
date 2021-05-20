import 'package:flutter/material.dart';
import 'package:user_app/cart/checkout_address.dart';
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/cart_card.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  String subtotal = '3940';
  String delivery = '89';
  String tax = '50';
  String total = '4200';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CartCard(
                      name: 'Nestle',
                      imgUrl:
                          'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                      price: '200',
                      qty: '1 KG',
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub Total',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹ ' + subtotal,
                                style: TextStyle(fontSize: 18),
                              )
                            ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Delivery',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '₹ ' + delivery,
                                style: TextStyle(fontSize: 18),
                              )
                            ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tax',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹ ' + tax,
                                style: TextStyle(fontSize: 18),
                              )
                            ]),
                      ),
                      Divider(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                '₹ ' + total,
                                style: TextStyle(fontSize: 18),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              PrimaryCustomButton(
                title: 'Checkout',
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CheckoutAddress())),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
