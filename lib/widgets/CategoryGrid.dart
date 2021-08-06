import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_app/products/product_list.dart';
import 'package:user_app/widgets/text_widget.dart';

class CategoryGrid extends StatefulWidget {
  final List categoriesList;
  final int totalLength;
  CategoryGrid({Key key, this.categoriesList, this.totalLength = 8})
      : super(key: key);
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Column(
          children: [
            SizedBox(height: 5),
            Container(
              // color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                  padding: EdgeInsets.only(top: 0, bottom: 10),
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 25.0,
                  childAspectRatio: .83,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                      (widget.totalLength == 0
                          ? widget.categoriesList.length
                          : widget.totalLength), (index) {
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
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
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300],
                                  highlightColor: Colors.white,
                                  child: Container(
                                    width: size.width / 5.5,
                                    height: size.width / 5.5,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Center(
                                child: Container(
                                  child: TextWidget(
                                      "${widget.categoriesList[index]["category"]}",
                                      textType: "subtitle-black"),
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
