import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  String userProfilePictureUrl;
  String username;

  ChatItem({
    super.key,
    required this.userProfilePictureUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        onPressed: () {},
        child: Container(
          child: ListTile(
            leading: Image.network(userProfilePictureUrl),
            title: Text(
              username,
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey[900]!))),
        ));
  }
}
