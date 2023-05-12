import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

myNavigator(Widget page, BuildContext context) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}
