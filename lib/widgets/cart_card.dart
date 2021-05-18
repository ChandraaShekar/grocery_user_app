import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/counter.dart';

class CartCard extends StatelessWidget {

  final String imgUrl;
  final String name;
  final String price;
  final String qty;

  CartCard({this.imgUrl,this.name,this.price,this.qty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4,0),
      child: Card(
              child: Container(
          height: 120,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
            child: Row(
              children: [
               ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child:    CachedNetworkImage(
  imageUrl: this.imgUrl,
  imageBuilder: (context, imageProvider) => Container(
    width: 80,height: 100,
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
                SizedBox(width:8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(this.name,style: TextStyle(fontWeight: FontWeight.w600),),
                    Text('₹ '+this.price,style: TextStyle(fontWeight: FontWeight.w600),),
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
                  ],
                ),
                Expanded(child: Container(),),
               Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      SizedBox(height:20),
                       ],
                    ),
                    CounterBtn(
                      incDecheight: 40,
                      incDecwidth: 48,
                      leftCounterColor: Constants.buttonBgColor,
                      rightCounterColor: Constants.buttonBgColor,
                      incPressed: (){

                      },
                      decPressed: (){

                      },
                      text: '0',
                      widgetWidth: 110,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                  child:Icon(Icons.delete,color: Constants.buttonBgColor,),
                  onTap: (){
                    
                  },
                ),

                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}