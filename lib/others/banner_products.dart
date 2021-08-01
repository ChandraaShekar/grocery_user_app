import 'package:flutter/material.dart';
import 'package:user_app/utils/header.dart';

class BannerProducts extends StatefulWidget {
  final Map content;
  BannerProducts({Key key, this.content}) : super(key: key);

  @override
  _BannerProductsState createState() => _BannerProductsState();
}

class _BannerProductsState extends State<BannerProducts> {
  List items = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    print(widget.content['content']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header.appBar("${widget.content['banner_name']}", null, true),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, x) {
                return ListTile(
                  title: Text("$x"),
                );
              }),
        ));
  }
}
