import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constants.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  PageController pageController = PageController();
  bool isForYou = true;
  @override
  Widget build(BuildContext context) {
    List screens = [
      ListView(),
      ListView(),
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      body: PageView.builder(
        controller: pageController,
        itemBuilder: (context, index) {
          return screens[index];
        },
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
        preferredSize: Size(Get.width, 90),
        child: Column(
          children: [
            CupertinoNavigationBar(
              middle: const Text(
                'Activity',
                style: TextStyle(color: kThemeColor),
              ),
              backgroundColor:
                  const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 2, color: Colors.grey[900]!)),
                    color:
                        const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            isForYou = true;

                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              'All',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            isForYou == false
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 40,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 40,
                                  )
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            isForYou = false;
                            pageController.animateToPage(1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Column(
                          children: [
                            Expanded(child: Container()),
                            const Text(
                              'Mentioned',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            isForYou
                                ? Container(
                                    height: 4.3,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                  )
                                : Container(
                                    height: 4.3,
                                    width: 90,
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                  )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
