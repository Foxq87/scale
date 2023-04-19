import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  int time;
  String lesson;

  String subtopic;
  int questionCount;
  TestPage({
    super.key,
    required this.lesson,
    required this.questionCount,
    required this.time,
    required this.subtopic,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(widget.lesson),
          Text(widget.questionCount.toString()),
          Text(widget.subtopic),
          Text(widget.time.toString()),
        ],
      ),
    );
  }
}
