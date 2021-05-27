import 'package:flutter/material.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/cart/checkout_address.dart';
import 'package:user_app/main.dart';
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/cart_card.dart';

class CartList extends StatefulWidget {
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  CartApiHandler cartHandler = new CartApiHandler();
  String subtotal = '3940';
  String delivery = '89';
  String tax = '50';
  String total = '4200';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          child: MyApp.cartList.length == 0
              ? Center(
                  child: Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: MyApp.cartList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return CartCard(
                            name: '${MyApp.cartList[index]['product_name']}',
                            imgUrl: MyApp.cartList[index]['image_url'] != null
                                ? MyApp.cartList[index]['image_url']
                                    .toString()
                                    .replaceAll("http://", "https://")
                                : 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                            price:
                                '${MyApp.cartList[index]['offer_price'] != '0' ? MyApp.cartList[index]['offer_price'] : MyApp.cartList[index]['price']}',
                            qty:
                                '${MyApp.cartList[index]['quantity']} ${MyApp.cartList[index]['metrics']}',
                            cartQuantity: MyApp.cartList[index]['cartQuantity'],
                            productId: MyApp.cartList[index]['product_id'],
                            onDelete: (i) async {
                              List resp = await cartHandler.deleteFromCart(
                                  MyApp.cartList[index]['product_id']);
                              MyApp.showToast(resp[1]['message'], context);
                              if (resp[0] == 200) {
                                setState(() {
                                  MyApp.cartList.removeAt(i);
                                });
                              }
                            },
                            onQuantityChange: (val) async {
                              List resp = await cartHandler.updateCart({
                                "product_id": MyApp.cartList[index]
                                    ['product_id'],
                                "quantity": val.toString()
                              });
                              if (resp[0] == 200) {
                                setState(() {
                                  MyApp.cartList[index]['cartQuantity'] =
                                      val.toString();
                                });
                              } else {
                                MyApp.showToast(resp[1]['message'], context);
                              }
                            },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Sub Total',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '₹ ' + subtotal,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Delivery',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '₹ ' + delivery,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tax',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '₹ ' + tax,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ]),
                            ),
                            Divider(),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      '₹ ' + total,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
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
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutAddress())),
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
