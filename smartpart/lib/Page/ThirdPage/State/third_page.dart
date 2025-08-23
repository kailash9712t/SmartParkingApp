import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartpart/Widgets/snackbar.dart';

class ThirdPageModel extends ChangeNotifier {
  String? space;
  String? entrance;
  String? exit;

  void setSpace(String newSpace) {
    space = newSpace;
  }

  void setEntrance(String newEntrance) {
    entrance = newEntrance;
  }

  void setExit(String newExit) {
    exit = newExit;
  }

  void navigateToSecondToThird(BuildContext context) {
    if (space == null || entrance == null || exit == null) {
      CustomSnackbar().showMessage(
        context,
        Icons.close,
        Colors.red,
        "Please select all fields",
      );

      print(space);
      print(entrance);
      print(exit);
      return;
    }

    context.push("/LastPage");
  }

  void reset() {
    space = null;
    entrance = null;
    exit = null;
  }
}
