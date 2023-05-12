import 'dart:collection';
import 'dart:ui';

import 'package:cal/constants.dart';
import 'package:cal/models/question_model.dart';
import 'package:cal/widgets/nav_bar.dart';
import 'package:cal/widgets/navigate_to.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cal/models/question_model.dart';
import '../state_managers/data.dart';

class TestResults extends StatefulWidget {
  final List<int> results;
  final List<QuestionModel> questions;
  const TestResults({
    super.key,
    required this.results,
    required this.questions,
  });

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {
  @override
  void initState() {
    getCounts();
    super.initState();
  }

  int correctCount = 0;
  int wrongCount = 0;
  int blankCount = 0;
  double net = 0;

  void getCounts() {
    for (var element in widget.results) {
      if (element == 0) {
        setState(() {
          wrongCount++;
          net -= 1.33;
        });
      } else if (element == 1) {
        setState(() {
          correctCount++;
          net += 1;
        });
      } else {
        setState(() {
          blankCount++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: navBar(
        'Sonuçlar',
        '',
        leading: null,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.grey[900]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kDarkGreyColor,
                          border:
                              Border.all(width: 1.5, color: Colors.grey[900]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Doğru',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              correctCount.toString(),
                              style: const TextStyle(
                                  color: greenColor, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kDarkGreyColor,
                          border:
                              Border.all(width: 1.5, color: Colors.grey[900]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Yanlış',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              wrongCount.toString(),
                              style: const TextStyle(
                                  color: kThemeColor, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kDarkGreyColor,
                          border:
                              Border.all(width: 1.5, color: Colors.grey[900]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Boş',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              blankCount.toString(),
                              style: const TextStyle(
                                  color: Colors.amber, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kDarkGreyColor,
                    border: Border.all(width: 1.5, color: Colors.grey[900]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Net',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        net.toStringAsFixed(2),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            children: List.generate(
              widget.results.length,
              (index) => CupertinoButton(
                onPressed: () {
                  myNavigator(
                      ResultQuestionModel(
                          lesson: widget.questions[index].lesson,
                          unit: widget.questions[index].unit,
                          answer: widget.questions[index].answer,
                          choices: widget.questions[index].choices,
                          shownTo: widget.questions[index].shownTo,
                          title: widget.questions[index].title,
                          imageUrl: widget.questions[index].imageUrl,
                          index: index,
                          paragraph: widget.questions[index].paragraph),
                      context);
                },
                padding: EdgeInsets.zero,
                child: Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  decoration: BoxDecoration(
                    color: kDarkGreyColor,
                    border: Border.all(width: 0.5, color: Colors.grey[900]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (index + 1).toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 24),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: widget.results[index] == 1
                                          ? greenColor
                                          : widget.results[index] == 0
                                              ? Colors.red
                                              : Colors.amber),
                                  borderRadius: BorderRadius.circular(10)),
                              child: widget.results[index] == 1
                                  ? const Icon(
                                      CupertinoIcons.check_mark,
                                      color: greenColor,
                                      size: 23,
                                    )
                                  : widget.results[index] == 0
                                      ? const Icon(
                                          CupertinoIcons.clear,
                                          color: Colors.red,
                                          size: 23,
                                        )
                                      : const Icon(
                                          CupertinoIcons.question,
                                          color: Colors.amber,
                                          size: 23,
                                        ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[900],
                        thickness: 1,
                        height: 5,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5, color: Colors.grey[900]!),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 40,
                                child: CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    color: kDarkGreyColor,
                                    child: const Text('Çözüm'),
                                    onPressed: () {}),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            //add question to saved questions
                          },
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.5, color: Colors.grey[900]!),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.bookmark,
                                      color: kThemeColor,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Soruyu Kaydet',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultQuestionModel extends StatefulWidget {
  final int index;
  final int lesson;
  final int unit;
  final String title;
  final String imageUrl;
  final String paragraph;
  final int answer;
  final List choices;
  final List shownTo;

  const ResultQuestionModel({
    super.key,
    required this.lesson,
    required this.unit,
    required this.answer,
    required this.choices,
    required this.shownTo,
    required this.title,
    required this.imageUrl,
    required this.index,
    required this.paragraph,
  });

  @override
  State<ResultQuestionModel> createState() => _ResultQuestionModelState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;
List<int> answers2 = [];
List<int> myAnswers2 = [];

class _ResultQuestionModelState extends State<ResultQuestionModel> {
  @override
  void initState() {
    makePointsReady();
    addToShowns();
    super.initState();
  }

  void addToShowns() {}
  Color selectedColor = Colors.red;
  double strokeWidth = 5;

  List<Color> colors = [
    Colors.white,
    Colors.red,
    Colors.black,
    Colors.amberAccent,
    Colors.green,
  ];
  void makePointsReady() =>
      Provider.of<Data>(context, listen: false).makePointsReady(0);
  void updatePoints(drawingPoint, index) =>
      Provider.of<Data>(context, listen: false)
          .addToDrawingPoints(drawingPoint, index);
  void takeBack(index) =>
      Provider.of<Data>(context, listen: false).takeBack(index);
  void clearScreen(int index) =>
      Provider.of<Data>(context, listen: false).clearScreen(index);

  @override
  Widget build(BuildContext context) {
    List<List<DrawingPoint?>> drawingPoints =
        Provider.of<Data>(context).drawingPoints;

    return Scaffold(
      appBar: navBar("Soru", 'Geri'),
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.grey[900]!),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        (widget.index + 1).toString(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.imageUrl.isEmpty
                        ? const SizedBox()
                        : Image.network(
                            widget.imageUrl,
                            color: Colors.white,
                            fit: BoxFit.cover,
                            height: Get.height / 3.5,
                          ),
                    Text(
                      widget.paragraph,
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 7, 7, 7),
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(color: Colors.grey[900]!, width: 2))),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  itemCount: widget.choices.length,
                  itemBuilder: (context, i) {
                    return choiceItem(widget.choices[i], i, widget.index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  choiceItem(String text, int i, int questionIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: answers.isNotEmpty
                  ? answers[questionIndex] == i
                      ? kThemeColor
                      : Colors.grey[900]!
                  : Colors.grey[900]!),
          color: kDarkGreyColor,
          borderRadius: BorderRadius.circular(18)),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              i == widget.answer
                  ? Row(
                      children: [
                        Icon(
                          CupertinoIcons.check_mark,
                          color: greenColor,
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  : SizedBox(),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 45 : 40,
        width: isSelected ? 45 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i] != null && drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
