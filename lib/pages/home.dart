import 'package:cal/pages/create.dart';
import 'package:cal/pages/mobile_first_page.dart';
import 'package:cal/pages/mobile_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'desktop_app.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final scalesRef = FirebaseFirestore.instance.collection('scales');
final exploreRef = FirebaseFirestore.instance.collection('explore');
final personalWritings =
    FirebaseFirestore.instance.collection('personalWritings');
final Reference storageRefc = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');
final ideaRef = FirebaseFirestore.instance.collection('ideas');

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return MobileApp();
          } else {
            return DesktopApp();
          }
        },
      ),
    );
  }
}
