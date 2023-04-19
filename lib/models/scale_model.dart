import 'package:cal/constants.dart';
import 'package:cal/models/post_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:unicons/unicons.dart';
import 'package:uuid/uuid.dart';

import '../widgets/photo.dart';

class Scale extends StatefulWidget {
  final String scaleId;
  final String writerId;
  final String content;
  final dynamic likes;
  final String mediaUrl;
  final String postId;
  final List attachedScaleId;
  final Timestamp timestamp;
  final bool? dont;

  const Scale({
    super.key,
    required this.scaleId,
    required this.writerId,
    required this.content,
    required this.likes,
    required this.timestamp,
    required this.mediaUrl,
    required this.postId,
    required this.attachedScaleId,
    this.dont,
  });

  @override
  State<Scale> createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  @override
  void initState() {
    //increase view count

    getLikeCount(widget.likes);
    isLiked = widget.likes[uid] == true;
    doesReplyExists();
    super.initState();
  }

  String formattedDate(Timestamp timestamp) {
    final DateFormat formatter = DateFormat('HH:mm · dd.MM.yyyy');
    final String formatted = formatter.format(timestamp.toDate());
    return formatted; // something like 2013-04-20
  }

  int likeCount = 0;

  bool isLiked = false;

  String uid = FirebaseAuth.instance.currentUser!.uid;

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

  bool result = false;
  List<Widget> subComments = [];
  doesReplyExists() {
    if (widget.dont != null) {
      scalesRef
          .where('writerId', isEqualTo: uid)
          .where(
            'attachedScaleId',
            arrayContains: widget.scaleId,
          )
          .get()
          .then((doc) {
        if (doc.docs.isNotEmpty) {
          setState(() {
            result = true;

            subComments = doc.docs
                .map((doc) => Scale(
                      writerId: doc['writerId'],
                      content: doc['content'],
                      likes: doc['likes'],
                      timestamp: doc['timestamp'],
                      scaleId: doc['scaleId'],
                      mediaUrl: doc['mediaUrl'],
                      postId: doc['postId'],
                      attachedScaleId: doc['attachedScaleId'],
                    ))
                .toList();
          });
        } else {
          setState(() {
            result = false;
          });
        }
      });
    } else {
      scalesRef
          .where(
            'attachedScaleId',
            arrayContains: widget.scaleId,
          )
          .get()
          .then((doc) {
        if (doc.docs.isNotEmpty) {
          doc.docs.forEach((element) {
            if (element.data()['attachedScaleId'] == widget.attachedScaleId) {
              setState(() {
                result = true;
              });
            }
          });
          setState(() {
            result = true;

            subComments = doc.docs
                .map((doc) => Scale(
                      writerId: doc['writerId'],
                      content: doc['content'],
                      likes: doc['likes'],
                      timestamp: doc['timestamp'],
                      scaleId: doc['scaleId'],
                      mediaUrl: doc['mediaUrl'],
                      postId: doc['postId'],
                      attachedScaleId: doc['attachedScaleId'],
                    ))
                .toList();
          });
        } else {
          setState(() {
            result = false;
          });
        }
      });
    }
  }

