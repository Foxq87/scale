import 'package:cal/constants.dart';
import 'package:cal/widgets/navigate_to.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'bookmarks.dart';

class Library extends StatefulWidget {
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            trailing: CupertinoButton(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kDarkGreyColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey[900]!,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {}),
            padding: EdgeInsetsDirectional.zero,
            border: innerBoxIsScrolled
                ? const Border(
                    bottom: BorderSide(
                        color: CupertinoColors.systemGrey, width: 0.25))
                : const Border(bottom: BorderSide()),
            backgroundColor: innerBoxIsScrolled
                ? const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9)
                : const Color.fromARGB(255, 3, 3, 3),
            automaticallyImplyLeading: false,
            previousPageTitle: 'Siparişler',
            largeTitle: const Text(
              'Library',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                myNavigator(Bookmarks(), context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: greenColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        UniconsLine.bookmark,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Bookmarks',
                      style: TextStyle(color: Colors.white, fontSize: 19),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      CupertinoIcons.forward,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
