import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GBSystem_BoardingScreen_Controller extends GetxController {
  SharedPreferences? prefs;
  Future updateFirstTime() async {
    prefs = await SharedPreferences.getInstance();
    await prefs!
        .setBool(GbsSystemServerStrings.kIsFirstTime, false)
        .then((value) {
      // Get.off(ChoseCardScreen());
      Get.to(RechargeCodeScanner());
    });
  }
}
