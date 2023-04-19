import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

import '../constants.dart';

buildButton(String type) {
  return GestureDetector(
    onTap: () {
      if (type == "back") {
        Get.back();
      }
    },
    child: CircleAvatar(
      radius: 15,
      backgroundColor: kDarkGreyColor,
      child: Center(
          child: Icon(
        type == "back" ? CupertinoIcons.arrow_left : UniconsLine.upload,
        color: Colors.white,
        size: 16,
      )),
    ),
  );
}

class Photo extends StatelessWidget {
  String mediaUrl;
  Photo({super.key, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Image.network(
              mediaUrl,
              width: Get.width,
              height: Get.height,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: 15,
              left: 15,
              child: buildButton("back"),
            ),
            Positioned(
              top: 15,
              right: 15,
              child: buildButton("share"),
            )
          ],
        ),
      ),
    );
  }
}
