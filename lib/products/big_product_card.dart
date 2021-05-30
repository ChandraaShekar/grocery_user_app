// import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';
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
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: size.width / 1.5,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Constants.qtyBgColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: TextWidget(
                            this.widget.productInfo[0]['quantity'],
                            textType: "label",
                          ),
                        ),
                      ),
                      WishButton(
                        isSelected: MyApp.wishListIds
                            .contains(widget.productInfo[0]['product_id']),
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
              SizedBox(height: 5),
              CachedNetworkImage(
                imageUrl:
                    "https://media.istockphoto.com/photos/three-potatoes-picture-id157430678?k=6&m=157430678&s=612x612&w=0&h=3A77PeFuUUqoC4EVZaydkd6tSakZSWO61T21bMn4KLQ=",
                // imageUrl: widget.productImages[0]['image_url']
                //     .toString()
                //     .replaceAll('http://', 'https://'),
                imageBuilder: (context, imageProvider) => Container(
                  width: size.width / 2.25,
                  height: size.width / 3.8,
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
                      horizontal: 8.0, vertical: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 5.0),
                          child: TextWidget(
                            widget.productInfo[0]['product_name'],
                            textType: "title",
                            // maxLines: 2,
                            // softWrap: true,
                            // textWidthBasis: TextWidthBasis.parent,
                            // style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     color: Constants.headingTextBlack,
                            //     letterSpacing: 0.3,
                            //     fontSize: size.height / 50),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 2, 0, 2),
                          child: TextWidget(
                              'Rs. ' + widget.productInfo[0]['price'],
                              textType: "card-price"))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
