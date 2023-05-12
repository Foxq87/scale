import 'dart:io';

import 'package:cal/constants.dart';
import 'package:cal/models/question_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/account.dart';
import 'package:cal/pages/create.dart';
import 'package:cal/pages/desktop_app.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/pages/new_scale.dart';
import 'package:cal/state_managers/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unicons/unicons.dart';
import 'package:uuid/uuid.dart';

import '../widgets/loading.dart';

class Post extends StatefulWidget {
  String postId;
  String title;
  String content;
  String thumbnailUrl;
  String writerId;
  List views;
  Timestamp timestamp;
  dynamic likes;

  Post({
    super.key,
    required this.postId,
    required this.title,
    required this.thumbnailUrl,
    required this.content,
    required this.writerId,
    required this.timestamp,
    required this.views,
    required this.likes,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.writerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          UserModel user = UserModel.fromDocument(snapshot.data!);
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Provider.of<Data>(context, listen: false).setScreen(
                  PostDetailsDesktop(
                      postId: widget.postId,
                      title: widget.title,
                      thumbnailUrl: widget.thumbnailUrl,
                      content: widget.content,
                      writerId: widget.writerId,
                      timestamp: widget.timestamp,
                      views: widget.views));
            },
            child: Container(
              margin: const EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.network(
                            widget.thumbnailUrl,
                            fit: BoxFit.cover,
                          ))),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          user.imageUrl,
                          height: 35,
                          width: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              user.username,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.views.length.toString() + ' reads',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                const Text(
                                  ' · ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                                Text(
                                  timeago.format(widget.timestamp.toDate()),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class PostMobile extends StatefulWidget {
  String postId;
  String title;
  String content;
  String thumbnailUrl;
  String writerId;
  List views;
  Timestamp timestamp;
  dynamic likes;

  PostMobile({
    super.key,
    required this.postId,
    required this.title,
    required this.thumbnailUrl,
    required this.content,
    required this.writerId,
    required this.timestamp,
    required this.views,
    required this.likes,
  });

  @override
  State<PostMobile> createState() => _PostMobileState();
}

class _PostMobileState extends State<PostMobile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.writerId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          UserModel user = UserModel.fromDocument(snapshot.data!);
          return GestureDetector(
            onLongPress: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoTheme(
                  data: CupertinoThemeData(brightness: Brightness.dark),
                  child: CupertinoActionSheet(
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Back",
                          style: TextStyle(color: Colors.blue),
                        )),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {},
                        child: Text(
                          "Share",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          showCupertinoDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => CupertinoTheme(
                              data: CupertinoThemeData(
                                brightness: Brightness.dark,
                              ),
                              child: CupertinoAlertDialog(
                                title: Text("Are you sure?"),
                                content: Text("This action can't be recovered"),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Back',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      exploreRef.doc(widget.postId).delete();
                                      //delete bookmark
                                      usersRef.get().then((list) {
                                        for (var element in list.docs) {
                                          bookmarkRef
                                              .doc(element.data()['id'])
                                              .collection('bookmarks')
                                              .where('postId',
                                                  isEqualTo: widget.postId)
                                              .get()
                                              .then((doc) {
                                            doc.docs.forEach((element) {
                                              element.reference.delete();
                                            });
                                          });
                                        }
                                      });

                                      Get.back();
                                      Get.back();
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: kThemeColor),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: kThemeColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 15, 6, 15),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.grey[900]!)),
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => PostDetailsMobile(
                          previousPageTitle: 'Home',
                          postId: widget.postId,
                          title: widget.title,
                          thumbnailUrl: widget.thumbnailUrl,
                          content: widget.content,
                          writerId: widget.writerId,
                          timestamp: widget.timestamp,
                          views: widget.views,
                          likes: widget.likes,
                        ),
                      ));
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Get.to(() => Account(profileId: user.id));
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  user.imageUrl,
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                user.username,
                                style: TextStyle(
                                    color: Colors.grey[300], fontFamily: ''),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formattedDate(widget.timestamp),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.content,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      maxLines: 4,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.5),
                          child: Image.network(
                            widget.thumbnailUrl,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.views.length.toString() + ' reads',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                            const Text(
                              ' · ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            Text(
                              timeago.format(widget.timestamp.toDate()),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.grey[900]!),
                              borderRadius: kCircleBorderRadius,
                              color: kDarkGreyColor),
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: Center(
                            child: Text(
                              'Blog',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    ;
  }
}

