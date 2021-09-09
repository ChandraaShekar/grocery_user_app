import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';
import 'package:user_app/widgets/wish_button.dart';

class ProductCard extends StatefulWidget {
  final String qty;
  final bool wishList;
  final String imgUrl;
  final String name;
  final String price;
  final String offerPrice;
  final String productId;

  ProductCard(
      {this.qty,
      this.wishList,
      this.imgUrl,
      this.name,
      this.price,
      this.productId,
      this.offerPrice});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  WishlistApiHandler wishlistHandler = new WishlistApiHandler();
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.width / 1.9,
      width: size.width / 2.1,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Card(
          // color: Color(0xFFF9F9F9),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                            child: Text(this.widget.qty),
                          ),
                        ),
                        WishButton(
                          isSelected: widget.wishList,
                          onChanged: (value) async {
                            if (value) {
                              List resp = await wishlistHandler
                                  .addToWishList('${widget.productId}');
                              MyApp.wishListIds.add(widget.productId);
                              MyApp.showToast('${resp[1]['message']}', context);
                            } else {
                              List resp = await wishlistHandler
                                  .removeFromWishList('${widget.productId}');
                              MyApp.wishListIds.remove(widget.productId);
                              MyApp.showToast('${resp[1]['message']}', context);
                            }
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
                    height: 95,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.contain,
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
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          fontSize: size.height / 58),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 2, 0, 2),
                    child: TextWidget(
                      'Rs ' + this.widget.price,
                      textType: "label-grey",
                    )),
                    SizedBox(height: 5,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
