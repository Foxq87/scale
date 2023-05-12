import 'package:cal/constants.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unicons/unicons.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar('Search', '', elevation: true,
          leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              }),
          backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey[900]!,
                        ),
                        shape: BoxShape.circle),
                    child: Center(
                      child: const Icon(
                        CupertinoIcons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: CupertinoSearchTextField(
                      style: TextStyle(color: Colors.white),
                      prefixIcon: const SizedBox(),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey[900]!,
                          ),
                          borderRadius: kCircleBorderRadius),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[900],
          )
        ],
      ),
    );
  }
}
