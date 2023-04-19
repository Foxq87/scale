import 'package:cal/constants.dart';
import 'package:cal/pages/create.dart';
import 'package:cal/pages/mobile_first_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:timeago/timeago.dart';
import 'package:unicons/unicons.dart';
import '';
import '../widgets/loading.dart';
import 'desktop_app.dart';
import 'home.dart';
import 'library.dart';
import 'mobile_messages_tab.dart';
import 'mobile_search_tab.dart';

class MobileApp extends StatefulWidget {
  const MobileApp({super.key});

  @override
  State<MobileApp> createState() => _MobileAppState();
}

final exploreRef = FirebaseFirestore.instance.collection('explore');
// newPostTab() {
//   personalWritings.doc(uid).get().then(
//     (doc) {
//       if (doc.exists) {
//         return MobileNewPostTab(
//           title: doc.data()!['title'],
//           content: doc.data()!['content'],
//         );
//       } else {
//         return MobileNewPostTab(title: 's', content: '');
//       }
//     },
//   );
// }

class _MobileAppState extends State<MobileApp> {
  PersistentTabController tabController = PersistentTabController();
  int i = 0;
  List<Widget> screens() {
    return [
      //Home
      const MobileFirstPage(),
      const Activity(),
      //Notifications
      StreamBuilder(
          stream: personalWritings
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return loading();
            }
            return MobileNewPostTab(title: '', content: '');
          }),

      const MobileMessagesTab(),
      const Library(),

      //Search

      //Messages
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: view(),
    );
  }

  view() {
    return PersistentTabView(
      context,
      hideNavigationBarWhenKeyboardShows: true,

      navBarStyle: NavBarStyle.simple,

      navBarHeight: 55,

      confineInSafeArea: true,
      
      decoration: NavBarDecoration(
          border: Border(top: BorderSide(width: 1.5, color: Colors.grey[900]!)),
          colorBehindNavBar: kDarkGreyColor.withOpacity(0.6)),
      padding: NavBarPadding.only(top: 20, bottom: 20),
      screens: screens(),

      // elevation: 2.0,

      backgroundColor: Colors.black,
      controller: tabController,
      items: [
        PersistentBottomNavBarItem(
          inactiveColorPrimary: Colors.grey,
          activeColorPrimary: Colors.white,
          icon: Transform.scale(
            scale: 1.7,
            child: Image.asset(
              'assets/inbox.png',
              width: 50,
              height: 50,
              color: i == 0 ? Colors.white : Colors.grey,
            ),
          ),
        ),
        PersistentBottomNavBarItem(
          icon: Transform.scale(
            scale: 1.7,
            child: Image.asset(
              'assets/bell.png',
              width: 50,
              height: 50,
              color: i == 1 ? Colors.white : Colors.grey,
            ),
          ),
        ),
        PersistentBottomNavBarItem(
          icon: Transform.scale(
            scale: 1.7,
            child: Image.asset(
              'assets/note.png',
              width: 50,
              height: 50,
              color: i == 2 ? Colors.white : Colors.grey,
            ),
          ),
        ),
        PersistentBottomNavBarItem(
          icon: Transform.scale(
            scale: 2,
            child: Image.asset(
              'assets/mail.png',
              width: 50,
              height: 50,
              color: i == 3 ? Colors.white : Colors.grey,
            ),
          ),
        ),
        PersistentBottomNavBarItem(
          icon: Transform.scale(
            scale: 1.7,
            child: Image.asset(
              'assets/square-split-2x1.png',
              width: 50,
              height: 50,
              color: i == 4 ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ],
      onItemSelected: (index) {
        setState(() {
          i = index;
        });
      },
    );
  }
}
