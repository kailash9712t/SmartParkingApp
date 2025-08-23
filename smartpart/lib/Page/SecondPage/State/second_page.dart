import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Widgets/snackbar.dart';

class SecondPageModel extends ChangeNotifier {
  double age = 18;
  String? gender;
  String? experience;

  void storeAge(double givenAge) {
    age = givenAge;
    notifyListeners();
  }

  void storeGender(String givenGender) {
    gender = givenGender;
  }

  void storeExperience(String givenExperience) {
    experience = givenExperience;
  }

  void navigateToSecondToThird(BuildContext context) {
    if (gender == null || experience == null) {
      CustomSnackbar().showMessage(
        context,
        Icons.close,
        Colors.red,
        "Please Select Fields",
      );
      return;
    }

    context.read<UploadImageModel>().nextPageNavigate();
  }

  void reset() {
    gender = null;
    experience = null;
    age = 18;
  }
}