class PostDetailsDesktop extends StatefulWidget {
  String postId;
  String title;
  String content;
  String thumbnailUrl;

  String writerId;
  List views;
  Timestamp timestamp;

  PostDetailsDesktop({
    super.key,
    required this.postId,
    required this.title,
    required this.thumbnailUrl,
    required this.content,
    required this.writerId,
    required this.timestamp,
    required this.views,
  });

  @override
  State<PostDetailsDesktop> createState() => _PostDetailsDesktopState();
}

class _PostDetailsDesktopState extends State<PostDetailsDesktop> {
  TextEditingController contentController = TextEditingController();
  @override
  void initState() {
    //increase view count
    increaseView();
    contentController = TextEditingController(text: widget.content);
    super.initState();
  }

  void increaseView() {
    exploreRef.doc(widget.postId).update({
      "views": FieldValue.arrayUnion([uid])
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: FutureBuilder(
          future: usersRef.doc(widget.writerId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }
            UserModel user = UserModel.fromDocument(snapshot.data!);
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                AspectRatio(
                  aspectRatio: 10 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.to(() => Account(
                          profileId: user.id,
                        ));
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            user.imageUrl,
                            height: 35,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(
                                color: kThemeColor, fontSize: 16),
                          ),
                          Text(
                            formattedDate(widget.timestamp),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey[900],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.heart,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {}),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.bubble_left,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {}),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.bookmark,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {}),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.share_up,
                          color: Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {})
                  ],
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                  color: Colors.grey[900],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(),
                CupertinoTextField(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  controller: contentController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  cursorColor: kThemeColor,
                )
              ],
            );
          },
        ));
  }
}

String formattedDate(Timestamp timestamp) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('d MMM');
  final String formatted = formatter.format(timestamp.toDate());
  return formatted; // something like 2013-04-20
}

class PostDetailsMobile extends StatefulWidget {
  String previousPageTitle;
  String postId;
  String title;
  String content;
  String thumbnailUrl;
  String writerId;
  List views;
  dynamic likes;
  Timestamp timestamp;
  PostDetailsMobile({
    super.key,
    required this.previousPageTitle,
    required this.postId,
    required this.title,
    required this.thumbnailUrl,
    required this.content,
    required this.writerId,
    required this.timestamp,
    required this.views,
    required this.likes,
  });

  @override
  State<PostDetailsMobile> createState() => _PostDetailsMobileState();
}

class _PostDetailsMobileState extends State<PostDetailsMobile> {
  int getLikeCount(Map likes) {
    // if no likes, return 0
    // ignore: unnecessary_null_comparison
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    for (var val in likes.values) {
      if (val == true) {
        count += 1;
      }
    }
    setState(() {
      likeCount = count;
    });
    return count;
  }

  @override
  void initState() {
    //increase view count

    getIfBookmarked();
    increaseView();
    getLikeCount(widget.likes);
    isLiked = widget.likes[uid] == true;
    super.initState();
  }

  bool bookmarked = false;

  getIfBookmarked() {
    bookmarkRef
        .doc(uid)
        .collection('bookmarks')
        .where('postId', isEqualTo: widget.postId)
        .get()
        .then((doc) {
      if (doc.docs.isNotEmpty) {
        setState(() {
          bookmarked = true;
        });
      } else {
        setState(() {
          bookmarked = false;
        });
      }
    });
  }

  void increaseView() {
    exploreRef.doc(widget.postId).update({
      "views": FieldValue.arrayUnion([uid])
    });
  }

