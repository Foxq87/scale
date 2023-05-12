import 'dart:io';

import 'package:cal/constants.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/question_model.dart';
import 'home.dart';

class MobileNewPostTab extends StatefulWidget {
  String title;
  String content;
  MobileNewPostTab({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<MobileNewPostTab> createState() => _MobileNewPostTabState();
}

class _MobileNewPostTabState extends State<MobileNewPostTab> {
  @override
  void initState() {
    // TODO: implement initState
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    super.initState();
  }

  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem<String>(
      value: 'High',
      child: Text(
        'High',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
    const DropdownMenuItem<String>(
      value: 'Medium',
      child: Text(
        'Medium',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
    const DropdownMenuItem<String>(
      value: 'Low',
      child: Text(
        'Low',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    )
  ];
  bool isSaved = true;
  bool showDropdown = false;
  String priority = 'Medium';


  String currentDocId = '';
  TextEditingController ideaController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? image;
  String url = '';

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => this.image = imageTemporary);
  }

  Future<void> handleDatabase(String postId) async {
    try {
      final storageImage = FirebaseStorage.instance
          .ref()
          .child('thumbnails')
          .child('$postId.jpg');
      var task = storageImage.putFile(image!);

      exploreRef.doc(postId).set({
        "thumbnailUrl":
            await (await task.whenComplete(() => null)).ref.getDownloadURL(),
        "postId": postId,
        "title": titleController.text,
        "content": contentController.text,
        "writerId": uid,
        "views": [],
        "timestamp": DateTime.now(),
        "likes": {},
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CupertinoNavigationBar(
        trailing: SizedBox(
          height: 32,
          child: CupertinoButton(
            child: const Text('Add'),
            onPressed: () {
              String postId = const Uuid().v4();
              try {
                personalWritings
                    .doc(uid)
                    .collection('writings')
                    .doc(postId)
                    .set({
                  "postId": postId,
                  "content": '',
                  "thumbnailUrl": url,
                  "writerId": uid,
                  "views": [],
                  "timestamp": DateTime.now(),
                  "title": ideaController.text,
                  "priority": priority,
                  "priorityId": priorityNum(priority),
                });
                ideaController.clear();
              } catch (e) {}
            },
            padding: const EdgeInsets.symmetric(horizontal: 15),
            color: kThemeColor,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        border: const Border(
            bottom: BorderSide(color: CupertinoColors.systemGrey, width: 0.25)),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19).withOpacity(0.9),
        automaticallyImplyLeading: false,
        previousPageTitle: '',
        middle: const Text(
          'Ideas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    textInputAction: TextInputAction.next,
                    placeholder: 'Idea..',
                    placeholderStyle: const TextStyle(color: Colors.grey),
                    controller: ideaController,
                    cursorColor: kThemeColor,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 2, color: Colors.grey[900]!),
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.grey[900]!),
                        borderRadius: BorderRadius.circular(15)),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(15),
                      hint: Text(
                        priority,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      underline: const SizedBox(),
                      dropdownColor: kDarkGreyColor,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                      icon: const Icon(
                        CupertinoIcons.flag,
                        color: kThemeColor,
                      ),
                      items: items,
                      onChanged: (String? val) {
                        if (val != null) {
                          setState(() {
                            priority = val;
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: personalWritings
                  .doc(uid)
                  .collection('writings')
                  .orderBy('priorityId', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loading();
                }
                return SizedBox(
                  height: 190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return idea(
                        snapshot.data!.docs[index]['title'],
                        snapshot.data!.docs[index]['priority'],
                        snapshot.data!.docs[index]['postId'],
                        snapshot.data!.docs[index]['title'],
                        snapshot.data!.docs[index]['content'],
                      );
                    },
                  ),
                );
              }),
          const SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 2,
            color: Colors.grey[900],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: kDarkGreyColor,
                border: Border.all(width: 2, color: Colors.grey[900]!),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Newsletter · ',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          isSaved
                              ? const Text(
                                  'All saved',
                                  style: TextStyle(color: greenColor),
                                )
                              : const Text(
                                  'Saving..',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                        child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: kThemeColor,
                            child: const Text('Publish'),
                            onPressed: () {
                              if (titleController.text.isEmpty) {
                                showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => CupertinoTheme(
                                    data: const CupertinoThemeData(
                                        brightness: Brightness.dark),
                                    child: CupertinoAlertDialog(
                                      title: const Text(
                                          "There's nothing to publish"),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Back',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context) => CupertinoTheme(
                                    data: const CupertinoThemeData(
                                        brightness: Brightness.dark),
                                    child: CupertinoAlertDialog(
                                      title: const Text("Upload thumbnail"),
                                      content: Text(
                                          'Before pulishing "${titleController.text}" publicly available you have to upload a thumbnail'),
                                      actions: [
                                        CupertinoDialogAction(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: kThemeColor),
                                            )),
                                        CupertinoDialogAction(
                                            onPressed: () async {
                                              // publishPost(currentDocId);
                                              //publish document
                                              pickImage();
                                              Get.back();
                                              await showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoTheme(
                                                  data:
                                                      const CupertinoThemeData(
                                                          brightness:
                                                              Brightness.dark),
                                                  child: CupertinoAlertDialog(
                                                    title: const Text(
                                                        "Are you sure?"),
                                                    content: Text(
                                                        'You are making "${titleController.text}" publicly available.'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color:
                                                                    kThemeColor),
                                                          )),
                                                      CupertinoDialogAction(
                                                          onPressed: () {
                                                            handleDatabase(
                                                                currentDocId);

                                                            //publish document
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                            'Publish',
                                                            style: TextStyle(
                                                                color:
                                                                    greenColor),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                              Get.back();
                                            },
                                            child: const Text(
                                              'Upload',
                                              style:
                                                  TextStyle(color: greenColor),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                      )
                    ],
                  ),
                ),
                CupertinoTextField(
                  onChanged: (content) async {
                    setState(() {
                      isSaved = false;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    try {
                      updateDatabase();
                    } catch (e) {}
                    setState(() {
                      isSaved = true;
                    });
                  },
                  placeholder: 'Title',
                  placeholderStyle: TextStyle(color: Colors.grey[700]),
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  cursorColor: kThemeColor,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                CupertinoTextField(
                  onChanged: (content) async {
                    setState(() {
                      isSaved = false;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    try {
                      updateDatabase();
                    } catch (e) {}
                    setState(() {
                      isSaved = true;
                    });
                  },
                  placeholder: 'Content',
                  placeholderStyle: TextStyle(color: Colors.grey[700]),
                  textInputAction: TextInputAction.newline,
                  controller: contentController,
                  cursorColor: kThemeColor,
                  minLines: 1,
                  maxLines: 999999,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateDatabase() {
    String postId = const Uuid().v4();

    print(currentDocId);
    personalWritings
        .doc(uid)
        .collection('writings')
        .doc(currentDocId)
        .get()
        .then((doc) {
      if (doc.exists) {
        personalWritings
            .doc(uid)
            .collection('writings')
            .doc(currentDocId)
            .update({
          "title": titleController.text,
          "content": contentController.text,
        });
      } else {
        personalWritings.doc(uid).collection('writings').doc(postId).set({
          "postId": postId,
          "title": titleController.text,
          "content": contentController.text,
          "thumbnailUrl":
              'https://cdn.dribbble.com/userupload/4006281/file/original-1fa5190f4c0fe085a852e6d0e46f739f.png?compress=1&resize=1024x1024',
          "writerId": uid,
          "views": [],
          "timestamp": DateTime.now(),
        });
      }
    });
  }

  idea(
    String idea,
    String priority,
    String id,
    String title,
    String content,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        setState(() {
          currentDocId = id;
          titleController = TextEditingController(text: title);
          contentController = TextEditingController(text: content);
        });
      },
      child: Slidable(
        endActionPane: ActionPane(motion: const BehindMotion(), children: [
          SlidableAction(
              icon: CupertinoIcons.delete,
              foregroundColor: kThemeColor,
              backgroundColor: Colors.transparent,
              onPressed: (context) {
                personalWritings
                    .doc(uid)
                    .collection('writings')
                    .doc(id)
                    .delete();
              }),
        ]),
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
                idea,
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
                        border: Border.all(
                            width: 1, color: priorityColor(priority))),
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
      ),
    );
  }
}

Color priorityColor(String priority) {
  if (priority == "Low") {
    return kThemeColor;
  } else if (priority == "Medium") {
    return Colors.amber;
  } else if (priority == "High") {
    return greenColor;
  } else {
    return Colors.transparent;
  }
}

int priorityNum(String priority) {
  if (priority == "Low") {
    return 1;
  } else if (priority == "Medium") {
    return 2;
  } else if (priority == "High") {
    return 3;
  } else {
    return 0;
  }
}
