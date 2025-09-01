import 'package:go_router/go_router.dart';
import 'package:smartpart/Page/LastPage/UI/lastpage.dart';
import 'package:smartpart/Page/Loading/UI/loading.dart';
import 'package:smartpart/Page/UploadImage/UI/upload_image.dart';

final GoRouter route = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => LoadingPage()),
    GoRoute(path: "/UploadPage", builder: (context, state) => UploadImage()),
    GoRoute(path: "/LastPage", builder: (context, state) => Lastpage()),
  ],
);
