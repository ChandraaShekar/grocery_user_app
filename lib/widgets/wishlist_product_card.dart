import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class WishListProductCard extends StatelessWidget {
  final String imgUrl;
  final String price;
  final String name;
  final String qty;
  final bool wishList;

  WishListProductCard(
      {this.imgUrl, this.price, this.name, this.qty, this.wishList});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: size.height / 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: this.imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: size.width / 5,
                      height: size.width / 5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          // colorFilter:
                          //     ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      height: 80,
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
                      width: size.width / 2,
                      child: TextWidget(
                        this.name,
                        textType: "title",
                      ),
                    ),
                    TextWidget('Rs. ' + this.price, textType: "card-price"),
                  ],
                ),
                Expanded(
                  child: Container(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Constants.qtyBgColor,
                          borderRadius: BorderRadius.circular(3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6),
                        child: TextWidget(
                          this.qty,
                          textType: "label",
                        ),
                      ),
                    ),
                    this.wishList
                        ? Icon(
                            AntDesign.heart,
                            size: 20,
                            color: Constants.wishListSelectedColor,
                          )
                        : Icon(
                            AntDesign.hearto,
                            size: 20,
                            color: Constants.wishListUnSelectedColor,
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
