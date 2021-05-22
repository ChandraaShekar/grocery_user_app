import 'package:flutter/material.dart';
import 'package:user_app/api/wishlistapi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/widgets/wishlist_product_card.dart';

class WishListProducts extends StatefulWidget {
  @override
  _WishListProductsState createState() => _WishListProductsState();
}

class _WishListProductsState extends State<WishListProducts> {
  List products;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    WishlistApiHandler wishlistHandler = new WishlistApiHandler();
    List resp = await wishlistHandler.getWishlist();
    print(resp);
    if (resp[0] == 200) {
      setState(() {
        products = resp[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (products == null)
        ? Center(child: CircularProgressIndicator())
        : (products.length == 0)
            ? Center(child: Text("Your wish list is Empty."))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  productId: products[index]['product_info'][0]
                                      ['product_id'])));
                    },
                    child: WishListProductCard(
                      name: products[index]['product_info'][0]['product_name'],
                      imgUrl: (products[index]['product_images'].isNotEmpty)
                          ? products[index]['product_images'][0]['image_url']
                              .toString()
                              .replaceAll("http://", "https://")
                          : "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg",
                      price:
                          "${(products[index]['product_info'][0]['offer_price'] != '0') ? products[index]['product_info'][0]['offer_price'] : products[index]['product_info'][0]['price']}",
                      qty:
                          "${products[index]['product_info'][0]['quantity']} ${products[index]['product_info'][0]['metrics']}",
                      wishList: true,
                    ),
                  );
                });
  }
}
