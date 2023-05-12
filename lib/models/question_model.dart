import 'dart:ui';

import 'package:cal/constants.dart';
import 'package:cal/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../questions/questions.dart';
import '../state_managers/data.dart';

class QuestionModel extends StatefulWidget {
  final int index;
  final int lesson;
  final int unit;
  final String title;
  final String imageUrl;
  final String paragraph;
  final int answer;
  final List choices;
  final List shownTo;

  const QuestionModel({
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
  State<QuestionModel> createState() => _QuestionModelState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;
List<int> answers = [];
List<int> myAnswers = [];

class _QuestionModelState extends State<QuestionModel> {
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
    bool notFocused = Provider.of<Data>(context).notFocused;
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SizedBox(
                height: 20,
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
          notFocused
              ? const SizedBox()
              : GestureDetector(
                  onPanStart: (details) {
                    updatePoints(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                        widget.index);
                  },
                  onPanUpdate: (details) {
                    updatePoints(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                        widget.index);
                  },
                  onPanEnd: (details) {
                    setState(() {
                      updatePoints(null, widget.index);
                    });
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(drawingPoints[widget.index]),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
          notFocused
              ? const SizedBox()
              : Positioned(
                  bottom: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    decoration: BoxDecoration(
                      color: kDarkGreyColor,
                      border: Border.all(width: 2, color: Colors.grey[900]!),
                      borderRadius: kCircleBorderRadius,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: Icon(CupertinoIcons.restart),
                            onPressed: () {
                              takeBack(widget.index);
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            colors.length,
                            (index) => _buildColorChose(colors[index]),
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            activeColor: kThemeColor,
                            thumbColor: Colors.white,
                            min: 0,
                            max: 40,
                            value: strokeWidth,
                            onChanged: (val) =>
                                setState(() => strokeWidth = val),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        onPressed: () {
          int blankQuestionIndex = 5;
          if (answers.isEmpty) {
            int count = Provider.of<Data>(context, listen: false).questionCount;

            for (var i = 0; i < count; i++) {
              setState(() {
                answers.add(blankQuestionIndex);
                myAnswers.add(blankQuestionIndex);
              });
            }
          }
          if (answers.isNotEmpty && answers[questionIndex] == i) {
            setState(() {
              answers[questionIndex] = blankQuestionIndex;
              myAnswers[questionIndex] = blankQuestionIndex;
            });
          } else {
            setState(() {
              answers[questionIndex] = i;
            });
            if (i == 5) {
              setState(() {
                myAnswers[questionIndex] = 2;
              });
            } else if (i == widget.answer) {
              setState(() {
                myAnswers[questionIndex] = 1;
              });
            } else if (i != widget.answer) {
              setState(() {
                myAnswers[questionIndex] = 0;
              });
            }
          }

          print(answers);
          print('s $myAnswers');
        },
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

class DrawingBoard extends StatefulWidget {
  @override
  _DrawingBoardState createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  Color selectedColor = Colors.red;
  bool notFocused = true;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          notFocused
              ? const SizedBox()
              : GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      drawingPoints.add(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                      );
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      drawingPoints.add(
                        DrawingPoint(
                          details.localPosition,
                          Paint()
                            ..color = selectedColor
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth
                            ..strokeCap = StrokeCap.round,
                        ),
                      );
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      drawingPoints.add(null);
                    });
                  },
                  child: CustomPaint(
                    painter: _DrawingPainter(drawingPoints),
                    child: Container(),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
              (index) => _buildColorChose(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
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

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
