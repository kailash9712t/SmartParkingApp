import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    navigateToNextPage();
    super.initState();
  }

  void navigateToNextPage() async {
    Future.delayed(Duration(seconds: 3), () {
      if (!mounted) return;
      context.go("/UploadPage");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Image.asset(
                        "Assets/Image/image.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "Smart Parking",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Slot Finder",
                    style: TextStyle(
                      color: Color.fromARGB(255, 56, 162, 249),
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 50),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent, width: 3),
                    ),
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.blue[400],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Finding the perfact spot .. ",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 110,
            bottom: 80,
            right: 110,
            child: Column(
              children: [
                Divider(
                  thickness: 1.4,
                  color: Color.fromARGB(255, 196, 196, 196),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.blue),
                      SizedBox(width: 6),
                      Text(
                        "Created by user",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
