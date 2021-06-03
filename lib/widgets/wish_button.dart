import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:user_app/services/constants.dart';

class WishButton extends StatefulWidget {
  final bool isSelected;
  final double size;
  final ValueChanged<bool> onChanged;
  WishButton({Key key, this.isSelected = false, this.onChanged, this.size})
      : super(key: key);

  @override
  _WishButtonState createState() => _WishButtonState();
}

class _WishButtonState extends State<WishButton> {
  bool isLiked = false;

  @override
  void initState() {
    setState(() {
      isLiked = widget.isSelected;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        child: GestureDetector(
          child: isLiked != false
              ? Icon(
                  AntDesign.heart, // COLOR FILLED HEART
                  size: widget.size ?? 20,
                  color: Constants.wishListSelectedColor,
                )
              : Icon(
                  AntDesign.hearto, // OUTLINED HEART
                  size: widget.size ?? 20,
                  color: Constants.headingTextBlack,
                ),
          onTap: () {
            isLiked = isLiked == false;

            setState(() {});
            widget.onChanged(isLiked);
          },
        ),
      ),
    );
  }
}
