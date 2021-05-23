import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/counter.dart';

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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Container(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: CachedNetworkImage(
                    imageUrl: this.widget.imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 100,
                      child: Center(
                        child: Text('Loading..'),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 260,
                      child: Text(
                        (this.widget.name.substring(
                                0,
                                (widget.name.length > 20
                                    ? 20
                                    : widget.name.length))) +
                            "${widget.name.length > 20 ? '...' : ''}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.4),
                      ),
                    ),
                    Text(
                      'Rs. ' + this.widget.price,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Constants.qtyBgColor,
                          borderRadius: BorderRadius.circular(3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        child: Text(this.widget.qty,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 10)),
                      ),
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
                            size: 20,
                          ),
                          onTap: () {
                            var index = MyApp.cartList.indexWhere((element) =>
                                element['product_id'] == widget.productId);
                            widget.onDelete(index);
                          },
                        ),
                      ],
                    ),
                    CounterBtn(
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
