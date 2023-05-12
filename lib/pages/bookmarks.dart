import 'package:cal/models/post_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../models/question_model.dart';
import '../models/scale_model.dart';
import '../models/user_model.dart';

class Bookmarks extends StatefulWidget {
  const Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  PageController pageController = PageController(initialPage: 0);
  bool isForYou = true;

  PreferredSize appBar() {
    return PreferredSize(
        preferredSize: Size(Get.width, 90),
        child: Column(
          children: [
            CupertinoNavigationBar(
              previousPageTitle: 'Library',
              middle: const Text(
                'Bookmarks',
                style: TextStyle(color: Colors.white),
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
                              'Articles',
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
                                    width: 70,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 70,
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
                              'Scales',
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
                                    width: 65,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                  )
                                : Container(
                                    height: 4.3,
                                    width: 65,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: Colors.black,
        body: PageView.builder(
            controller: pageController,
            itemBuilder: (context, index) {
              List screens = [
                articles(),
                scales(),
              ];
              return screens[index];
            }));
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> scales() {
    return StreamBuilder(
        stream: bookmarkRef
            .doc(uid)
            .collection('bookmarks')
            .where('scaleId', isNotEqualTo: '')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: scalesRef
                      .doc(snapshot.data!.docs[index]['scaleId'])
                      .snapshots(),
                  builder: (context, scaleSnapshot) {
                    if (!scaleSnapshot.hasData) {
                      return loading();
                    }
                    final doc = scaleSnapshot.data!.data()!;
                    return Scale(
                      writerId: doc['writerId'],
                      content: doc['content'],
                      likes: doc['likes'],
                      timestamp: doc['timestamp'],
                      scaleId: doc['scaleId'],
                      mediaUrl: doc['mediaUrl'],
                      postId: doc['postId'],
                      attachedScaleId: doc['attachedScaleId'],
                      isReply: doc['isReply'],         repostedScaleId: doc['repostedScaleId'],
                      dont: true,
                      evenMe: true,
                      currentScreen: Bookmarks,
                    );
                  });
            },
          );
        });
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> articles() {
    return StreamBuilder(
        stream: bookmarkRef
            .doc(uid)
            .collection('bookmarks')
            .where('postId', isNotEqualTo: '')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return StreamBuilder(
                  stream: exploreRef
                      .doc(snapshot.data!.docs[index]['postId'])
                      .snapshots(),
                  builder: (context, postSnapshot) {
                    if (!postSnapshot.hasData) {
                      return loading();
                    }
                    final doc = postSnapshot.data!.data()!;
                    return PostMobile(
                      writerId: doc['writerId'],
                      content: doc['content'],
                      likes: doc['likes'],
                      timestamp: doc['timestamp'],
                      postId: doc['postId'],
                      thumbnailUrl: doc['thumbnailUrl'],
                      title: doc['title'],
                      views: doc['views'],
                    );
                  });
            },
          );
        });
  }
}
