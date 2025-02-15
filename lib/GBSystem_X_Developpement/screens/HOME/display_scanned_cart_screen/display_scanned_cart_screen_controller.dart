import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/controller/scanned_code_controller.dart';

class DisplayScannedCartScreenController extends GetxController {
  final scannedCodeController =
      Get.put<GBSystemScannedCodeController>(GBSystemScannedCodeController());
}
