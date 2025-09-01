import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartpart/Widgets/snackbar.dart';

class UploadImageModel extends ChangeNotifier {
  File? file;
  String filename = "upload_image.dart";
  double totalPage = 3;
  double current = 1;
  Uint8List? image;

  void pickImage() async {
    try {
      ImagePicker picker = ImagePicker();

      XFile? tempFile = await picker.pickImage(source: ImageSource.gallery);

      if (tempFile == null) return;

      image = await tempFile.readAsBytes();

      file = File(tempFile.path);

      print(tempFile.path);

      notifyListeners();
    } catch (error) {
      print("$filename.pickImage ${error.toString()}");
    }
  }

  void resetState() {
    file = null;
    current = 1;
    notifyListeners();
  }

  void navigateFirstToSecond(BuildContext context) {
    if (file == null) {
      CustomSnackbar().showMessage(
        context,
        Icons.close,
        Colors.red,
        "Please Upload a Image",
      );

      return;
    }

    current++;
    notifyListeners();
  }

  void nextPageNavigate() {
    if (current == 4) return;
    current++;
    notifyListeners();
  }

  void handleBackSpace() {
    if (current == 1) {
      SystemNavigator.pop();
      return;
    }
    current--;
    notifyListeners();
  }
}
