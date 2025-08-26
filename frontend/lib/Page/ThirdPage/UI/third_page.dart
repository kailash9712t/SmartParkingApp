import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/ThirdPage/State/third_page.dart';
import 'package:smartpart/Widgets/custom_list.dart';
import 'package:smartpart/Widgets/submit_botton.dart';

class ParkingPreferencePage extends StatefulWidget {
  const ParkingPreferencePage({super.key});

  @override
  State<ParkingPreferencePage> createState() => _ParkingPreferencePageState();
}

class _ParkingPreferencePageState extends State<ParkingPreferencePage> {
  @override
  void didChangeDependencies() {
    context.read<ThirdPageModel>().reset();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomList(
          list: ["Yes", "No"],
          hint: "Drive worry about space?",
          mainHint: "Select Option : -",
          assignValue: context.read<ThirdPageModel>().setSpace,
        ),
        const SizedBox(height: 20),
        CustomList(
          list: ["Yes", "No"],
          hint: "Prefer near entrance",
          mainHint: "Select Option : -",
          assignValue: context.read<ThirdPageModel>().setEntrance,
        ),
        const SizedBox(height: 20),
        CustomList(
          list: ["Yes", "No"],
          hint: "Prefer near exit",
          mainHint: "Select Option : -",
          assignValue: context.read<ThirdPageModel>().setExit,
        ),
        const SizedBox(height: 30),
        SubmitBotton(
          text: "Continue",
          function: () {
            context.read<ThirdPageModel>().navigateToSecondToThird(context);
          },
        ),
      ],
    );
  }
}
