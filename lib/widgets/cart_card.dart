import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/counter.dart';
import 'package:user_app/widgets/text_widget.dart';

class CartCard extends StatefulWidget {
  final String imgUrl;
  final String name;
  final String price;
  final String qty;
  final String cartQuantity;
  final String productId;
  final ValueChanged<int> onDelete;
  final ValueChanged<int> onQuantityChange;

  CartCard(
      {this.imgUrl,
      this.name,
      this.price,
      this.qty,
      this.cartQuantity,
      this.productId,
      this.onDelete,
      this.onQuantityChange});

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Container(
          height: size.height / 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Stack(
              children: [
                Positioned(
                    // top: 10,
                    left: size.width / 3.6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Container(
                          width: (size.width) / 2,
                          child: TextWidget(
                            this.widget.name,
                            textType: "title",
                          )),
                    )),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: this.widget.imgUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: size.width / 4,
                          height: size.height / 8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: size.height / 8,
                          child: Center(
                            child: Text('Loading..'),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 3.3,
                          height: 30,
                          // child: TextWidget(
                          //     (this.widget.name.substring(
                          //             0,
                          //             (widget.name.length > 20
                          //                 ? 20
                          //                 : widget.name.length))) +
                          //         "${widget.name.length > 20 ? '...' : ''}",
                          //     textType: "title"),
                        ),
                        TextWidget(
                          'Rs. ' + this.widget.price,
                          textType: "card-price",
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Constants.qtyBgColor,
                              borderRadius: BorderRadius.circular(3)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: TextWidget(
                                this.widget.qty,
                                textType: "label",
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.delete,
                                color: Constants.dangerColor,
                                size: size.height / 45,
                              ),
                              onTap: () {
                                var index = MyApp.cartList.indexWhere(
                                    (element) =>
                                        element['product_id'] ==
                                        widget.productId);
                                widget.onDelete(index);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: 10,
                    right: 0,
                    child: CounterBtn(
                      incDecheight: 25,
                      incDecwidth: 25,
                      leftCounterColor: Constants.buttonBgColor,
                      rightCounterColor: Constants.buttonBgColor,
                      incPressed: () {
                        int index = MyApp.cartList.indexWhere((element) =>
                            element['product_id'] == widget.productId);
                        var x = int.parse('${widget.cartQuantity}');
                        if (index >= 0) {
                          if (x < 10) {
                            var newVal = x + 1;
                            print(MyApp.cartList[index]['cartQuantity']);
                            widget.onQuantityChange(newVal);
                          }
                        }
                      },
                      decPressed: () {
                        int index = MyApp.cartList.indexWhere((element) =>
                            element['product_id'] == widget.productId);
                        var x = int.parse('${widget.cartQuantity}');
                        if (x > 1) {
                          var newVal = x - 1;
                          print(MyApp.cartList[index]['cartQuantity']);
                          widget.onQuantityChange(newVal);
                        }
                      },
                      text: '${widget.cartQuantity}',
                      widgetWidth: 110,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