  handleLikePost() {
    bool isliked = widget.likes[uid] == true;
    if (isliked) {
      scalesRef.doc(widget.scaleId).update({"likes.$uid": false});
      // removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        widget.likes[uid] = false;
      });
    } else if (!isliked) {
      scalesRef.doc(widget.scaleId).update({"likes.$uid": true});
      // addLikeToActivityFeed();
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: usersRef.doc(widget.writerId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return loading();
        }
        UserModel user = UserModel.fromDocument(snapshot.data!);
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: result
                          ? const BorderSide()
                          : BorderSide(width: 1.5, color: Colors.grey[900]!))),
              child: CupertinoButton(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 4),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ScaleDetails(
                          scaleId: widget.scaleId,
                          writerId: widget.writerId,
                          content: widget.content,
                          likes: widget.likes,
                          timestamp: widget.timestamp,
                          postId: widget.postId,
                          mediaUrl: widget.mediaUrl,
                          attachedScaleId: widget.attachedScaleId,
                        ),
                      ));
                },
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          result
                              ? Flexible(
                                  child: VerticalDivider(
                                  indent: 15,
                                  color: Colors.grey[850],
                                  thickness: 2,
                                ))
                              : SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    user.isVerified || user.isDeveloper
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .checkmark_seal_fill
                                                        .codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: user.isDeveloper &&
                                                          user.isVerified
                                                      ? kThemeColor
                                                      : Colors.blue,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: CupertinoIcons
                                                      .heart.fontFamily,
                                                  package: CupertinoIcons
                                                      .heart.fontPackage,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                timeago.format(
                                                  widget.timestamp.toDate(),
                                                ),
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: GestureDetector(
                                      child: const Icon(
                                        CupertinoIcons.ellipsis,
                                        color: Colors.grey,
                                      ),
                                      onTap: () {}),
                                ),
                              ],
                            ),
                            Text(
                              widget.content,
                              style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            widget.mediaUrl.isEmpty
                                ? const SizedBox()
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.grey[900]!)),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() => Photo(
                                                  mediaUrl: widget.mediaUrl));
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                child: Image.network(
                                                  widget.mediaUrl,
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                            widget.postId.isEmpty
                                ? const SizedBox()
                                : FutureBuilder(
                                    future: exploreRef.doc(widget.postId).get(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return loading();
                                      }

                                      return FutureBuilder(
                                          future: usersRef
                                              .doc(snapshot.data!
                                                  .data()!['writerId'])
                                              .get(),
                                          builder: (context, writerSnapshot) {
                                            if (!writerSnapshot.hasData) {
                                              return loading();
                                            }
                                            UserModel writer =
                                                UserModel.fromDocument(
                                                    writerSnapshot.data!);
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    final documentSnapshot =
                                                        snapshot.data!.data()!;
                                                    Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (context) =>
                                                              PostDetailsMobile(
                                                            previousPageTitle:
                                                                '',
                                                            postId:
                                                                documentSnapshot[
                                                                    'postId'],
                                                            title:
                                                                documentSnapshot[
                                                                    'title'],
                                                            thumbnailUrl:
                                                                documentSnapshot[
                                                                    'thumbnailUrl'],
                                                            content:
                                                                documentSnapshot[
                                                                    'content'],
                                                            writerId:
                                                                documentSnapshot[
                                                                    'writerId'],
                                                            timestamp:
                                                                documentSnapshot[
                                                                    'timestamp'],
                                                            views:
                                                                documentSnapshot[
                                                                    'views'],
                                                            likes:
                                                                documentSnapshot[
                                                                    'likes'],
                                                          ),
                                                        ));
                                                  },
                                                  child: AspectRatio(
                                                    aspectRatio: 10 / 3.6,
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20,
                                                              top: 4,
                                                              left: 0),
                                                      decoration: BoxDecoration(
                                                          color: kDarkGreyColor,
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .grey[900]!),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal:
                                                                    10.0,
                                                                vertical: 10,
                                                              ),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        child: Image
                                                                            .network(
                                                                          writer
                                                                              .imageUrl,
                                                                          height:
                                                                              25,
                                                                          width:
                                                                              25,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        writer
                                                                            .username,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.grey[350],
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                      writer.isVerified ||
                                                                              writer.isDeveloper
                                                                          ? Row(
                                                                              children: [
                                                                                const SizedBox(
                                                                                  width: 5,
                                                                                ),
                                                                                Text(
                                                                                  String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
                                                                                  style: TextStyle(
                                                                                    inherit: false,
                                                                                    color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
                                                                                    fontSize: 15.0,
                                                                                    fontWeight: FontWeight.w900,
                                                                                    fontFamily: CupertinoIcons.heart.fontFamily,
                                                                                    package: CupertinoIcons.heart.fontPackage,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            )
                                                                          : const SizedBox(),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .data()!['title'],
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16),
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data!
                                                                              .data()!['content'],
                                                                          style: const TextStyle(
                                                                              color: Colors.grey,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 14),
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          ClipRRect(
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        18),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        18)),
                                                            child:
                                                                Image.network(
                                                              snapshot.data!
                                                                      .data()![
                                                                  'thumbnailUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            String.fromCharCode(isLiked
                                                ? CupertinoIcons
                                                    .heart_fill.codePoint
                                                : CupertinoIcons
                                                    .heart.codePoint),
                                            style: TextStyle(
                                              inherit: false,
                                              color: isLiked
                                                  ? kThemeColor
                                                  : Colors.grey[600],
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: CupertinoIcons
                                                  .heart.fontFamily,
                                              package: CupertinoIcons
                                                  .heart.fontPackage,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          likeCount != 0
                                              ? likeCount.toString()
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      handleLikePost();
                                    }),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      String.fromCharCode(
                                          UniconsLine.comment.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: Colors.grey[600],
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily:
                                            UniconsLine.comment.fontFamily,
                                        package:
                                            UniconsLine.comment.fontPackage,
                                      ),
                                    ),
                                    onPressed: () {}),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      String.fromCharCode(
                                          UniconsLine.process.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: Colors.grey[600],
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily:
                                            UniconsLine.comment.fontFamily,
                                        package:
                                            UniconsLine.comment.fontPackage,
                                      ),
                                    ),
                                    onPressed: () {}),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      String.fromCharCode(
                                          UniconsLine.bookmark.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: Colors.grey[600],
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily:
                                            UniconsLine.bookmark.fontFamily,
                                        package:
                                            UniconsLine.bookmark.fontPackage,
                                      ),
                                    ),
                                    onPressed: () {}),
                                CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      String.fromCharCode(
                                          UniconsLine.upload.codePoint),
                                      style: TextStyle(
                                        inherit: false,
                                        color: Colors.grey[600],
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w900,
                                        fontFamily:
                                            UniconsLine.share.fontFamily,
                                        package: UniconsLine.share.fontPackage,
                                      ),
                                    ),
                                    onPressed: () {}),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: subComments,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class ScaleDetails extends StatefulWidget {
  final String scaleId;
  final String writerId;
  final String content;
  final dynamic likes;
  final Timestamp timestamp;
  final String mediaUrl;
  final String postId;
  final List attachedScaleId;
  const ScaleDetails({
    super.key,
    required this.scaleId,
    required this.writerId,
    required this.content,
    required this.likes,
    required this.timestamp,
    required this.mediaUrl,
    required this.postId,
    required this.attachedScaleId,
  });

  @override
  State<ScaleDetails> createState() => _ScaleDetailsState();
}

