import 'package:flutter/material.dart';
import 'package:user_app/dashboard/dashboard_tabs.dart';
import 'package:user_app/main.dart';
import 'package:user_app/widgets/text_widget.dart';

class Header {
  static Widget appBar(String name, Widget widget, bool center,
      BuildContext context, bool showCart) {
    return AppBar(
      actions: [
        if (widget != null) widget,
        if (showCart)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DashboardTabs(
                                      page: 'cart',
                                    )));
                      },
                      child: Icon(Icons.shopping_bag_outlined, size: 22)),
                  Container(
                      decoration: BoxDecoration(
                          // color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 5.0),
                        child: Text(
                          "${MyApp.cartList.length > 0 ? MyApp.cartList['products'].length + MyApp.cartList['packs'].length : 0}",
                          // style: TextStyle(color: Colors.white)
                        ),
                      ))
                ],
              )),
      ],
      backgroundColor: Colors.transparent,
      centerTitle: center,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: TextWidget("$name", textType: "heading"),
    );
  }
}

// class DashboardTabs {
// }
