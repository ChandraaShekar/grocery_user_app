import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/products/product_list.dart';
import 'package:user_app/services/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CategoryGrid extends StatefulWidget {
  final List categoriesList;
  CategoryGrid({Key key, this.categoriesList}) : super(key: key);
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                      color: Constants.greyHeading,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                      fontSize: size.height / 55),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductList(
                                title: "Categories", type: "categories")));
                  },
                  child: Row(
                    children: [
                      Text("View all",
                          style: TextStyle(
                              color: Constants.secondaryTextColor,
                              fontSize: size.height / 55,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w600)),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(
                        FontAwesome.chevron_circle_right,
                        color: Constants.secondaryTextColor,
                        size: size.height / 60,
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 5),
            Container(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 8.0,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      (widget.categoriesList.length > 8
                          ? 8
                          : widget.categoriesList.length), (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductList(
                                    title: widget.categoriesList[index]
                                        ["category"],
                                    type: "category",
                                    categoryId: widget.categoriesList[index]
                                        ["id"])));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              child: CachedNetworkImage(
                                imageUrl: widget.categoriesList[index]["image"],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: size.width / 5.5,
                                  height: size.width / 5.5,
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
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(height: 1),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "${widget.categoriesList[index]["category"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height / 58,
                                    color: Colors.black,
                                  ),
                                ),
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
      ),
    );
  }
}
