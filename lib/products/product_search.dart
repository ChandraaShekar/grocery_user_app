import 'package:flutter/material.dart';
import 'package:user_app/widgets/wishlist_product_card.dart';

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Container(
        alignment: Alignment.centerLeft,
         color: Colors.transparent,
        child: TextField(
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Enter product name',hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed:(){})
      ],
      ),
      body: ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context,int index){
            return WishListProductCard(
              name:'Nestle',
              imgUrl: 'https://www.bigbasket.com/media/uploads/p/m/40023008_2-nestle-nesquik-chocolate-syrup-imported.jpg',
              price: '200',
              qty: '1 KG',
              wishList: false,
            );
      }
      ),
    );
  }
}