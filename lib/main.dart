import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/responsive/mobile_screen_layout.dart';
import 'package:fluttergram/responsive/responsive_layout_screen.dart';
import 'package:fluttergram/responsive/web_screen_layout.dart';
import 'package:fluttergram/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD-qqtsLiPLM_yM7yQJfNm8vNlzAJg1Hjs",
        appId: "1:338514529867:web:bb11c7a1903880ab3307ce",
        messagingSenderId: "338514529867",
        projectId: "fluttergram-349e6",
        storageBucket: "fluttergram-349e6.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),
    );
  }
}
