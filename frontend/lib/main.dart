import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smartpart/Page/SecondPage/State/second_page.dart';
import 'package:smartpart/Page/SelectCoords/State/select_coords.dart';
import 'package:smartpart/Page/ThirdPage/State/third_page.dart';
import 'package:smartpart/Page/UploadImage/State/upload_image.dart';
import 'package:smartpart/Page/Utils/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadImageModel()),
        ChangeNotifierProvider(create: (context) => SecondPageModel()),
        ChangeNotifierProvider(create: (context) => ThirdPageModel()),
        ChangeNotifierProvider(create: (context) => SelectCoordsModel())
      ],
      child: MainApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: route,

      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          secondary: Colors.blueAccent,
          tertiary: Colors.black
        ),
        scaffoldBackgroundColor: Colors.white,
        textTheme: Typography.blackMountainView.apply(bodyColor: Colors.black),
      ),

      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),
        cardColor: Color(0xFF1E1E1E),
        shadowColor: Color(0xFF2A2A2A),
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: const Color.fromARGB(255, 121, 170, 255),
          tertiary: Colors.white
        ),
        textTheme: Typography.blackMountainView.apply(bodyColor: Colors.white),
        iconTheme: IconThemeData(
          color: Color(0xFF82B1FF), 
        ),
      ),
    );
  }
}
