import 'package:cal/models/question_model.dart';
import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  bool logIn = true;
  List<Widget> route = [];
  int routeIndex = 0;
  bool isHome = true;
  bool notFocused = true;
  int questionCount = 0;
  List<List<DrawingPoint?>> drawingPoints = [];
  PageController testPageController = PageController();

  void updateFocusStatus() {
    notFocused = !notFocused;
    notifyListeners();
  }

  void addToDrawingPoints(DrawingPoint? drawingPoint, index) {
    drawingPoints[index].add(drawingPoint);
    notifyListeners();
  }

  void takeBack(int index) {
    if (drawingPoints[index].length > 5) {
      drawingPoints[index].removeRange(
          drawingPoints[index].length - 5, drawingPoints[index].length);
    } else {
      drawingPoints[index].removeRange(
          drawingPoints[index].length - 1, drawingPoints[index].length);
    }

    print(drawingPoints);
    notifyListeners();
  }

  void makePointsReady(int myQuestionCount) {
    cleanAllPoints();
    if (myQuestionCount != 0) {
      for (var i = 0; i < myQuestionCount; i++) {
        drawingPoints.add([]);
      }
    } else {
      for (var i = 0; i < questionCount; i++) {
        drawingPoints.add([]);
      }
    }
  }

  void cleanAllPoints() {
    drawingPoints.clear();

    notifyListeners();
  }

  void clearScreen(int index) {
    drawingPoints[index] = [];
    notifyListeners();
  }

  void updateQuestionCount(int value) {
    questionCount = value;
    notifyListeners();
  }

  void setScreen(Widget widget) {
    if (!route.contains(widget) // && widget.runtimeType != PostDetails
        ) {
      route.add(widget);

      routeIndex = route.indexOf(widget);

      isHome = false;
      print(route);
      print(routeIndex);
    } else {
      routeIndex = route.indexOf(widget);
    }

    notifyListeners();
  }

  void back() {
    if (route.isNotEmpty && routeIndex == 0) {
      isHome = true;
    } else if (route.length > 1) {
      routeIndex--;
    }
    print(routeIndex);
    notifyListeners();
  }

  void updateSigningChoice(bool choice) {
    logIn = choice;
    notifyListeners();
  }
}
