import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';
import 'package:smartpart/Widgets/custom_list.dart';
import 'package:smartpart/Widgets/slider.dart';
import 'package:smartpart/Widgets/submit_botton.dart';

class SecondPage extends StatefulWidget {
  final VoidCallback function;
  const SecondPage({super.key, required this.function});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void didChangeDependencies() {
  context.read<SecondPageModel>().reset();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomList(
          list: ["Male", "Female", "Other"],
          hint: "Gender",
          mainHint: "Select Gender",
          assignValue: context.read<SecondPageModel>().storeGender,
        ),
        const SizedBox(height: 20),
        CustomList(
          list: ["Beginner", "Intermediate", "Advanced"],
          hint: "Experience",
          mainHint: "Select Experience",
          assignValue: context.read<SecondPageModel>().storeExperience,
        ),

        const SizedBox(height: 20),
        AgeSlider(),
        const SizedBox(height: 30),
        SubmitBotton(text: "Continue", function: widget.function),
      ],
    );
  }
}
