import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/utils/primary_button.dart';
import 'package:user_app/widgets/counter.dart';
import 'package:user_app/widgets/product_card.dart';

class ProductDetails extends StatefulWidget {
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

  int _current = 0;
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Header.appBar(
          'Product Details',
          Row(
            children: [
              GestureDetector(onTap: () {}, child: Icon(AntDesign.hearto)),
              IconButton(onPressed: () {}, icon: Icon(Feather.shopping_bag))
            ],
          ),
          true),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Capsicum - Red/Bengalur Mirapakayi/Shimla Mirchi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                child: Row(
                  children: [
                    Text(
                      Constants.rupeeSymbol + " 250",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 15),
                    Text('MRP: ' + Constants.rupeeSymbol),
                    Text("285",
                        style:
                            TextStyle(decoration: TextDecoration.lineThrough)),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Constants.kMain2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "25% OFF",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Constants.qtyBgColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "1 KG",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  autoPlayInterval: Duration(seconds: 3),
                  scrollDirection: Axis.horizontal,
                  //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                  initialPage: 0,
                  height: 120,

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
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              Constants.offerImage,
                              width: size.width,
                              height: 100,
                              fit: BoxFit.cover,
                            )),
                      );
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(images, (index, url) {
                      return _current == index
                          ? Container(
                              width: 9,
                              height: 9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Constants.buttonBgColor),
                            )
                          : Container(
                              width: 9,
                              height: 9,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Constants.buttonBgColor)),
                            );
                    })),
              ),
              Text(
                'Quantity',
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: Colors.grey),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CounterBtn(
                    incDecheight: 40,
                    incDecwidth: 48,
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
              PrimaryButton(
                  backgroundColor: Constants.buttonBgColor,
                  textColor: Colors.white,
                  text: 'ADD TO CART'),
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
                            fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Text(
                            "Organic seedless lemon will enhance the flavor of all your favorite recipes, including chicken, fish, vegetables."),
                      ),
                      Text(
                        'Other Product Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('EAN Code: ' + code),
                      Text('Country of Origin: ' + country),
                      Text('Sourced & Marketed By: ' + company),
                      SizedBox(height: 10),
                      Text(
                        'Recommended Products',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 200,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(
                        qty: '100G',
                        wishList: false,
                        imgUrl: images[index],
                        name: 'Ginger',
                        price: '120',
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
