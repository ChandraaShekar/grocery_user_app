import 'package:flutter/material.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/widgets/wishlist_product_card.dart';

class WishListProducts extends StatefulWidget {
  @override
  _WishListProductsState createState() => _WishListProductsState();
}

class _WishListProductsState extends State<WishListProducts> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context,int index){
            return GestureDetector(
              onTap: (){
                     print('heeyey');
             Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails()));
              },
                          child: WishListProductCard(
                name:'Nestle',
                imgUrl: 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
                price: '230',
                qty: '1 KG',
                wishList: true,
              ),
            );
      }
    );
  }
}