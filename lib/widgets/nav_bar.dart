import 'package:cal/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoNavigationBar navBar(
  String title,
  String previousPageTitle,
  Widget? leading,
) {
  return CupertinoNavigationBar(
    
    leading: leading,
    previousPageTitle: previousPageTitle,
    border: const Border(
        bottom: BorderSide(color: CupertinoColors.systemGrey, width: 0.25)),
    middle: Text(
      title,
      style: TextStyle(color: title == "cal" ? kThemeColor : Colors.white),
    ),
    backgroundColor: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
  );
}
