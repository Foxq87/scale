import 'package:cal/constants.dart';
import 'package:cal/models/user_model.dart';
import 'package:cal/pages/account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_list/toggle_list.dart';
import 'package:unicons/unicons.dart';

import '../pages/tests.dart';

drawer(UserModel user, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
        border:
            Border(right: BorderSide(width: 1.5, color: Colors.grey[900]!))),
    child: Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 40, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: const Icon(
                          CupertinoIcons.ellipsis_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => CupertinoTheme(
                              data: const CupertinoThemeData(
                                  brightness: Brightness.dark),
                              child: CupertinoActionSheet(
                                cancelButton: CupertinoActionSheetAction(
                                    child: const Text('Back'),
                                    onPressed: () {
                                      Get.back();
                                    }),
                                actions: [
                                  CupertinoActionSheetAction(
                                      child: const Text(
                                        'Sign Out',
                                        style: TextStyle(color: kThemeColor),
                                      ),
                                      onPressed: () {
                                        Get.back();
                                        FirebaseAuth.instance.signOut();
                                      })
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  user.username,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(user.email,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 15)),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.back();
              Get.to(() => Account(
                    profileId: user.id,
                    previousPageTitle: 'Home',
                  ));
            },
            child: const ListTile(
              leading:
                  Icon(CupertinoIcons.person, color: Colors.white, size: 25),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => Account(
                    profileId: user.id,
                    previousPageTitle: 'Home',
                  ));
            },
            child: const ListTile(
              leading: Icon(CupertinoIcons.bubble_left,
                  color: Colors.white, size: 25),
              title: Text(
                'Groups',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => Account(
                    profileId: user.id,
                    previousPageTitle: 'Home',
                  ));
            },
            child: const ListTile(
              leading:
                  Icon(CupertinoIcons.bookmark, color: Colors.white, size: 25),
              title: Text(
                'Bookmarks',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey[900],
            thickness: 1.2,
            endIndent: 15,
            indent: 15,
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => Account(
                    profileId: user.id,
                    previousPageTitle: 'Home',
                  ));
            },
            child: const ListTile(
              leading: Icon(UniconsLine.trophy, color: Colors.amber, size: 25),
              title: Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => Account(
                    profileId: user.id,
                    previousPageTitle: 'Home',
                  ));
            },
            child: const ListTile(
              leading: Icon(CupertinoIcons.bubble_left_bubble_right,
                  color: Colors.white, size: 25),
              title: Text(
                'Forum',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[900],
            thickness: 1.2,
            endIndent: 15,
            indent: 15,
          ),
          ToggleList(
              innerPadding: const EdgeInsets.symmetric(horizontal: 15),
              scrollPhysics: const NeverScrollableScrollPhysics(),
              scrollPosition: AutoScrollPosition.end,
              shrinkWrap: true,
              toggleAnimationDuration: const Duration(milliseconds: 200),
              scrollDuration: const Duration(milliseconds: 20),
              trailing: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  CupertinoIcons.chevron_down,
                  color: Colors.white,
                ),
              ),
              children: [
                ToggleListItem(
                  title: const Text(
                    'School Related',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Get.to(() => Tests(
                                previousPageTitle: 'Home',
                              ));
                        },
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.book,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Tests',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        child: const Row(
                          children: [
                            Icon(
                              UniconsLine.notebooks,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Notes',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ],
      ),
    ),
  );
}
