import 'package:cal/models/chat_item.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'home.dart';

class MobileMessagesTab extends StatefulWidget {
  const MobileMessagesTab({super.key});

  @override
  State<MobileMessagesTab> createState() => _MobileMessagesTabState();
}

class _MobileMessagesTabState extends State<MobileMessagesTab> {
  @override
  void initState() {
    fetchData();
    super.initState();
  }

  bool isLoading = false;
  List<Widget> chats = [];
  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot postSnapshot = await exploreRef.get();
    setState(() {
      chats = postSnapshot.docs
          .map((doc) => ChatItem(
                userProfilePictureUrl: doc['userProfilePictureUrl'],
                username: doc['username'],
              ))
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: navBar("Chats", '',  elevation: true,),
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.grey[900]!,
                        ),
                        shape: BoxShape.circle),
                    child: Center(
                      child: const Icon(
                        CupertinoIcons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: CupertinoSearchTextField(
                      style: TextStyle(color: Colors.white),
                      prefixIcon: const SizedBox(),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey[900]!,
                          ),
                          borderRadius: kCircleBorderRadius),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView(
            shrinkWrap: true,
            children: chats,
          )
        ],
      ),
    );
  }
}
