import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';

class SubmitBotton extends StatefulWidget {
  final String text;
  final VoidCallback function;
  const SubmitBotton({
    super.key,
    required this.text,
    required this.function,
  });

  @override
  State<SubmitBotton> createState() => _SubmitBottonState();
}

class _SubmitBottonState extends State<SubmitBotton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.function(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Selector<UploadImageModel, File?>(
        selector: (_, model) => model.file,
        builder: (_, file, __) {
          final scale = 1 - _controller.value;

          return GestureDetector(
            onTap: file != null ? _onTap : null,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: file == null ? Colors.grey : Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
