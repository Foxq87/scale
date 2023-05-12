import 'package:cal/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoNavigationBar navBar(title, previousPageTitle,
    {leading, backgroundColor, elevation, trailing}) {
  return CupertinoNavigationBar(
    trailing: trailing ?? trailing,
    leading: leading,
    previousPageTitle: previousPageTitle,
    border: elevation == null || elevation
        ? const Border(
            bottom: BorderSide(color: CupertinoColors.systemGrey, width: 0.25))
        : Border(),
    middle: Text(
      title,
      style: TextStyle(color: title == "cal" ? kThemeColor : Colors.white),
    ),
    backgroundColor: backgroundColor ??
        const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
  );
}
