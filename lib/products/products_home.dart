import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/products/product_list.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/product_card.dart';

class ProductsHome extends StatefulWidget {
  @override
  _ProductsHomeState createState() => _ProductsHomeState();
}

class _ProductsHomeState extends State<ProductsHome> {
  bool down = true;
  List featured, sale, categories;
  List banners = [
    Constants.offerImage,
    Constants.only4uImage,
    Constants.offerImage
  ];

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
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    ProductApiHandler productHandler = new ProductApiHandler();
    var response = await productHandler.getHomeProducts();
    setState(() {
      featured = response[1]['featured'];
      sale = response[1]['sale'];
      categories = response[1]['categories'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: (featured == null || sale == null || categories == null)
            ? Container(
                height: size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          down = !down;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  down ? 'Show Categories' : 'Show Less',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: size.height / 58,
                                      color: Colors.black),
                                ),
                              ),
                              Icon(
                                  down
                                      ? AntDesign.caretdown
                                      : AntDesign.caretup,
                                  size: 14,
                                  color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: size.height / 5.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    autoPlay: true,
                                    enableInfiniteScroll: false,
                                    autoPlayInterval: Duration(seconds: 3),
                                    scrollDirection: Axis.horizontal,
                                    //  pauseAutoPlayOnTouch: Duration(seconds: 5),
                                    initialPage: 0,
                                    height: 150,

                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                  ),
                                  items: banners.map((imgUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: size.width,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
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
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        map<Widget>(banners, (index, url) {
                                      return _current == index
                                          ? Container(
                                              width: 9,
                                              height: 9,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      Constants.buttonBgColor),
                                            )
                                          : Container(
                                              width: 9,
                                              height: 9,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Constants
                                                          .buttonBgColor)),
                                            );
                                    })),
                              ),
                              (featured.length > 0)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Red Ginzr, Featured deals',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.height / 60),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductList(
                                                                title:
                                                                    "Featured Products",
                                                                type:
                                                                    "featured")));
                                              },
                                              child: Text("View all >",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          size.height / 60,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (featured.length > 0)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Container(
                                        height: 220,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: featured.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var productInfo = featured[index]
                                                  ['product_info'];
                                              var productImages =
                                                  featured[index]
                                                      ['product_images'];
                                              return ProductCard(
                                                qty:
                                                    "${productInfo[0]['quantity']} ${productInfo[0]['metrics']}",
                                                wishList: false,
                                                imgUrl: productImages[0]
                                                        ['image_url']
                                                    .toString()
                                                    .replaceAll(
                                                        'http://', 'https://'),
                                                name:
                                                    '${productInfo[0]['product_name']}',
                                                price: '120',
                                              );
                                            }),
                                      ),
                                    )
                                  : SizedBox(),
                              (sale.length > 0)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Items on Sale',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: size.height / 60),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductList(
                                                                title:
                                                                    "Featured Products",
                                                                type: "sale")));
                                              },
                                              child: Text("View all >",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          size.height / 60,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              (sale.length > 0)
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Container(
                                        height: 220,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: sale.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var productInfo =
                                                  sale[index]['product_info'];
                                              var productImages =
                                                  sale[index]['product_images'];
                                              return ProductCard(
                                                qty:
                                                    "${productInfo[0]['quantity']} ${productInfo[0]['metrics']}",
                                                wishList: false,
                                                imgUrl: (productImages
                                                        .isNotEmpty)
                                                    ? productImages[0]
                                                            ['image_url']
                                                        .toString()
                                                        .replaceAll('http://',
                                                            'https://')
                                                    : "https://dummyimage.com/360x360.png/5fa2dd/ffffff",
                                                name:
                                                    '${productInfo[0]['product_name']}',
                                                price: productInfo[0]
                                                            ['offer_price'] !=
                                                        '0'
                                                    ? productInfo[0]
                                                        ['offer_price']
                                                    : productInfo[0]['price'],
                                              );
                                            }),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          )),
                          //  if(!down)
                          //  Container(height: MediaQuery.of(context).size.height+100,color: Colors.black38),
                          if (!down)
                            Container(
                              height: MediaQuery.of(context).size.height + 100,
                              color: Colors.black38,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child: GridView.count(
                                        padding: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        crossAxisCount: 4,
                                        shrinkWrap: true,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 8.0,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: List.generate(
                                            categories.length, (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductList(
                                                              title: categories[
                                                                      index]
                                                                  ["category"],
                                                              type: "category",
                                                              categoryId:
                                                                  categories[
                                                                          index]
                                                                      ["id"])));
                                            },
                                            child: Container(
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  CachedNetworkImage(
                                                    imageUrl: categories[index]
                                                        ["image"],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 70,
                                                      height: 70,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      height: 100,
                                                      child: Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 20,
                                                      child: Text(
                                                          "${categories[index]["category"]}"),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                                  ),
                                ],
                              ),
                            )
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