class _ScaleDetailsState extends State<ScaleDetails> {
  FocusNode focusNode = FocusNode();
  TextEditingController commentTextController = TextEditingController();
  @override
  void initState() {
    //increase view count
    fetchData();
    getLikeCount(widget.likes);
    isLiked = widget.likes[uid] == true;
    super.initState();
  }

  bool isLoading = false;
  List<Widget> comments = [];
  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot scaleSnapshot = await scalesRef
        .orderBy('timestamp', descending: true)
        .where('attachedScaleId', arrayContains: widget.scaleId)
        .get();
    setState(() {
      comments = scaleSnapshot.docs
          .map((doc) => Scale(
                writerId: doc['writerId'],
                content: doc['content'],
                likes: doc['likes'],
                timestamp: doc['timestamp'],
                scaleId: doc['scaleId'],
                mediaUrl: doc['mediaUrl'],
                postId: doc['postId'],
                attachedScaleId: doc['attachedScaleId'],
              ))
          .toList();
      isLoading = false;
    });
  }

  String formattedDate(Timestamp timestamp) {
    final DateFormat formatter = DateFormat('HH:mm · dd.MM.yyyy');
    final String formatted = formatter.format(timestamp.toDate());
    return formatted; // something like 2013-04-20
  }

  int likeCount = 0;
  bool isLiked = false;
  String uid = FirebaseAuth.instance.currentUser!.uid;
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

  handleLikePost() {
    bool isliked = widget.likes[uid] == true;
    if (isliked) {
      scalesRef.doc(widget.scaleId).update({"likes.$uid": false});
      // removeLikeFromActivityFeed();
      setState(() {
        likeCount -= 1;
        isLiked = false;
        widget.likes[uid] = false;
      });
    } else if (!isliked) {
      scalesRef.doc(widget.scaleId).update({"likes.$uid": true});
      // addLikeToActivityFeed();
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

  addComment() {
    String scaleId = Uuid().v4();
    if (commentTextController.text != "") {
      // if (isNotPostOwner) {}

      scalesRef.doc(scaleId).set({
        "scaleId": scaleId,
        "writerId": uid,
        "content": commentTextController.text,
        "timestamp": DateTime.now(),
        "postId": '',
        "likes": {},
        "mediaUrl": '',
        "attachedScaleId": [widget.scaleId],
      });

      commentTextController.clear();
    }
  }

  buildWriteComment() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FutureBuilder(
          future: usersRef.doc(widget.writerId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }
            UserModel user = UserModel.fromDocument(snapshot.data!);
            return Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.grey[900]!))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                child: SizedBox(
                  height: 55,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          const SizedBox(width: 10),
                          commentTextField(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Expanded commentTextField() {
    return Expanded(
      flex: 2,
      child: Material(
          color: Colors.transparent,
          child: CupertinoSearchTextField(
            focusNode: focusNode,
            onSuffixTap: addComment,
            controller: commentTextController,
            style: const TextStyle(color: Colors.white),
            prefixIcon: const SizedBox(),
            placeholder: 'Write your reply',
            suffixIcon: const Icon(
              Icons.send_rounded,
              color: Colors.grey,
            ),
          )),
    );
  }

  buildComments() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: comments,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar('Post', 'Scale', null),
      backgroundColor: Colors.black,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: usersRef.doc(widget.writerId).get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return loading();
                    }
                    UserModel user = UserModel.fromDocument(snapshot.data!);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    user.isVerified || user.isDeveloper
                                        ? Row(
                                            children: [
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                String.fromCharCode(
                                                    CupertinoIcons
                                                        .checkmark_seal_fill
                                                        .codePoint),
                                                style: TextStyle(
                                                  inherit: false,
                                                  color: user.isDeveloper &&
                                                          user.isVerified
                                                      ? kThemeColor
                                                      : Colors.blue,
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: CupertinoIcons
                                                      .heart.fontFamily,
                                                  package: CupertinoIcons
                                                      .heart.fontPackage,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                Text(
                                  timeago.format(
                                    widget.timestamp.toDate(),
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text(
                                    widget.content,
                                    style: TextStyle(
                                        color: Colors.grey[350], fontSize: 19),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                widget.mediaUrl.isEmpty
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => Photo(
                                                    mediaUrl: widget.mediaUrl));
                                              },
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: Image.network(
                                                    widget.mediaUrl,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                widget.postId.isEmpty
                                    ? const SizedBox()
                                    : FutureBuilder(
                                        future:
                                            exploreRef.doc(widget.postId).get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return loading();
                                          }

                                          return FutureBuilder(
                                              future: usersRef
                                                  .doc(snapshot.data!
                                                      .data()!['writerId'])
                                                  .get(),
                                              builder:
                                                  (context, writerSnapshot) {
                                                if (!writerSnapshot.hasData) {
                                                  return loading();
                                                }
                                                UserModel writer =
                                                    UserModel.fromDocument(
                                                        writerSnapshot.data!);
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CupertinoButton(
                                                      padding: EdgeInsets.zero,
                                                      onPressed: () {
                                                        final documentSnapshot =
                                                            snapshot.data!
                                                                .data()!;
                                                        Get.to(
                                                          () =>
                                                              PostDetailsMobile(
                                                            previousPageTitle:
                                                                '',
                                                            postId:
                                                                documentSnapshot[
                                                                    'postId'],
                                                            title:
                                                                documentSnapshot[
                                                                    'title'],
                                                            thumbnailUrl:
                                                                documentSnapshot[
                                                                    'thumbnailUrl'],
                                                            content:
                                                                documentSnapshot[
                                                                    'content'],
                                                            writerId:
                                                                documentSnapshot[
                                                                    'writerId'],
                                                            timestamp:
                                                                documentSnapshot[
                                                                    'timestamp'],
                                                            views:
                                                                documentSnapshot[
                                                                    'views'],
                                                            likes:
                                                                documentSnapshot[
                                                                    'likes'],
                                                          ),
                                                        );
                                                      },
                                                      child: AspectRatio(
                                                        aspectRatio: 10 / 3.5,
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 20,
                                                                  top: 4,
                                                                  left: 0),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  kDarkGreyColor,
                                                              border: Border.all(
                                                                  width: 2,
                                                                  color: Colors
                                                                          .grey[
                                                                      900]!),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child:
                                                                                Image.network(
                                                                              writer.imageUrl,
                                                                              height: 25,
                                                                              width: 25,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            writer.username,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey[350],
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          writer.isVerified || writer.isDeveloper
                                                                              ? Row(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Text(
                                                                                      String.fromCharCode(CupertinoIcons.checkmark_seal_fill.codePoint),
                                                                                      style: TextStyle(
                                                                                        inherit: false,
                                                                                        color: writer.isDeveloper && writer.isVerified ? kThemeColor : Colors.blue,
                                                                                        fontSize: 15.0,
                                                                                        fontWeight: FontWeight.w900,
                                                                                        fontFamily: CupertinoIcons.heart.fontFamily,
                                                                                        package: CupertinoIcons.heart.fontPackage,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : const SizedBox(),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data!.data()!['title'],
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                                                              maxLines: 1,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data!.data()!['content'],
                                                                              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            18),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            18)),
                                                                child: Image
                                                                    .network(
                                                                  snapshot.data!
                                                                          .data()![
                                                                      'thumbnailUrl'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    formattedDate(widget.timestamp),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 5,
                  color: Colors.grey[900],
                  thickness: 1.8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  String.fromCharCode(isLiked
                                      ? CupertinoIcons.heart_fill.codePoint
                                      : CupertinoIcons.heart.codePoint),
                                  style: TextStyle(
                                    inherit: false,
                                    color: isLiked
                                        ? kThemeColor
                                        : Colors.grey[400],
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: CupertinoIcons.heart.fontFamily,
                                    package: CupertinoIcons.heart.fontPackage,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                getLikeCount(widget.likes) != 0
                                    ? getLikeCount(widget.likes).toString()
                                    : '',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              )
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
                          onPressed: () {}),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            String.fromCharCode(UniconsLine.bookmark.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.grey[400],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: UniconsLine.bookmark.fontFamily,
                              package: UniconsLine.bookmark.fontPackage,
                            ),
                          ),
                          onPressed: () {}),
                      CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            String.fromCharCode(UniconsLine.upload.codePoint),
                            style: TextStyle(
                              inherit: false,
                              color: Colors.grey[400],
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                              fontFamily: UniconsLine.share.fontFamily,
                              package: UniconsLine.share.fontPackage,
                            ),
                          ),
                          onPressed: () {}),
                    ],
                  ),
                ),
                Divider(
                  height: 5,
                  color: Colors.grey[900],
                  thickness: 1.8,
                ),
                buildComments(),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
            buildWriteComment()
          ],
        ),
      ),
    );
  }
}

///Scale.model backup