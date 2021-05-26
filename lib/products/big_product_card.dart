import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/wish_button.dart';

class BigProductCard extends StatefulWidget {
  final List productInfo, productImages;
  BigProductCard({Key key, this.productInfo, this.productImages})
      : super(key: key);

  @override
  _BigProductCardState createState() => _BigProductCardState();
}

class _BigProductCardState extends State<BigProductCard> {
  WishlistApiHandler wishlistHandler = new WishlistApiHandler();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Card(
      elevation: 5,
      child: Container(
        height: size.width / 2.2,
        width: size.width / 2.25,
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
                          child: Text(this.widget.productInfo[0]['quantity']),
                        ),
                      ),
                      WishButton(
                        isSelected: false,
                        onChanged: (value) async {
                          if (value) {
                            List resp = await wishlistHandler.addToWishList(
                                '${widget.productInfo[0]['product_id']}');
                            MyApp.wishListIds
                                .add(widget.productInfo[0]['product_id']);
                            MyApp.showToast('${resp[1]['message']}', context);
                          } else {
                            List resp =
                                await wishlistHandler.removeFromWishList(
                                    '${widget.productInfo[0]['product_id']}');
                            MyApp.wishListIds
                                .remove(widget.productInfo[0]['product_id']);
                            MyApp.showToast('${resp[1]['message']}', context);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              CachedNetworkImage(
                imageUrl: widget.productImages[0]['image_url']
                    .toString()
                    .replaceAll('http://', 'https://'),
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
                    widget.productInfo[0]['product_name'],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 2, 0, 2),
                  child: Text(
                    'Rs ' + widget.productInfo[0]['price'],
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
