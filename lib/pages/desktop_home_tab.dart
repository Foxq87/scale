import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import 'desktop_app.dart';
import 'home.dart';

class DesktopHomeTab extends StatefulWidget {
  bool isExpanded;
  DesktopHomeTab({super.key, required this.isExpanded});

  @override
  State<DesktopHomeTab> createState() => _DesktopHomeTabState();
}

class _DesktopHomeTabState extends State<DesktopHomeTab> {
  @override
  Widget build(BuildContext context) {
    double systemWidth = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: exploreRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: systemWidth < 750 && widget.isExpanded
                  ? 1
                  : systemWidth < 1300
                      ? 2
                      : systemWidth < 1750
                          ? 3
                          : systemWidth > 2350 && systemWidth < 3000
                              ? 5
                              : 4,
            ),
            padding: EdgeInsets.only(right: 15),
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final listOfDocumentSnapshot = snapshot.data!.docs[index];
              return Post(
                title: listOfDocumentSnapshot['title'],
                thumbnailUrl: listOfDocumentSnapshot['thumbnailUrl'],
                content: listOfDocumentSnapshot['content'],
                writerId: listOfDocumentSnapshot['writerId'],
                timestamp: listOfDocumentSnapshot['timestamp'],
                views: listOfDocumentSnapshot['views'],
                postId: listOfDocumentSnapshot['postId'],
                likes: listOfDocumentSnapshot['likes'],
              );
            },
          );
        });
  }
}
