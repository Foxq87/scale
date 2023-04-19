import 'dart:ui';

import 'package:cal/constants.dart';
import 'package:cal/models/post_model.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  String profileId;
  String previousPageTitle;
  Account(
      {super.key, required this.profileId, required this.previousPageTitle});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: usersRef.doc(widget.profileId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          UserModel user = UserModel.fromDocument(snapshot.data!);
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: navBar(user.username, widget.previousPageTitle, null),
            body: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              user.imageUrl,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(width: 2, color: kThemeColor)),
                              child: CupertinoButton(
                                  borderRadius: kCircleBorderRadius,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      'Subscribe',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {}),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        user.username,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: Colors.grey[900],
                  thickness: 2,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Posts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder(
                  future: exploreRef
                      .where('writerId', isEqualTo: widget.profileId)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return loading();
                    }
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final listOfDocumentSnapshot =
                              snapshot.data!.docs[index];

                          return PostMobile(
                            title: listOfDocumentSnapshot['title'],
                            thumbnailUrl:
                                listOfDocumentSnapshot['thumbnailUrl'],
                            content: listOfDocumentSnapshot['content'],
                            writerId: listOfDocumentSnapshot['writerId'],
                            timestamp: listOfDocumentSnapshot['timestamp'],
                            views: listOfDocumentSnapshot['views'],
                            postId: listOfDocumentSnapshot['postId'],
                            likes: listOfDocumentSnapshot['likes'],
                          );
                        });
                  },
                )
              ],
            ),
          );
        });
  }
}
