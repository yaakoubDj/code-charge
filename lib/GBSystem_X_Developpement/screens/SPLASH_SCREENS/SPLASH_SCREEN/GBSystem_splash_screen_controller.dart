import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class GBSystemSplashController extends GetxController {
  RxBool? isFirstTime;

  GBSystemSplashController({required this.context});
  BuildContext context;

  loadData() async {
    await SharedPreferences.getInstance().then((value) {
      value.getBool(GbsSystemServerStrings.kIsFirstTime) != null
          ? isFirstTime =
              RxBool(value.getBool(GbsSystemServerStrings.kIsFirstTime)!)
          : null;
      Future.delayed(Duration(seconds: 3));
    });
  }

  viderSharedPerfermences() async {
    await SharedPreferences.getInstance().then((value) {
      value.setBool(GbsSystemServerStrings.kIsFirstTime, true);
    });
  }
}
