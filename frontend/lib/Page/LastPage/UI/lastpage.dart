// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';
import 'package:smartpart/Page/ThirdPage/State/third_page.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Widgets/submit_botton.dart';
import 'dart:typed_data';

class Lastpage extends StatefulWidget {
  const Lastpage({super.key});

  @override
  State<Lastpage> createState() => _LastpageState();
}

class _LastpageState extends State<Lastpage> {
  int slot = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 14, right: 25, left: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Result",
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Selector<ThirdPageModel, Uint8List?>(
                      selector: (_, model) => model.image,
                      builder: (_, value, __) {
                        if (value == null)
                          return const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          );
                        return Image.memory(value, fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Selector<ThirdPageModel, String?>(
                  selector: (_, model) => model.bestSpot,
                  builder: (_, value, __) {
                    return Text(
                      value != null ? "🎯 Best parking slot is $value: - Ready for You!" : "calculating",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                SubmitBotton(
                  text: "Reset",
                  function: () {
                    context.read<UploadImageModel>().resetState();
                    context.read<SecondPageModel>().reset();
                    context.read<ThirdPageModel>().reset();
                    context.go("/UploadPage");
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
