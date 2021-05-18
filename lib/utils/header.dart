import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header {
  static Widget appBar(String name,Widget widget,bool center) {
    return AppBar(
      actions: [
       if(widget!=null)
          widget
       ],
        backgroundColor: Colors.transparent,
        centerTitle: center,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          name,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ));
  }
}
