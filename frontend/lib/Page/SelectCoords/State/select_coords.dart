// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class SelectCoordsModel extends ChangeNotifier {
  bool selectMode = true;
  List entranceCoords = [99.0, 99.0];
  List exitCoords = [99.0, 99.0];
  List imageCoords = [0,0];

  void newMode(bool mode) {
    selectMode = mode;
    notifyListeners();
  }

  void setCoords(double x, double y) {
    x = (x * 100).round() / 100;
    y = (y * 100).round() / 100;
    if (selectMode)
      entranceCoords = [x, y];
    else
      exitCoords = [x, y];

    notifyListeners();
  }
}
