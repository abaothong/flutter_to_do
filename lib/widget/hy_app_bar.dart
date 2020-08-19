import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:todo/constant/color_constant.dart';

class HYAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HYAppBar(
    this.title, {
    this.showBackButton = false,
    this.onBackButtonPressed,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback onBackButtonPressed;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    _backButton() {
      if (Platform.isAndroid) {
        return new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => onBackButtonPressed == null
              ? Navigator.pop(context)
              : onBackButtonPressed(),
        );
      } else {
        return new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => onBackButtonPressed == null
              ? Navigator.pop(context)
              : onBackButtonPressed(),
        );
      }
    }

    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(title, style: TextStyle(color: Colors.black)),
      leading: showBackButton ? _backButton() : Container(),
      backgroundColor: ColorConstant.theme,
      centerTitle: Platform.isIOS,
      brightness: Brightness.light,
    );
  }
}
