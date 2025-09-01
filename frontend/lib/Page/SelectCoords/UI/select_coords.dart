import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SelectCoords/State/select_coords.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Widgets/image_indicator.dart';
import 'package:smartpart/Widgets/snackbar.dart';
import 'package:smartpart/Widgets/submit_botton.dart';

class SelectCoords extends StatefulWidget {
  const SelectCoords({super.key});

  @override
  State<SelectCoords> createState() => SelectCoordsState();
}

class SelectCoordsState extends State<SelectCoords> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialTask(context);
    });
    super.initState();
  }

  void initialTask(BuildContext context) {
    CustomSnackbar().showMessage(
      context,
      Icons.question_mark_outlined,
      Colors.green,
      "Select point on image",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DraggableIndicatorImage(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Selector<SelectCoordsModel, bool>(
                builder: (_, value, __) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<SelectCoordsModel>().newMode(true);
                    },
                    style:
                        value
                            ? ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                            : ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: Colors.blue),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                    child: Text(
                      "Entrance",
                      style: TextStyle(
                        color: value ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
                selector: (_, model) => model.selectMode,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Selector<SelectCoordsModel, bool>(
                builder: (_, value, __) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<SelectCoordsModel>().newMode(false);
                    },
                    style:
                        value
                            ? ElevatedButton.styleFrom(
                              side: BorderSide(width: 2, color: Colors.blue),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                            : ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                    child: Text(
                      "Exit",
                      style: TextStyle(
                        color: value ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                },
                selector: (_, model) => model.selectMode,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Selector<SelectCoordsModel, List>(
              builder: (_, value, __) {
                return Text(
                  "Entrance coordinates : ( ${value[0]} , ${value[1]} )",
                );
              },
              selector: (_, model) => model.entranceCoords,
            ),
            Selector<SelectCoordsModel, List>(
              builder: (_, value, __) {
                return Text("Exit coordinates : ( ${value[0]} , ${value[1]} )");
              },
              selector: (_, model) => model.exitCoords,
            ),
          ],
        ),
        SizedBox(height: 10),
        SubmitBotton(
          text: "Next",
          function: () {
            context.read<UploadImageModel>().nextPageNavigate();
          },
        ),
      ],
    );
  }
}
