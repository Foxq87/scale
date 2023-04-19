import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import 'desktop_app.dart';
import 'home.dart';

class DesktopNewPostTab extends StatefulWidget {
  const DesktopNewPostTab({super.key});

  @override
  State<DesktopNewPostTab> createState() => _DesktopNewPostTabState();
}

class _DesktopNewPostTabState extends State<DesktopNewPostTab> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 25.0, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 32,
                child: CupertinoButton(
                  child: Text('Save'),
                  onPressed: () {
                    String postId = Uuid().v4();
                    try {
                      exploreRef.doc(postId).set({
                        "postId": postId,
                        "title": titleController.text,
                        "content": contentController.text,
                        "thumbnailUrl":
                            'https://cdn.dribbble.com/userupload/4006281/file/original-1fa5190f4c0fe085a852e6d0e46f739f.png?compress=1&resize=1024x1024',
                        "writerId": uid,
                        "writerImageUrl":
                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                        "views": 1,
                        "timestamp": DateTime.now(),
                      });
                    } catch (e) {}
                  },
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  color: kThemeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 10 / 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
                border: Border.all(color: kThemeColor),
                borderRadius: BorderRadius.circular(15)),
            child: Icon(
              CupertinoIcons.photo,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        CupertinoTextField(
          textInputAction: TextInputAction.next,
          placeholder: 'Title',
          placeholderStyle: TextStyle(color: Colors.grey),
          controller: titleController,
          cursorColor: kThemeColor,
          style: TextStyle(fontSize: 30, color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
        CupertinoTextField(
          placeholder: 'Content',
          placeholderStyle: TextStyle(color: Colors.grey),
          textInputAction: TextInputAction.newline,
          controller: contentController,
          cursorColor: kThemeColor,
          minLines: 1,
          maxLines: 999999,
          style: TextStyle(fontSize: 20, color: Colors.white),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
