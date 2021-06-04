import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class PackDescCard extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String qty;
  final String itemCount;
  PackDescCard({this.imgUrl, this.name, this.qty, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Card(
        // shape: BorderRadius.circular(15),
        child: Container(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: this.imgUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          // colorFilter:
                          //     ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.white,
                      child: Container(
                          height: 60, width: 60, color: Colors.grey[300]),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: Text(
                  this.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
                Container(
                  decoration: BoxDecoration(
                      color: Constants.qtyBgColor,
                      borderRadius: BorderRadius.circular(3)),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(this.qty),
                  ),
                ),
                TextWidget("x ${this.itemCount}", textType: "subheading")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
