import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_app/products/product_list.dart';

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
      height: size.height / 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: size.height / 60),
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
                  child: Text("View all >",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.height / 60,
                          fontWeight: FontWeight.w600)),
                )
              ],
            ),
            Container(
              color: Colors.white,
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
                            Expanded(
                              child: Container(
                                child: Text(
                                    "${widget.categoriesList[index]["category"]}"),
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
