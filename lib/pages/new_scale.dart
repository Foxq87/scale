import 'dart:io';
import 'dart:ui';
import 'package:cal/models/post_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/snackbar.dart';
import '/constants.dart';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewScale extends StatefulWidget {
  String postId;
  NewScale({Key? key, required this.postId}) : super(key: key);

  @override
  State<NewScale> createState() => _NewScaleState();
}

TextEditingController tweetController = TextEditingController();
List<File> images = [];

class _NewScaleState extends State<NewScale> {
  String audienceTxt = 'herkes';
  List audience = [
    [0, true], //everyone
    [1, false], //school
    [2, false] //students
  ];
  String url = "";
  File? image;
  bool isActive = false;

  Future pickImage() async {
    final imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile == null) return;

    final imageTemporary = File(imageFile.path);
    setState(() {
      image = imageTemporary;
    });
  }

  // compressImage(String postId, File file) async {
  //   final tempDir = getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image? imageFile = Im.decodeImage(file.readAsBytesSync());
  //   final compressedImage = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile!, quality: 5));
  //   setState(() {
  //     image = compressedImage;
  //   });
  // }

  Future<void> handleImage(String scaleId) async {
    final storageImage = FirebaseStorage.instance
        .ref()
        .child('postImages')
        .child('img_$scaleId.jpg');
    var task = storageImage.putFile(image!);
    url = await (await task.whenComplete(() => null)).ref.getDownloadURL();
    scalesRef.doc(uid).collection('userPosts').doc(scaleId).update({
      "mediaUrl": url.toString(),
    });
    scalesRef.doc(scaleId).update({
      "mediaUrl": url.toString(),
    });
  }

  createPost({
    required String tweet,
    required String scaleId,
    required String postId,
  }) async {
    if (image != null) {
      scalesRef.doc(scaleId).set({
        "scaleId": scaleId,
        "writerId": uid,
        "content": tweet,
        "timestamp": DateTime.now(),
        "postId": postId,
        "likes": {},
        "mediaUrl": '',
        "attachedScaleId": [],
      });
      await handleImage(scaleId);
    } else {
      scalesRef.doc(scaleId).set({
        "scaleId": scaleId,
        "writerId": uid,
        "content": tweet,
        "mediaUrl": '',
        "timestamp": DateTime.now(),
        "postId": postId,
        "likes": {},
        "attachedScaleId": [],
      });
    }
  }

  Future<String> uploadImage(File image, String postId) async {
    UploadTask uploadTask =
        storageRefc.child("post_$postId.jpg").putFile(image);
    TaskSnapshot storageSnap = await uploadTask;
    url = await storageSnap.ref.getDownloadURL();
    return url;
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: usersRef.doc(uid).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }
            UserModel user = UserModel.fromDocument(snapshot.data!);
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )),
                      SizedBox(
                        height: 32,
                        child: CupertinoButton(
                            color: isActive == true
                                ? kThemeColor
                                : kThemeColor.withOpacity(0.4),
                            // shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            // ),
                            padding: const EdgeInsets.symmetric(horizontal: 17),
                            onPressed: () {
                              String scaleId = const Uuid().v4();
                              try {
                                if (isActive == true) {
                                  createPost(
                                    tweet: tweetController.text,
                                    scaleId: scaleId,
                                    postId: widget.postId,
                                  );

                                  tweetController.clear();
                                  images.clear();
                                  setState(() {
                                    image = null;
                                  });

                                  Get.back();
                                }
                              } catch (e) {
                                snackbar(
                                    "Hata",
                                    "Beklenmeyen bir hata oluştu. Daha sonra tekrar deneyin",
                                    true);
                              }
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                  color: isActive == true
                                      ? Colors.white
                                      : kThemeColor.withOpacity(0.5),
                                  fontSize: 17),
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: Image.network(
                          user.imageUrl,
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: kDarkGreyColor,
                              context: context,
                              builder: (context) => Material(
                                    color: Colors.transparent,
                                    child: StatefulBuilder(
                                        builder: (context, setModalState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Audience(
                                            title: 'Herkes',
                                            subTitle:
                                                'Uygulamada kayitli herkes gorebilir',
                                            color: Colors.blue,
                                            icon: const Icon(
                                              FeatherIcons.globe,
                                              color: Colors.white,
                                            ),
                                            isActive: audience[0][1],
                                            onTap: () {
                                              setModalState(() {
                                                audience[1][1] = false;
                                                audience[0][1] = true;
                                              });
                                              audienceText();
                                              Get.back();
                                            },
                                          ),
                                          Audience(
                                            title: 'Okul',
                                            subTitle:
                                                'Sadece senin okulunda kayitli kisiler gorebilir (ogretmenler dahil)',
                                            color: Colors.amber,
                                            icon: const Icon(
                                              CupertinoIcons.book,
                                              color: Colors.white,
                                            ),
                                            isActive: audience[1][1],
                                            onTap: () {
                                              setModalState(() {
                                                audience[0][1] = false;

                                                audience[1][1] = true;
                                              });
                                              audienceText();

                                              Get.back();
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      );
                                    }),
                                  ));
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: kThemeColor),
                              borderRadius: BorderRadius.circular(200)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                audienceTxt,
                                style: const TextStyle(
                                    color: kThemeColor,
                                    fontFamily: 'poppinsBold',
                                    fontSize: 16),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: kThemeColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CupertinoTextField(
                    controller: tweetController,
                    onChanged: (input) {
                      if (tweetController.text != '') {
                        setState(() {
                          isActive = true;
                        });
                      } else {
                        setState(() {
                          isActive = false;
                        });
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    minLines: 1,
                    maxLines: 12,
                    maxLength: 400,
                    style: const TextStyle(color: Colors.white),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    placeholder: 'Aklından ne geçiyor?',
                    placeholderStyle: const TextStyle(color: Colors.white70),
                  ),
                ),
                image == null
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.35, color: Colors.grey[600]!),
                                borderRadius: BorderRadius.circular(5)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          CupertinoButton(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Icon(CupertinoIcons.clear_circled),
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              })
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
                                  .doc(snapshot.data!.data()!['writerId'])
                                  .get(),
                              builder: (context, writerSnapshot) {
                                if (!writerSnapshot.hasData) {
                                  return loading();
                                }
                                UserModel writer = UserModel.fromDocument(
                                    writerSnapshot.data!);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        final documentSnapshot =
                                            snapshot.data!.data()!;
                                        Get.to(
                                          () => PostDetailsMobile(
                                            previousPageTitle: '',
                                            postId: documentSnapshot['postId'],
                                            title: documentSnapshot['title'],
                                            thumbnailUrl: documentSnapshot[
                                                'thumbnailUrl'],
                                            content:
                                                documentSnapshot['content'],
                                            writerId:
                                                documentSnapshot['writerId'],
                                            timestamp:
                                                documentSnapshot['timestamp'],
                                            views: documentSnapshot['views'],
                                            likes: documentSnapshot['likes'],
                                          ),
                                        );
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 10 / 3,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 20, top: 4, left: 20),
                                          decoration: BoxDecoration(
                                              color: kDarkGreyColor,
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.grey[900]!),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10.0,
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
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            child:
                                                                Image.network(
                                                              writer.imageUrl,
                                                              height: 25,
                                                              width: 25,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            writer.username,
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .grey[350],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          writer.isVerified ||
                                                                  writer
                                                                      .isDeveloper
                                                              ? Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      String.fromCharCode(CupertinoIcons
                                                                          .checkmark_seal_fill
                                                                          .codePoint),
                                                                      style:
                                                                          TextStyle(
                                                                        inherit:
                                                                            false,
                                                                        color: writer.isDeveloper &&
                                                                                writer.isVerified
                                                                            ? kThemeColor
                                                                            : Colors.blue,
                                                                        fontSize:
                                                                            15.0,
                                                                        fontWeight:
                                                                            FontWeight.w900,
                                                                        fontFamily: CupertinoIcons
                                                                            .heart
                                                                            .fontFamily,
                                                                        package: CupertinoIcons
                                                                            .heart
                                                                            .fontPackage,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              snapshot.data!
                                                                      .data()![
                                                                  'title'],
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              snapshot.data!
                                                                      .data()![
                                                                  'content'],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 14),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(18),
                                                    bottomRight:
                                                        Radius.circular(18)),
                                                child: Image.network(
                                                  snapshot.data!
                                                      .data()!['thumbnailUrl'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    CupertinoButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child:
                                            Icon(CupertinoIcons.clear_circled),
                                        onPressed: () {
                                          setState(() {
                                            widget.postId = '';
                                          });
                                        })
                                  ],
                                );
                              });
                        }),
                const SizedBox(
                  height: 60,
                )
              ],
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: Get.width,
        height: 40,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: kDarkGreyColor,
          ),
          child: Row(children: [
            IconButton(
                onPressed: () {
                  if (image == null) {
                    pickImage();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: kDarkGreyColor,
                              title: const Text(
                                'Yalnızca bir resim ekleyebilirsiniz',
                                style: TextStyle(color: Colors.white),
                              ),
                              actions: [
                                CupertinoButton(
                                    color: kThemeColor,
                                    child: const Text('Geri'),
                                    onPressed: () {
                                      Get.back();
                                    })
                              ],
                            ));
                  }
                },
                icon: const Icon(
                  FeatherIcons.image,
                  color: Colors.grey,
                )),
          ]),
        ),
      ),
    );
  }

  audienceText() {
    if (audience[0][1]) {
      setState(() {
        audienceTxt = 'herkes';
      });
    } else if (audience[1][1]) {
      setState(() {
        audienceTxt = 'okul';
      });
    } else {
      setState(() {
        audienceTxt = 'hata';
      });
    }
  }
}

class Audience extends StatefulWidget {
  String title;
  String? subTitle;
  Color color;
  Icon icon;
  VoidCallback onTap;
  bool isActive;
  Audience(
      {super.key,
      required this.title,
      required this.color,
      required this.icon,
      required this.onTap,
      required this.isActive,
      this.subTitle});

  @override
  State<Audience> createState() => _AudienceState();
}

class _AudienceState extends State<Audience> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(15),
                    // image: DecorationImage(image: Image.)
                  ),
                  child: Center(child: widget.icon),
                ),
                widget.isActive
                    ? const Positioned(
                        bottom: -7,
                        right: -7,
                        child: CircleAvatar(
                          backgroundColor: kDarkGreyColor,
                          radius: 13,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: kThemeColor,
                            child: Icon(
                              CupertinoIcons.check_mark,
                              size: 14,
                            ),
                          ),
                        ))
                    : const SizedBox()
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  maxLines: 2,
                ),
                SizedBox(
                  width: Get.width - 30 - 10 - 50,
                  child: Text(
                    widget.subTitle!,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
