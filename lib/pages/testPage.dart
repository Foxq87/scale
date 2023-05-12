import 'dart:async';

import 'package:cal/pages/create.dart';
import 'package:cal/pages/home.dart';
import 'package:cal/pages/test_results.dart';
import 'package:cal/questions/questions.dart';
import 'package:cal/state_managers/data.dart';
import 'package:cal/widgets/loading.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cal/widgets/navigate_to.dart';
import 'package:cal/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../models/question_model.dart';

class TestPage extends StatefulWidget {
  int time;
  int lesson;
  int unit;
  int questionCount;

  TestPage({
    super.key,
    required this.lesson,
    required this.questionCount,
    required this.time,
    required this.unit,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool done = false;
  bool timeUp = false;
  late int second = 0;
  late int minute = widget.time;

  bool isLoading = false;

  int length = 0;

  // List<Widget> questionList = [];

  counter() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (Duration(minutes: minute, seconds: second).isNegative) {
        setState(() {
          timeUp = true;
        });
      } else {
        setState(() {
          second--;
        });
      }
    });
    return Text(
      second.toString(),
      style: const TextStyle(color: Colors.white),
    );
  }

  String formatted(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    // TODO: implement initState
    // getProfilePosts();
    counter();
    print(widget.time);
    super.initState();
  }

  String lesson(int lessonIndex) {
    String lesson = '';
    switch (lessonIndex) {
      case 0:
        lesson = 'Edebiyat';
        break;
      case 1:
        lesson = 'Metmatik';
        break;

      case 2:
        lesson = 'Tarih';
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      default:
    }
    return lesson;
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    bool notFocused = Provider.of<Data>(context).notFocused;
    PageController testPageController =
        Provider.of<Data>(context).testPageController;
    return StreamBuilder(
        stream: questionsRef
            .where("lesson", isEqualTo: widget.lesson)
            .where("unit", isEqualTo: widget.unit)
            .limit(widget.questionCount)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return loading();
          }
          return Scaffold(
              backgroundColor: Colors.black,
              appBar: timeUp
                  ? null
                  : navBar(
                      lesson(widget.lesson),
                      '',
                      leading: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            CupertinoIcons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // updateDatabase();
                            answers.clear();
                            Provider.of<Data>(context, listen: false)
                                .cleanAllPoints();

                            Get.back();
                          }),
                      elevation: false,
                      trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(
                            UniconsLine.upload,
                            size: 20,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: kDarkGreyColor,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              builder: (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20.0, 20.0, 20.0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              color: Colors.grey[200],
                                              fontSize: 20),
                                        ),
                                        CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            child: Icon(
                                              CupertinoIcons.clear_circled,
                                              size: 27,
                                              color: Colors.grey[600],
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            })
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.grey[900],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              margin: EdgeInsets.only(left: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[900]!,
                                                  ),
                                                  color: kDarkGreyColor),
                                              child: Icon(
                                                CupertinoIcons
                                                    .bubble_left_bubble_right,
                                                color: kThemeColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              child: Text(
                                                'Forum\'da Paylaş',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              margin: EdgeInsets.only(left: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[900]!,
                                                  ),
                                                  color: kDarkGreyColor),
                                              child: Icon(
                                                CupertinoIcons.mail,
                                                color: kThemeColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              child: Text(
                                                'Mesajla Paylaş',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey[900]!,
                                                  ),
                                                  color: kDarkGreyColor),
                                              child: Icon(
                                                CupertinoIcons.ellipsis_circle,
                                                color: kThemeColor,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 60,
                                              child: Text(
                                                'Diğer',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 40,
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
              body: timeUp
                  ? buildTimeUpScreen()
                  : Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 19, 19, 19)
                                  .withOpacity(0.9),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey[900]!))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 7),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.grey[900]!),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          formatted(
                                            Duration(
                                              minutes: minute,
                                              seconds: second,
                                            ),
                                          ).toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (val) {
                              setState(() {
                                index = val;
                              });
                            },
                            controller: testPageController,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return QuestionModel(
                                lesson: snapshot.data!.docs[index]['lesson'],
                                unit: snapshot.data!.docs[index]['unit'],
                                paragraph: snapshot.data!.docs[index]
                                    ['paragraph'],
                                answer: snapshot.data!.docs[index]['answer'],
                                choices: snapshot.data!.docs[index]['choices'],
                                shownTo: snapshot.data!.docs[index]['shownTo'],
                                title: snapshot.data!.docs[index]['title'],
                                imageUrl: snapshot.data!.docs[index]
                                    ['imageUrl'],
                                index: index,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              bottomNavigationBar: timeUp
                  ? null
                  : Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                            top:
                                BorderSide(width: 1, color: Colors.grey[900]!)),
                        color: kDarkGreyColor,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  color: kThemeColor,
                                  borderRadius: kCircleBorderRadius,
                                  child: Text(
                                    'Testi bitir',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    showCupertinoDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) => CupertinoTheme(
                                        data: CupertinoThemeData(
                                            brightness: Brightness.dark),
                                        child: CupertinoAlertDialog(
                                          title: Text(
                                            'Uyarı',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          content: Text(
                                            'Testi bitirmek istediğinize emin misiniz?',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          actions: [
                                            CupertinoDialogAction(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  'Geri',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                )),
                                            CupertinoDialogAction(
                                                onPressed: () {
                                                  List<QuestionModel>
                                                      testQuestions = [];
                                                  for (var element
                                                      in snapshot.data!.docs) {
                                                    setState(() {
                                                      testQuestions.add(QuestionModel(
                                                          lesson: element
                                                              .data()['lesson'],
                                                          unit: element
                                                              .data()['unit'],
                                                          answer: element
                                                              .data()['answer'],
                                                          choices:
                                                              element.data()[
                                                                  'choices'],
                                                          shownTo:
                                                              element.data()[
                                                                  'shownTo'],
                                                          title: element
                                                              .data()['title'],
                                                          imageUrl:
                                                              element.data()[
                                                                  'imageUrl'],
                                                          index: index,
                                                          paragraph: element
                                                                  .data()[
                                                              'paragraph']));
                                                    });
                                                  }

                                                  Get.back();
                                                  myNavigator(
                                                      TestResults(
                                                        results: myAnswers,
                                                        questions:
                                                            testQuestions,
                                                      ),
                                                      context);
                                                },
                                                child: Text(
                                                  'Bitir',
                                                  style: TextStyle(
                                                      color: kThemeColor),
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CupertinoButton(
                              child: Icon(CupertinoIcons.delete),
                              onPressed: () {
                                Provider.of<Data>(context, listen: false)
                                    .clearScreen(index);
                              }),
                          Container(
                            decoration: notFocused
                                ? BoxDecoration(
                                    borderRadius: kCircleBorderRadius,
                                    border: Border.all(
                                        width: 2, color: Colors.transparent))
                                : BoxDecoration(
                                    borderRadius: kCircleBorderRadius,
                                    border: Border.all(
                                        width: 2, color: Colors.grey[900]!)),
                            child: CupertinoButton(
                                borderRadius: kCircleBorderRadius,
                                padding: EdgeInsets.zero,
                                child: Icon(CupertinoIcons.pen),
                                onPressed: () {
                                  Provider.of<Data>(context, listen: false)
                                      .updateFocusStatus();
                                }),
                          ),
                          CupertinoButton(
                              child: Icon(CupertinoIcons.back),
                              onPressed: () {
                                testPageController.animateToPage(
                                    index != 0 ? index - 1 : 0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              }),
                          CupertinoButton(
                              child: Icon(CupertinoIcons.forward),
                              onPressed: () {
                                testPageController.animateToPage(
                                    index + 1 < widget.questionCount
                                        ? index + 1
                                        : widget.questionCount - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.linear);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ));
        });
  }

  buildTimeUpScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Spacer(),
        Center(
          child: Text(
            'Time is Up!',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
        Spacer(),
        CupertinoButton(
            child: Text('Geri'),
            onPressed: () {
              Get.back();
            }),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
