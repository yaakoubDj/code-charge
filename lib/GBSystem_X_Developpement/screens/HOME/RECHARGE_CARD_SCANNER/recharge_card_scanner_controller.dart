import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/controller/scanned_code_controller.dart';
import 'package:vibration/vibration.dart';

class RechargeCardScannerController extends GetxController {
  final scannedCodeController =
      Get.put<GBSystemScannedCodeController>(GBSystemScannedCodeController());

  bool testCard({required int numberTopic, required String text}) {
    // carte 1000 , 2000 ,500
    print("texttt :$text");

    if (numberTopic == 0 || numberTopic == 1 || numberTopic == 2) {
      final RegExp numericPattern = RegExp(r'(\d\s?){15}');
      // final RegExp numericPattern = RegExp(r'^\s*(\d\s*){15}\s*$');

      print("texttt test 0 1 2 :${numericPattern.hasMatch(text)}");
      print("texttt test 0 1 2 :${text.length > 15}");

      return numericPattern.hasMatch(text) && text.length > 17;
      // carte 200 une line
    } else if (numberTopic == 3) {
      final RegExp numericPattern = RegExp(r'^\d{14}$');
      return numericPattern.hasMatch(text) && text.length == 14;
    }
    // carte 200 2 line
    else {
      {
        final RegExp numericPattern = RegExp(r'(\d[\s\n]?){14}');
        return numericPattern.hasMatch(text) && text.length > 14;
      }
    }
  }

  RegExp getNumericPattern({required int numberTopic}) {
    // carte 1000 , 2000 ,500
    if (numberTopic == 0 || numberTopic == 1 || numberTopic == 2) {
      // return RegExp(r'^(\d[\s\n]?){14}$');

      return RegExp(r'(\d\s?){15}');
      // carte 200 une line
    } else if (numberTopic == 3) {
      return RegExp(r'^\d{14}$');
    }
    // carte 200 2 line

    else {
      {
        return RegExp(r'(\d[\s\n]?){14}');
      }
    }
  }

  Future<void> vibrateWhenScan() async {
    print("Vibration attempt started");

    if (await Vibration.hasVibrator() ?? false) {
      print("Device supports vibration");
      Vibration.vibrate(duration: 200);
    } else {
      print("Device does not support vibration");
    }

    // print("Triggering HapticFeedback");
    // HapticFeedback.mediumImpact();
  }
}
