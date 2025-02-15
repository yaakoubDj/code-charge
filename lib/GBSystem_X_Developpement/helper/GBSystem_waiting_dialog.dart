import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';

class WaitingDialog {
  static void show({String message = "Please wait..."}) {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WaitingWidgets(),
            SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      barrierDismissible: false, // Prevent dismissing by tapping outside
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back(); // Close the dialog
    }
  }
}
