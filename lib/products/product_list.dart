import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/cartApi.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:shimmer/shimmer.dart';

import '../main.dart';

class ProductList extends StatefulWidget {
  final String title;
  final String type;
  final String categoryId;
  ProductList({
    Key key,
    this.title,
    this.type,
    this.categoryId,
  }) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List productList;

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    ProductApiHandler productHandler = new ProductApiHandler(body: {
      "lat": "${MyApp.lat}",
      "lng": "${MyApp.lng}",
      "type": "${widget.type}"
    });
    if (widget.type.isNotEmpty) {
      if (widget.type != "category") {
        List resp = await productHandler.getFeaturedProducts();

        if (resp[0] == 200) {
          setState(() {
            productList = resp[1];
          });
        }
      } else {
        List resp = await productHandler.getCategoryProducts(widget.categoryId);
        print("category response $resp");
        if (resp[0] == 200) {
          setState(() {
            productList = resp[1];
          });
        }
      }
    } else {
      setState(() {
        productList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: Header.appBar(widget.title ?? "Product List", null, true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height * 0.9,
              child: productList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: productList.length,
                      itemBuilder: (_, i) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        productId: productList[i]
                                                ['product_info'][0]
                                            ['product_id'])));
                          },
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: (productList[i]
                                                  ['product_images']
                                              .isNotEmpty)
                                          ? productList[i]['product_images'][0]
                                                  ['image_url']
                                              .toString()
                                              .replaceAll("http://", "https://")
                                          : "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: size.width / 3.4,
                                        height: 105,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[300],
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: size.width / 3.4,
                                          height: 105,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Container(
                                        height: 100,
                                        width: size.width / 1.8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 40,
                                              child: Text(
                                                "${productList[i]['product_info'][0]['product_name']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: size.height / 56),
                                              ),
                                            ),
                                            Container(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8.0),
                                                  child: Text(
                                                      "${productList[i]['product_info'][0]['quantity']} ${productList[i]['product_info'][0]['metrics']}"),
                                                ),
                                                color: Constants.qtyBgColor),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "Rs. ${productList[i]['product_info'][0]['price']}")
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      child: Container(
                                        width: size.width / 4,
                                        height: size.height / 15,
                                        // color: Colors.grey,
                                        child: Icon(Icons.shopping_cart_rounded,
                                            color: Constants.primaryColor),
                                      ),
                                      onTap: () async {
                                        CartApiHandler cartHandler =
                                            new CartApiHandler();
                                        var resp = await cartHandler.addToCart({
                                          "product_pack_id": productList[i]
                                              ['product_info'][0]['product_id'],
                                          "quantity": "1"
                                        });
                                        MyApp.showToast(
                                            resp[1]['message'], context);

                                        List getResp =
                                            await cartHandler.getCart();
                                        setState(() {
                                          MyApp.cartList = getResp[1];
                                        });
                                      },
                                    ))
                              ],
                            ),
                          )),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}
