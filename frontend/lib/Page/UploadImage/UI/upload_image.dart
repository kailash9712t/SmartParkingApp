import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';
import 'package:smartpart/Page/SecondPage/UI/second_page.dart';
import 'package:smartpart/Page/SelectCoords/UI/select_coords.dart';
import 'package:smartpart/Page/ThirdPage/UI/third_page.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Widgets/progressindicator.dart';
import 'package:smartpart/Widgets/submit_botton.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<UploadImageModel>().handleBackSpace();
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Selector<UploadImageModel, double>(
              builder: (_, current, __) {
                return ProgressIndicatorBar(
                  currentStep: current,
                  totalStep: 3,
                  animationDuration: Duration(milliseconds: 500),
                );
              },
              selector: (_, model) => model.current,
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Selector<UploadImageModel, double>(
                  selector: (_, model) => model.current,
                  builder: (_, current, __) {
                    UploadImageModel model = context.read<UploadImageModel>();

                    Widget child;
                    if (current == 1) {
                      child = uploadPage(
                        context,
                        () => model.navigateFirstToSecond(context),
                      );
                    } else if (current == 2) {
                      child = SelectCoords();
                    } else if (current == 3) {
                      child = SecondPage(
                        function:
                            () => context
                                .read<SecondPageModel>()
                                .navigateToSecondToThird(context),
                      );
                    } else if (current == 4) {
                      child = ParkingPreferencePage();
                    } else {
                      child = const SizedBox.shrink();
                    }

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (
                        Widget child,
                        Animation<double> animation,
                      ) {
                        final inFromRight = Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation);

                        final outToLeft = Tween<Offset>(
                          begin: Offset.zero,
                          end: const Offset(-1.0, 0.0),
                        ).animate(animation);

                        final isIncoming = child.key == ValueKey(current);

                        return SlideTransition(
                          position: isIncoming ? inFromRight : outToLeft,
                          child: child,
                        );
                      },
                      child: KeyedSubtree(key: ValueKey(current), child: child),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

Widget uploadPage(BuildContext context, VoidCallback function) {
  return SafeArea(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<UploadImageModel, File?>(
            builder: (_, file, __) {
              return file == null
                  ? beforeImageSelect(context)
                  : afterSelectImage(context, file);
            },
            selector: (_, model) => model.file,
          ),
          const SizedBox(height: 50),
          SubmitBotton(text: "Continue", function: function),
        ],
      ),
    ),
  );
}

Widget beforeImageSelect(BuildContext context) {
  return GestureDetector(
    onTap: () {
      context.read<UploadImageModel>().pickImage();
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 162, 196, 255),
            blurRadius: 3,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 40, bottom: 70),
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 230, 238, 255),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.blue,
                    size: 40,
                    weight: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 79, 95),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "Tap to select an Image from gallery",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 127, 127, 131),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget afterSelectImage(BuildContext context, File file) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 200,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 7,
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(file, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => context.read<UploadImageModel>().pickImage(),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
