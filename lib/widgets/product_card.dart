import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/wish_button.dart';

class ProductCard extends StatefulWidget {
  final String qty;
  final bool wishList;
  final String imgUrl;
  final String name;
  final String price;

  ProductCard({this.qty, this.wishList, this.imgUrl, this.name, this.price});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 160,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  width: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Constants.qtyBgColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(this.widget.qty),
                        ),
                      ),
                      WishButton(
                        isSelected: false,
                        onChanged: (value) {
                          print("OUT OF WIDGET $value");
                        },
                      )
                    ],
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: this.widget.imgUrl,
                imageBuilder: (context, imageProvider) => Container(
                  width: 140,
                  height: 105,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 5.0),
                  child: Text(
                    this.widget.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 2, 0, 2),
                  child: Text(
                    'Rs ' + this.widget.price,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
