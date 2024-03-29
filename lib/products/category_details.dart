import 'package:flutter/material.dart';
import 'package:user_app/api/productapi.dart';
import 'package:user_app/main.dart';
import 'package:user_app/utils/header.dart';
import 'package:user_app/widgets/CategoryGrid.dart';

class AllCatgories extends StatefulWidget {
  @override
  _AllCatgoriesState createState() => _AllCatgoriesState();
}

class _AllCatgoriesState extends State<AllCatgories> {
  List categories = [];
  ProductApiHandler productHandler = new ProductApiHandler();

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    var resp = await productHandler
        .getAllCategories({"lat": MyApp.lat, "lng": MyApp.lng});
    print({"lat": MyApp.lat, "lng": MyApp.lng});
    if (resp[0] == 200) {
      setState(() {
        categories = resp[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar("Categories", null, true, context, true),
        body: (categories.length == 0)
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: CategoryGrid(
                  categoriesList: categories,
                  totalLength: 0,
                ),
              ));
  }
}
