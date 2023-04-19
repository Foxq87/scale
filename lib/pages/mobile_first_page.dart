import 'package:cal/constants.dart';
import 'package:cal/models/scale_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../widgets/loading.dart';
import 'new_scale.dart';

class MobileFirstPage extends StatefulWidget {
  const MobileFirstPage({super.key});

  @override
  State<MobileFirstPage> createState() => _MobileFirstPageState();
}

class _MobileFirstPageState extends State<MobileFirstPage> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = false;
  List<Widget> scales = [];
  List<Widget> posts = [];
  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot postSnapshot = await exploreRef.get();
    QuerySnapshot scaleSnapshot =
        await scalesRef.orderBy('timestamp', descending: true).get();
    setState(() {
      posts = postSnapshot.docs
          .map((doc) => PostMobile(
                postId: doc['postId'],
                title: doc['title'],
                thumbnailUrl: doc['thumbnailUrl'],
                content: doc['content'],
                writerId: doc['writerId'],
                timestamp: doc['timestamp'],
                views: doc['views'],
                likes: doc['likes'],
              ))
          .toList();

      scales = scaleSnapshot.docs
          .map((doc) => Scale(
                writerId: doc['writerId'],
                content: doc['content'],
                likes: doc['likes'],
                timestamp: doc['timestamp'],
                scaleId: doc['scaleId'],
                mediaUrl: doc['mediaUrl'],
                postId: doc['postId'],
                attachedScaleId: doc['attachedScaleId'],
                dont: true,
              ))
          .toList();
      isLoading = false;
    });
  }

  bool isForYou = true;
  PageController pageController = PageController(initialPage: 0);
//code yamadn
  String uid = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Future<void> _handleRefresh() async {
    fetchData();
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: Colors.black,
              child: ListView(
                children: [
                  PreferredSize(
                      preferredSize: Size(Get.width, 90),
                      child: Column(
                        children: [
                          CupertinoNavigationBar(
                            middle: const Text(
                              'Scale',
                              style: TextStyle(color: kThemeColor),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 19, 19, 19)
                                    .withOpacity(0.9),
                          ),
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 2, color: Colors.grey[900]!)),
                                  color: const Color.fromARGB(255, 19, 19, 19)
                                      .withOpacity(0.9),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        setState(() {
                                          isForYou = true;

                                          pageController.animateToPage(0,
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(child: Container()),
                                          const Text(
                                            'Writings',
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
                                                      borderRadius:
                                                          kCircleBorderRadius),
                                                  height: 4.3,
                                                  width: 80,
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      color: kThemeColor,
                                                      borderRadius:
                                                          kCircleBorderRadius),
                                                  height: 4.3,
                                                  width: 80,
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
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeIn);
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Expanded(child: Container()),
                                          const Text(
                                            'Social Media',
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
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          kCircleBorderRadius),
                                                )
                                              : Container(
                                                  height: 4.3,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      color: kThemeColor,
                                                      borderRadius:
                                                          kCircleBorderRadius),
                                                )
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      )),
                ],
              ),
            );
          }
          UserModel user = UserModel.fromDocument(snapshot.data!);
          List screens = [
            writings(user),
            socialMedia(user),
          ];

          return Scaffold(
            floatingActionButton: FloatingActionButton(
                backgroundColor: kThemeColor,
                child: const Icon(CupertinoIcons.add),
                onPressed: () {
                  Get.to(
                      () => NewScale(
                            postId: '',
                          ),
                      transition: Transition.downToUp);
                }),
            key: _key,
            appBar: appBar(user),
            drawer: drawer(user, context),
            backgroundColor: Colors.black,
            body: LiquidPullToRefresh(
              animSpeedFactor: 4,
              backgroundColor: kThemeColor,
              color: Colors.transparent,
              showChildOpacityTransition: false,
              onRefresh: _handleRefresh,
              child: PageView.builder(
                controller: pageController,
                itemCount: screens.length,
                onPageChanged: (value) {
                  if (value == 0) {
                    setState(() {
                      isForYou = true;
                    });
                  } else {
                    setState(() {
                      isForYou = false;
                    });
                  }
                },
                itemBuilder: (context, index) {
                  return screens[index];
                },
              ),
            ),
          );
        });
  }

  ListView socialMedia(UserModel user) => ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 55,
            decoration: BoxDecoration(
                border: Border.symmetric(
                    horizontal:
                        BorderSide(color: Colors.grey[900]!, width: 2))),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.grey[900]!),
                      color: kDarkGreyColor,
                      borderRadius: kCircleBorderRadius),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        user.imageUrl,
                        fit: BoxFit.cover,
                        height: 35,
                        width: 35,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'daaaamn',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ]),
                ),
              ],
            ),
          ),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: scales,
          )
        ],
      );

  ListView writings(UserModel user) {
    return ListView(
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
              border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.grey[900]!, width: 2))),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey[900]!),
                    color: kDarkGreyColor,
                    borderRadius: kCircleBorderRadius),
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      user.imageUrl,
                      fit: BoxFit.cover,
                      height: 35,
                      width: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'daaaamn',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ]),
              ),
            ],
          ),
        ),
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: posts,
        ),
      ],
    );
  }

  PreferredSize appBar(UserModel user) {
    return PreferredSize(
        preferredSize: Size(Get.width, 90),
        child: Column(
          children: [
            CupertinoNavigationBar(
              leading: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 0),
                child: GestureDetector(
                  onTap: () {
                    //show drawer
                    _key.currentState!.openDrawer();
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.imageUrl,
                    ),
                  ),
                ),
              ),
              middle: const Text(
                'Scale',
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
                              'Writings',
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
                                    width: 80,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: kThemeColor,
                                        borderRadius: kCircleBorderRadius),
                                    height: 4.3,
                                    width: 80,
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
                              'Social Media',
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
                                    width: 110,
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: kCircleBorderRadius),
                                  )
                                : Container(
                                    height: 4.3,
                                    width: 110,
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
