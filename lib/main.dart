import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/app_desktop.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/SPLASH_SCREENS/SPLASH_SCREEN/GBSystem_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Mulish'),
        debugShowCheckedModeBanner: false,
        home: const GBSystemSplashScreen(),
        // home: ServerLauncher(),
      ),
    );
  }
}
