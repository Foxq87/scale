// ignore_for_file: void_checks

import 'package:cal/models/question_model.dart';
import 'package:cal/models/scale_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/navigate_to.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String content = '';
  String imageUrl = '';
  void Function()? onButtonPressed;
  PageController pageController = PageController();
  bool isForYou = true;
  @override
  Widget build(BuildContext context) {
    List screens(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
      return [
        ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            usersRef.doc(snapshot.data!.docs[index]['uid']).get().then((doc) {
              if (doc.exists) {
                switch (snapshot.data!.docs[index]['type']) {
                  case "scaleLike":
                    setState(() {
                      content = "${doc.data()!['username']} liked your scale!";
                      imageUrl = doc.data()!['imageUrl'];
                      onButtonPressed = () {
                        scalesRef
                            .doc(snapshot.data!.docs[index]['scaleId'])
                            .get()
                            .then(
                          (doc) {
                            myNavigator(
                              ScaleDetails(
                                scaleId: doc.data()!['scaleId'],
                                writerId: doc.data()!['writerId'],
                                content: doc.data()!['content'],
                                likes: doc.data()!['likes'],
                                timestamp: doc.data()!['timestamp'],
                                mediaUrl: doc.data()!['mediaUrl'],
                                postId: doc.data()!['postId'],
                                attachedScaleId: doc.data()!['attachedScaleId'],
                                repostedScaleId: doc.data()!['repostedScaleId'],
                                isReply: doc.data()!['isReply'],
                                currentScreen: Activity,
                              ),
                              context,
                            );
                          },
                        );
                      };
                    });

                    break;
                  case "scaleComment":
                    setState(() {
                      content =
                          "${doc.data()!['username']} commented on your scale!";
                      imageUrl = doc.data()!['imageUrl'];
                      onButtonPressed = () {
                        scalesRef
                            .doc(snapshot.data!.docs[index]['scaleId'])
                            .get()
                            .then(
                          (doc) {
                            myNavigator(
                              ScaleDetails(
                                scaleId: doc.data()!['scaleId'],
                                writerId: doc.data()!['writerId'],
                                content: doc.data()!['content'],
                                likes: doc.data()!['likes'],
                                timestamp: doc.data()!['timestamp'],
                                mediaUrl: doc.data()!['mediaUrl'],
                                postId: doc.data()!['postId'],
                                attachedScaleId: doc.data()!['attachedScaleId'],
                                repostedScaleId: doc.data()!['repostedScaleId'],
                                isReply: doc.data()!['isReply'],
                                currentScreen: Activity,
                              ),
                              context,
                            );
                          },
                        );
                      };
                    });

                    break;
                  case "follow":
                    break;
                  default:
                }
              } else {
                print('doee');
              }
            });

            return CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onButtonPressed,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: kDarkGreyColor,
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Colors.grey[900]!))),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      content,
                      style: const TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          CupertinoIcons.clear,
                          size: 18,
                          color: Colors.grey[800],
                        ),
                        onPressed: () {
                          notificationsRef
                              .doc(uid)
                              .collection('activities')
                              .doc(snapshot.data!.docs[index]['notificationId'])
                              .delete();
                        })
                  ],
                ),
              ),
            );
          },
        ),
        ListView(),
      ];
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBar(),
      body: FutureBuilder(
          future: notificationsRef.doc(uid).collection('activities').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }

            // switch (expression) {
            //   case value:

            //     break;
            //   default:
            // }

            return PageView.builder(
              itemCount: screens(snapshot).length,
              controller: pageController,
              itemBuilder: (context, index) {
                return screens(snapshot)[index];
              },
            );
          }),
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
