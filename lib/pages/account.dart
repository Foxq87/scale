import 'package:cal/constants.dart';
import 'package:cal/models/post_model.dart';
import 'package:cal/models/scale_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Account extends StatefulWidget {
  final String profileId;

  const Account({
    super.key,
    required this.profileId,
  });

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  PageController pageController = PageController(initialPage: 0);
  bool isForYou = false;
  bool isLoading = false;
  List<Widget> scales = [];
  List<Widget> writings = [];
  List<Widget> replies = [];
  List<Widget> likes = [];
  String formattedDate(Timestamp timestamp) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final String formatted = formatter.format(timestamp.toDate());
    return formatted; // something like 2013-04-20
  }

  ScrollController largeController = ScrollController();
  // ScrollController smallController1 = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot scaleSnapshot = await scalesRef
        .where('writerId', isEqualTo: widget.profileId)
        .where('isReply', isEqualTo: false)
        .orderBy('timestamp', descending: false)
        .get();
    QuerySnapshot writingSnapshot =
        await exploreRef.where('writerId', isEqualTo: widget.profileId).get();

    QuerySnapshot replySnapshot = await scalesRef
        .where('writerId', isEqualTo: widget.profileId)
        .where('isReply', isEqualTo: true)
        .orderBy('timestamp', descending: false)
        .get();
    QuerySnapshot likeSnaphsot = await scalesRef
        .where('likes', arrayContains: {widget.profileId: true}).get();
    setState(() {
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
                isReply: doc['isReply'],
                repostedScaleId: doc['repostedScaleId'],
                dont: true,
                currentScreen: Account,
              ))
          .toList();
      writings = writingSnapshot.docs
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

      replies = replySnapshot.docs
          .map((doc) => Scale(
                writerId: doc['writerId'],
                content: doc['content'],
                likes: doc['likes'],
                timestamp: doc['timestamp'],
                scaleId: doc['scaleId'],
                mediaUrl: doc['mediaUrl'],
                postId: doc['postId'],
                attachedScaleId: doc['attachedScaleId'],
                isReply: doc['isReply'],
                repostedScaleId: doc['repostedScaleId'],
                dont: true,
                currentScreen: Account,
              ))
          .toList();
      likes = likeSnaphsot.docs
          .map(
            (doc) => Scale(
              writerId: doc['writerId'],
              content: doc['content'],
              likes: doc['likes'],
              timestamp: doc['timestamp'],
              scaleId: doc['scaleId'],
              mediaUrl: doc['mediaUrl'],
              postId: doc['postId'],
              attachedScaleId: doc['attachedScaleId'],
              isReply: doc['isReply'],
              repostedScaleId: doc['repostedScaleId'],
              currentScreen: Account,
            ),
          )
          .toList();
      isLoading = false;
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          UserModel user = UserModel.fromDocument(snapshot.data!);
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.black,
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          //header
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: 170,
                                decoration: BoxDecoration(
                                    image: user.bannerUrl.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: NetworkImage(user.bannerUrl),
                                            fit: BoxFit.cover,
                                          ),
                                    color: kThemeColor),
                              ),
                              Positioned(
                                left: 10,
                                top: 30,
                                right: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor:
                                            kDarkGreyColor.withOpacity(0.7),
                                        child: const Center(
                                            child: Icon(
                                          CupertinoIcons.arrow_left,
                                          color: Colors.white,
                                          size: 16,
                                        )),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                kDarkGreyColor.withOpacity(0.7),
                                            child: const Center(
                                                child: Icon(
                                              CupertinoIcons.search,
                                              color: Colors.white,
                                              size: 16,
                                            )),
                                          ),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {},
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor:
                                                kDarkGreyColor.withOpacity(0.7),
                                            child: const Center(
                                                child: Icon(
                                              CupertinoIcons.ellipsis,
                                              color: Colors.white,
                                              size: 16,
                                            )),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: -40,
                                left: 16,
                                child: SizedBox(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          width: 4,
                                          color: Colors.black,
                                        )),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        user.imageUrl,
                                        fit: BoxFit.cover,
                                        height: 80,
                                        width: 80,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //bio, etc..
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Row(
                                            children: [
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          kCircleBorderRadius,
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey[200]!)),
                                                  child: CircleAvatar(
                                                    child: Image.asset(
                                                      'assets/mail.png',
                                                      color: Colors.grey[200],
                                                      height: 25,
                                                    ),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 17,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () {
                                                  print('da');
                                                  go();
                                                },
                                                child: AbsorbPointer(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 25,
                                                        vertical: 7),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            kCircleBorderRadius),
                                                    child: const Center(
                                                      child: Text(
                                                        'Follow',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.username,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Joined ${formattedDate(user.creation)}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          user.school.isNotEmpty
                                              ? Column(
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          user.school,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        ],
                                      ),
                                      user.bio.isNotEmpty
                                          ? Column(
                                              children: [
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(
                                                  user.bio,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            )
                                          : const SizedBox(),
                                    ]),
                              )),
                          //posts,replies,likes..
                          SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.3,
                                          color: Colors.grey[700]!))),
                              child: SizedBox(
                                height: 25,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      //Scales
                                      Expanded(
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            pageController.animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeInOut);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Scales",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        kCircleBorderRadius,
                                                    color: currentIndex == 0
                                                        ? kThemeColor
                                                        : Colors.transparent),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                height: 3,
                                                width: 55,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Writings
                                      Expanded(
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            pageController.animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeInOut);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Writings",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      kCircleBorderRadius,
                                                  color: currentIndex == 1
                                                      ? kThemeColor
                                                      : Colors.transparent,
                                                ),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                height: 3,
                                                width: 65,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Replies
                                      Expanded(
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            pageController.animateToPage(2,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeInOut);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Replies",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      kCircleBorderRadius,
                                                  color: currentIndex == 2
                                                      ? kThemeColor
                                                      : Colors.transparent,
                                                ),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                height: 3,
                                                width: 60,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Writings
                                      Expanded(
                                        child: CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            pageController.animateToPage(3,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                curve: Curves.easeInOut);
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Likes",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      kCircleBorderRadius,
                                                  color: currentIndex == 3
                                                      ? kThemeColor
                                                      : Colors.transparent,
                                                ),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                height: 3,
                                                width: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //displaying posts,replies,posts,
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      onPageChanged: (val) {
                        setState(() {
                          currentIndex = val;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      itemBuilder: (context, index) {
                        buildScales() {
                          return ListView(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: scales);
                        }

                        buildWritings() {
                          return ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: writings);
                        }

                        buildReplies() {
                          return ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: replies);
                        }

                        buildLikes() {
                          return ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: likes);
                        }

                        List screens = [
                          buildScales(),
                          buildWritings(),
                          buildReplies(),
                          buildLikes(),
                        ];
                        return screens[index];
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void go() {
    largeController.animateTo(280,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
