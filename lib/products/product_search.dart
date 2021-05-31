import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/api/searchApi.dart';
import 'package:user_app/products/product_details.dart';
import 'package:user_app/services/constants.dart';

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
                var resp = await searchHandler.searchWithWord(val);
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
                    child: Text(
                      "${searchResults[index]['product_name']}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: Constants.qtyBgColor,
                    child: Text(
                        "${searchResults[index]['quantity']} ${searchResults[index]['metrics']}"),
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
