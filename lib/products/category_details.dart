import 'package:flutter/material.dart';
import 'package:user_app/api/productapi.dart';
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
    var resp = await productHandler.getAllCategories();
    if (resp[0] == 200) {
      setState(() {
        categories = resp[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar("Categories", null, true),
        body: (categories.length == 0)
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: CategoryGrid(categoriesList: categories),
              ));
  }
}
