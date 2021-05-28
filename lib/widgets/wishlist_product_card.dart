import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';

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
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
        child: Container(
          height: 90,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: CachedNetworkImage(
                    imageUrl: this.imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 70,
                      height: 80,
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
                    Text(
                      this.name,
                      style: TextStyle(
                          fontSize: size.height / 52,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Rs. ' + this.price,
                      style: TextStyle(
                          color: Constants.secondaryTextColor,
                          fontSize: size.height / 52,
                          fontWeight: FontWeight.w800),
                    ),
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
                        padding: const EdgeInsets.all(3.0),
                        child: Text(this.qty),
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
