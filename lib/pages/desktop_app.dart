import 'package:cal/pages/create.dart';
import 'package:cal/pages/desktop_newpost_tab.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/pages/mobile_first_page.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

import 'desktop_first_page.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({super.key});

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}



class _DesktopAppState extends State<DesktopApp> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int _currentIndex = 0;
  List screens = [
    //Home
    const DesktopFirstPage(),

    //Notifications
    DesktopNewPostTab(),

    //Search

    //Messages
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
    );
  }
}
