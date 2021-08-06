import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';

class BannerProducts extends StatefulWidget {
  final Map content;
  BannerProducts({Key key, this.content}) : super(key: key);

  @override
  _BannerProductsState createState() => _BannerProductsState();
}

class _BannerProductsState extends State<BannerProducts> {
  List items;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    // print(widget.content['content']);
    ProductApiHandler productHandler = new ProductApiHandler();
    List resp = await productHandler
        .getBannerProducts({"products": "${widget.content['content']}"});
    print(resp[1]);
    items = resp[1];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: Header.appBar("${widget.content['banner_name']}", null, true),
        body: (items == null)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, x) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      productId: items[x]['product_id'])));
                        },
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: (items[x]['product_images']
                                        .isNotEmpty)
                                    ? items[x]['product_images'][0]['image_url']
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
                                      fit: BoxFit.cover,
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
                              Expanded(
                                child: Padding(
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
                                            "${items[x]['product_name']}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: size.height / 56),
                                          ),
                                        ),
                                        Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8.0),
                                              child: Text(
                                                  "${items[x]['quantity']} ${items[x]['metrics']}"),
                                            ),
                                            color: Constants.qtyBgColor),
                                        Container(
                                          child: Row(
                                            children: [
                                              Text("Rs. ${items[x]['price']}")
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                      );
                    }),
              ));
  }
}