  int likeCount = 0;
  bool isLiked = false;
  handleLikePost() {
    bool isliked = widget.likes[uid] == true;
    if (isliked) {
      exploreRef.doc(widget.postId).update({"likes.$uid": false});
      // removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        widget.likes[uid] = false;
      });
    } else if (!isliked) {
      exploreRef.doc(widget.postId).update({"likes.$uid": true});
      addToActivityFeed() {
        String notificationId = Uuid().v4();
        notificationsRef
            .doc(widget.writerId)
            .collection('activities')
            .doc(notificationId)
            .set({
          "type": "postLike",
          "uid": uid,
          "timestamp": DateTime.now(),
          "notificationId": notificationId,
          "scaleId": widget.postId,
          "postId": '',
        });
      }

      bool isNotPostOwner = widget.writerId != uid;
      if (isNotPostOwner) {}

      setState(() {
        likeCount += 1;
        isLiked = true;
        widget.likes[uid] = true;
      });
    }
    getLikeCount(widget.likes);
  }

  addToBookmarks(String postId) {
    bookmarkRef
        .doc(uid)
        .collection('bookmarks')
        .where('postId', isEqualTo: postId)
        .get()
        .then((doc) {
      if (doc.docs.isNotEmpty) {
        bookmarkRef.doc(uid).collection('bookmarks').doc(postId).delete();
        setState(() {
          bookmarked = false;
        });
      } else {
        bookmarkRef.doc(uid).collection('bookmarks').doc(postId).set({
          "id": postId,
          "postId": postId,
          "scaleId": '',
        });
        setState(() {
          bookmarked = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: const Border(
            bottom: BorderSide(color: CupertinoColors.systemGrey, width: 0.25)),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
        previousPageTitle: widget.previousPageTitle,
        middle: const Text(
          'Ideas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: FutureBuilder(
            future: usersRef.doc(widget.writerId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return loading();
              }
              UserModel user = UserModel.fromDocument(snapshot.data!);
              return ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(() => Account(
                            profileId: user.id,
                          ));
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              user.imageUrl,
                              height: 35,
                              width: 35,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username,
                              style: const TextStyle(
                                  color: kThemeColor, fontSize: 16),
                            ),
                            Text(
                              formattedDate(widget.timestamp),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: Colors.grey[900],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                likeCount == 0 ? '' : likeCount.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Icon(
                                isLiked
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: isLiked ? kThemeColor : Colors.grey,
                                size: 22,
                              ),
                            ],
                          ),
                          onPressed: () {
                            handleLikePost();
                          }),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            String.fromCharCode(UniconsLine.comment.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.grey[400],
                              fontSize: 21.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: UniconsLine.comment.fontFamily,
                              package: UniconsLine.comment.fontPackage,
                            ),
                          ),
                          onPressed: () {}),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            String.fromCharCode(bookmarked
                                ? CupertinoIcons.bookmark_fill.codePoint
                                : CupertinoIcons.bookmark.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.grey[400],
                              fontSize: 21.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: CupertinoIcons.bookmark.fontFamily,
                              package: CupertinoIcons.bookmark.fontPackage,
                            ),
                          ),
                          onPressed: () {
                            addToBookmarks(widget.postId);
                          }),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Text(
                          String.fromCharCode(UniconsLine.process.codePoint),
                          style: TextStyle(
                            inherit: false,
                            color: Colors.grey[400],
                            fontSize: 21.0,
                            fontWeight: FontWeight.w900,
                            fontFamily: UniconsLine.comment.fontFamily,
                            package: UniconsLine.comment.fontPackage,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => NewScale(
                                postId: widget.postId,
                                scaleId: '',
                              ));
                        },
                      ),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            String.fromCharCode(UniconsLine.upload.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.grey[400],
                              fontSize: 21.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: UniconsLine.comment.fontFamily,
                              package: UniconsLine.comment.fontPackage,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: kDarkGreyColor,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              builder: (context) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              color: Colors.grey[200],
                                              fontSize: 20),
                                        ),
                                        CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: Icon(
                                              CupertinoIcons.clear_circled,
                                              size: 27,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            })
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 0, 20, 10),
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey[900],
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                    color: Colors.grey[900],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(),
                  SelectableText(
                    widget.content,
                    style: TextStyle(color: Colors.grey[200], fontSize: 18),
                    cursorColor: kThemeColor,
                  )
                ],
              );
            },
          )),
    );
  }
}
