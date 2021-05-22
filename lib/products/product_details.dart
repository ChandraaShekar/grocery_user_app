import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/counter.dart';
import 'package:user_app/widgets/primaryButton.dart';
import 'package:user_app/widgets/product_card.dart';
import 'package:user_app/widgets/wish_button.dart';

class ProductDetails extends StatefulWidget {
  final String productId;

  const ProductDetails({Key key, this.productId}) : super(key: key);
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String code = '1000789';
  String country = 'India';
  String company = 'Jubliant Foods';
  List images = [
    'https://www.thespruceeats.com/thmb/QxqFC_PtR8hR7I9-tsCB3S9b7R8=/2128x1409/filters:fill(auto,1)/GettyImages-116360266-57fa9c005f9b586c357e92cd.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg',
    'https://4.imimg.com/data4/CW/MF/MY-35654338/fresh-red-onions-500x500.jpg'
  ];
  List recomendations = [];
  var productInfo;
  bool isLiked = false;
  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    ProductApiHandler productHandler = new ProductApiHandler();
    List resp = await productHandler.getProductFromId(widget.productId);
    print(resp);
    setState(() {
      productInfo = resp[1];
      if (productInfo['product_images'].length > 0) {
        images.clear();
        productInfo['product_images'].forEach((val) {
          images.add(
              val['image_url'].toString().replaceAll("http://", "https://"));
        });
      }
    });
    print("Category: ${productInfo['product_info'][0]['category_id']}");
    List categoryProducts = await productHandler.getCategoryProducts(
        productInfo['product_info'][0]['category_id'].toString());
    print(categoryProducts);
    if (categoryProducts[0] == 200) {
      setState(() {
        recomendations = categoryProducts[1];
        recomendations.shuffle();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Header.appBar(
          'Product Details',
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                WishButton(
                  isSelected: isLiked,
                  onChanged: (val) {
                    print(val);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.shopping_cart_outlined, size: 18)),
                ),
              ],
            ),
          ),
          true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: (productInfo == null)
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${productInfo['product_info'][0]['product_name']}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              Constants.rupeeSymbol +
                                  " ${productInfo['product_info'][0]['offer_price'] != '0' ? productInfo['product_info'][0]['offer_price'] : productInfo['product_info'][0]['price']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 15),
                            productInfo['product_info'][0]['offer_price'] != '0'
                                ? Container(
                                    child: Row(
                                    children: [
                                      Text('MRP: ' + Constants.rupeeSymbol),
                                      Text(
                                          "${productInfo['product_info'][0]['price']}",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Constants.kMain2,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 7.0),
                                          child: Text(
                                            "${(int.parse(productInfo['product_info'][0]['offer_price']) / int.parse(productInfo['product_info'][0]['price']) * 100).toInt()}% OFF",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                                : SizedBox(),
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Constants.qtyBgColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 4.0),
                                child: Text(
                                  "${productInfo['product_info'][0]['quantity']} ${productInfo['product_info'][0]['metrics']}",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      CarouselSlider(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: false,
                          enableInfiniteScroll: false,
                          autoPlayInterval: Duration(seconds: 3),
                          scrollDirection: Axis.horizontal,
                          initialPage: 0,
                          height: 200,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: images.map((imgUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: size.width,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      imgUrl,
                                      width: size.width,
                                      fit: BoxFit.contain,
                                    )),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: map<Widget>(images, (index, url) {
                              return _current == index
                                  ? Container(
                                      width: 9,
                                      height: 9,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Constants.buttonBgColor),
                                    )
                                  : Container(
                                      width: 9,
                                      height: 9,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Constants.buttonBgColor)),
                                    );
                            })),
                      ),
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Quantity',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.grey),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CounterBtn(
                                  incDecheight: 28,
                                  incDecwidth: 28,
                                  leftCounterColor: Constants.buttonBgColor,
                                  rightCounterColor: Constants.buttonBgColor,
                                  incPressed: () {},
                                  decPressed: () {},
                                  text: '0',
                                  widgetWidth: 140,
                                )),
                            SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: PrimaryCustomButton(title: "ADD TO CART"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                    "${productInfo['product_info'][0]['product_description']}"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Recommended Products',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey),
                              ),
                            ),
                            Container(
                              height: 200,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recomendations.length > 5
                                      ? 5
                                      : recomendations.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var pI = recomendations[index]
                                        ['product_info'][0];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        productId: recomendations[
                                                                    index]
                                                                ['product_info']
                                                            [
                                                            0]['product_id'])));
                                      },
                                      child: ProductCard(
                                        qty:
                                            '${pI['quantity']} ${pI['metrics']}',
                                        wishList: false,
                                        imgUrl: recomendations[index]
                                                        ['product_images']
                                                    .length ==
                                                0
                                            ? "https://upload.wikimedia.org/wikipedia/commons/8/89/Tomato_je.jpg"
                                            : recomendations[index]
                                                        ['product_images'][0]
                                                    ['image_url']
                                                .toString()
                                                .replaceAll(
                                                    "http://", "https://"),
                                        name: '${pI['product_name']}',
                                        price:
                                            '${pI['offer_price'] != '0' ? pI['offer_price'] : pI['price']}',
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
