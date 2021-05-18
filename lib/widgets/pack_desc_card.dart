import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';

class PackDescCard extends StatelessWidget {
 final Function onPressed;
 final String imgUrl;
 final String name;
 final String qty;
 

 PackDescCard({this.onPressed,this.imgUrl,this.name,this.qty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8,0),
      child: Card(
        child: Container(
            height: 70,
            child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child:     CachedNetworkImage(
  imageUrl: this.imgUrl,
  imageBuilder: (context, imageProvider) => Container(
    width: 60,height: 70,
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
    height: 50,
    child: Center(
        child: Text('Loading..'),
    ),
  ),
  errorWidget: (context, url, error) => Icon(Icons.error),
),
        ),
        SizedBox(width:8),
         Expanded(
             child: Text(this.name,style: TextStyle(fontWeight: FontWeight.w600),)),
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
        IconButton(icon: Icon(Icons.edit),onPressed: onPressed,)

        ],
      ),
            ),
          ),
        ),
    );
  }
}