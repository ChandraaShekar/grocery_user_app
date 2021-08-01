import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/api/searchApi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';
import 'package:user_app/widgets/text_widget.dart';

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  SearchApiHandler searchHandler = new SearchApiHandler();
  List searchResults = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Container(
          alignment: Alignment.centerLeft,
          color: Colors.transparent,
          child: TextField(
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter product name',
                  hintStyle: TextStyle(color: Colors.grey)),
              onChanged: (val) async {
                if (val == "") {
                  setState(() {
                    searchResults.clear();
                  });
                }
                log(val);
                var resp = await searchHandler.searchWithWord({
                  "lat": "17.43220004743208",
                  "lng": "78.42959340000002",
                  "search_term": "$val",
                });
                log("${resp[1]}");
                if (resp[0] == 200) {
                  log("success");
                  setState(() {
                    searchResults = resp[1];
                  });
                }
              }),
        ),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
      ),
      body: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: SizedBox(width: MediaQuery.of(context).size.width / 10),
              title: Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      "${searchResults[index]['product_name']}",
                      textType: "title",
                    ),
                  ),
                  SizedBox(width: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: Constants.qtyBgColor,
                    child: TextWidget(
                      "${searchResults[index]['quantity']} ${searchResults[index]['metrics']}",
                      textType: "label",
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetails(
                            productId: searchResults[index]['product_id'])));
              },
            );
          }),
    );
  }
}
