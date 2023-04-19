import 'dart:math';

import 'package:cal/constants.dart';
import 'package:cal/models/post_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/account.dart';
import 'package:cal/pages/desktop_bookmarks_tab.dart';
import 'package:cal/pages/desktop_lists_tab.dart';
import 'package:cal/pages/desktop_messages_tab.dart';
import 'package:cal/pages/desktop_newpost_tab.dart';
import 'package:cal/pages/desktop_search_tab.dart';
import 'package:cal/pages/desktop_topics_tab.dart';

import 'package:cal/pages/home.dart';
import 'package:cal/state_managers/data.dart';
import 'package:cal/widgets/drawer.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import 'create.dart';
import 'desktop_home_tab.dart';
import 'desktop_profile_tab.dart';

class DesktopFirstPage extends StatefulWidget {
  const DesktopFirstPage({super.key});

  @override
  State<DesktopFirstPage> createState() => _DesktopFirstPageState();
}

class _DesktopFirstPageState extends State<DesktopFirstPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int currentIndex = 0;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    List routes = Provider.of<Data>(context).route;
    List screens = [
      DesktopHomeTab(
        isExpanded: isExpanded,
      ),
      DesktopTopicsTab(),
      DesktopBookmarksTab(),
      DesktopListsTab(),
      DesktopNewPostTab(),
      DesktopSearchTab(),
      DestktopMessagesTab(),
      DesktopProfileTab(),
    ];
    double systemWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isExpanded == false
              ? Container(
                  width: 80,
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[900]!),
                      color: kDarkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                // personalWritings.get().then((doc) {
                                //   for (var element in doc.docs) {
                                //     if (element.id != uid) {
                                //       personalWritings
                                //           .doc(uid)
                                //           .collection('writings')
                                //           .doc(element.id)
                                //           .set({
                                //         "postId": element.data()['postId'],
                                //         "title": element.data()["title"],
                                //         "content": element.data()['content'],
                                //         "priority": element.data()['priority'],
                                //         "priorityId":
                                //             element.data()['priorityId'],
                                //         "thumbnailUrl":
                                //             element.data()['thumbnailUrl'],
                                //         "timestamp":
                                //             element.data()['timestamp'],
                                //         "views": element.data()['views'],
                                //         "writerId": element.data()['writerId'],
                                //       });
                                //     }
                                //   }
                                // });
                                // FirebaseAuth.instance.signOut();
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15),
                                child: Text(
                                  'cal',
                                  style: TextStyle(
                                      color: kThemeColor, fontSize: 22),
                                ),
                              ),
                            ),
                            sideBar()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Icon(
                                CupertinoIcons.forward,
                                color: kThemeColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              }),
                        ),
                      ]),
                )
              : Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[900]!),
                      color: kDarkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: ListView(
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Container(
                            child: Text(
                              'cal',
                              style:
                                  TextStyle(color: kThemeColor, fontSize: 22),
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: sideBarList.length,
                          itemBuilder: (context, index) {
                            return sideBarItemExpanded(sideBarList[index][0],
                                sideBarList[index][1], index);
                          },
                        ),
                        myDivider(),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Following',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return followingUser();
                          },
                        )
                      ],
                    ),
                  ),
                ),
          Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 7, 7, 7),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey[900]!),
                    color: kDarkGreyColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey[900]!))),
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.arrow_left_circle,
                                  color: kThemeColor,
                                ),
                                onPressed: () {
                                  Provider.of<Data>(context, listen: false)
                                      .back();
                                }),
                            CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(
                                  CupertinoIcons.arrow_right_circle,
                                  color: kThemeColor,
                                ),
                                onPressed: () {
                                  Provider.of<Data>(context, listen: false)
                                      .back();
                                }),
                          ],
                        ),
                        FutureBuilder(
                            future: usersRef.doc(uid).get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return loading();
                              }
                              UserModel user =
                                  UserModel.fromDocument(snapshot.data!);
                              return CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Provider.of<Data>(context, listen: false)
                                      .setScreen(Account(
                                    profileId: user.id,
                                    previousPageTitle: 'Home',
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Colors.grey[800]!)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          user.imageUrl,
                                          height: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        user.username,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Provider.of<Data>(context).isHome
                              ? screens[currentIndex]
                              : routes[Provider.of<Data>(context).routeIndex],
                        ]),
                  )
                ]),
              )),
          Expanded(
              child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 7, 0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[900]!),
                      color: kDarkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Icon(
                                      CupertinoIcons.clear,
                                      color: kThemeColor,
                                    ),
                                    onPressed: () {
                                      Provider.of<Data>(context, listen: false)
                                          .back();
                                    }),
                                Text(
                                  'Brain',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                          stream: personalWritings
                              .doc(uid)
                              .collection('writings')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return loading();
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return idea(
                                    snapshot.data!.docs[index]['priority'],
                                    snapshot.data!.docs[index]['postId'],
                                    snapshot.data!.docs[index]['title'],
                                    snapshot.data!.docs[index]['content'],
                                    snapshot.data!.docs[index]['thumbnailUrl'],
                                    snapshot.data!.docs[index]['writerId'],
                                    snapshot.data!.docs[index]['timestamp'],
                                    snapshot.data!.docs[index]['views']);
                              },
                            );
                          })
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 7, 7, 7),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey[900]!),
                      color: kDarkGreyColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Icon(
                                      CupertinoIcons.clear,
                                      color: kThemeColor,
                                    ),
                                    onPressed: () {
                                      Provider.of<Data>(context, listen: false)
                                          .back();
                                    }),
                                Text(
                                  'Messages',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  idea(String priority, String id, String title, String content,
      String thumbnailUrl, String writerId, Timestamp timestamp, List views) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Provider.of<Data>(context, listen: false).setScreen(PostDetailsDesktop(
            postId: id,
            title: title,
            thumbnailUrl: thumbnailUrl,
            content: content,
            writerId: writerId,
            timestamp: timestamp,
            views: views));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.grey[900]!),
            borderRadius: BorderRadius.circular(13)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 19),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  'Priority',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1, color: priorityColor(priority))),
                  child: Text(
                    priority,
                    style: TextStyle(color: priorityColor(priority)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  sideBar() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: sideBarList.length,
      itemBuilder: (context, index) {
        return sideBarItem(sideBarList[index][0], sideBarList[index][1], index);
      },
    );
  }

  List sideBarList = [
    [UniconsLine.home_alt, 'Home'],
    [CupertinoIcons.bubble_left, 'Topics'],
    [CupertinoIcons.bookmark, 'Bookmarks'],
    [CupertinoIcons.square_list, 'Lists'],
    [CupertinoIcons.pen, 'New Post'],
    [CupertinoIcons.search, 'Search'],
    [CupertinoIcons.mail, 'Messages'],
  ];

  followingUser() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/userpp.jpg',
                  height: 30,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'John Doe',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
          CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.person_badge_minus,
                color: kThemeColor,
                size: 20,
              ),
              onPressed: () {}),
        ],
      ),
    );
  }

  Container myDivider() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 1,
      width: 100,
      color: Colors.grey[800],
    );
  }

  CupertinoButton sideBarItemExpanded(IconData icon, String text, int index) {
    bool isActive = false;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            border: currentIndex == index
                ? Border.all(width: 1.5, color: kThemeColor)
                : Border.all(width: 1.5, color: Colors.transparent),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  CupertinoButton sideBarItem(IconData icon, String text, int index) {
    bool isActive = false;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Tooltip(
        message: text,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: currentIndex == index
                  ? Border.all(width: 1.5, color: kThemeColor)
                  : Border.all(width: 1.5, color: Colors.transparent),
              borderRadius: BorderRadius.circular(15)),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
