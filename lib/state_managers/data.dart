import 'package:flutter/material.dart';

class Data with ChangeNotifier {
  bool logIn = true;
  List<Widget> route = [];
  int routeIndex = 0;
  bool isHome = true;

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
