import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';

class ProductCard extends StatelessWidget {
  
  final String qty;
  final bool wishList;
  final String imgUrl;
  final String name;
  final String price;

   ProductCard({this.qty,this.wishList,this.imgUrl,this.name,this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
                                  height: 180,
                                  width: 160,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            width: 160,
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Constants.qtyBgColor,
                                                    borderRadius: BorderRadius.circular(3)
                                                  ),
                                                  
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(3.0),
                                                    child: Text(this.qty),
                                                  ),
                                                ),
                                                Expanded(child: Container(),),
                                               this.wishList?Icon(AntDesign.heart,size: 20,color: Constants.wishListSelectedColor,) :Icon(AntDesign.hearto,size: 20,color: Constants.wishListUnSelectedColor,)
                                              ],
                                            ),
                                          ),
                                        ),
                                       CachedNetworkImage(
  imageUrl: this.imgUrl,
  imageBuilder: (context, imageProvider) => Container(
    width: 140,height: 105,
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
    height: 100,
    child: Center(
      child: Text('Loading..'),
    ),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(12.0,4,0,2),
                                          child: Text(this.name,style: TextStyle(fontWeight: FontWeight.w600),),
                                        ),
                                        Padding(
                                         padding: const EdgeInsets.fromLTRB(12.0,2,0,2),
                                          child: Text('Rs '+this.price,style: TextStyle(fontWeight: FontWeight.w500),)
                                        )
                                    ],),
                                  ),
                                );
  }
}