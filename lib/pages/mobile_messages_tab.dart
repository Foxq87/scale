import 'package:cal/models/chat_item.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      appBar: navBar("Chats", '', null),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
            child: CupertinoSearchTextField(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.grey[900]!,
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          ListView(
            children: chats,
          )
        ],
      ),
    );
  }
}
