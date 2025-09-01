import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';
import 'package:smartpart/Page/SelectCoords/State/select_coords.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Widgets/snackbar.dart';
import 'package:http/http.dart' as http;

class ThirdPageModel extends ChangeNotifier {
  String? space;
  String? entrance;
  String? exit;
  Uint8List? image;
  String? bestSpot;

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
      return;
    }

    apiRequestWithResult(context);

    print(space);
    print(entrance);
    print(exit);

    context.push("/LastPage");
  }

  Future<Map<String, dynamic>?> apiRequestWithResult(
    BuildContext context,
  ) async {
    try {
      print("request send");
      String url = "http://10.0.2.2:8000/upload_image";
      Uri uri = Uri.parse(url);
      UploadImageModel instance = context.read<UploadImageModel>();

      print("filename : ${getFilename(instance.file!.path)}");

      var request = http.MultipartRequest("POST", uri);

      request.fields["prefer_entrance"] = entrance == "Yes" ? "true" : "false";
      request.fields["prefer_exit"] = exit == "Yes" ? "true" : "false";
      request.fields["experience"] =
          context.read<SecondPageModel>().age.toString();

      var entranceCoords = context.read<SelectCoordsModel>().entranceCoords;
      var exitCoords = context.read<SelectCoordsModel>().exitCoords;
      var devicePixel = context.read<SelectCoordsModel>().imageCoords;
      print("here is pixel $devicePixel");
      request.fields["entrance_coords"] = jsonEncode(entranceCoords);
      request.fields["exit_coords"] = jsonEncode(exitCoords);
      request.fields["device_pixel"] = jsonEncode(devicePixel);
      final bytes = await instance.file!.readAsBytes();

      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          bytes,
          filename: getFilename(instance.file!.path),
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        Uint8List imageBytes = await response.stream.toBytes();
        bestSpot = response.headers['best_spot'];

        print("best parking spot is here : $bestSpot");

        image = imageBytes;
        notifyListeners();

        return {
          'success': true,
          'best_spot': bestSpot,
          'image_bytes': imageBytes,
          'message': 'Upload successful',
        };
      } else {
        final errorResponse = await response.stream.bytesToString();
        print("status code ${response.statusCode}");
        print("response : $errorResponse");
        return {
          'success': false,
          'status_code': response.statusCode,
          'error': errorResponse,
        };
      }
    } catch (error) {
      print("Error : ${error.toString()}");
      return {'success': false, 'error': error.toString()};
    }
  }

  String? getFilename(String path) {
    try {
      List sector = path.split('/');
      return sector[sector.length - 1];
    } catch (error) {
      print("Error : ${error.toString()}");
    }
    return null;
  }

  void reset() {
    space = null;
    entrance = null;
    exit = null;
  }
}
