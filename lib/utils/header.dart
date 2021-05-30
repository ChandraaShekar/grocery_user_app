import 'package:flutter/material.dart';
import 'package:user_app/widgets/text_widget.dart';

class Header {
  static Widget appBar(String name, Widget widget, bool center) {
    return AppBar(
      actions: [if (widget != null) widget],
      backgroundColor: Colors.transparent,
      centerTitle: center,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      title: TextWidget("$name", textType: "heading"),
    );
  }
}
