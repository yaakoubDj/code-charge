import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({super.key, this.heightLottie});
  final double? heightLottie;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(GbsSystemServerStrings.no_data_lottie_path,
              height: heightLottie ??
                  GBSystem_ScreenHelper.screenHeightPercentage(context, 0.3)),
          GBSystem_TextHelper().normalText(
              textColor: Colors.black,
              text: GbsSystemStrings.str_empty_data.tr,
              fontWeight: FontWeight.bold),
        ],
      ),
    );
  }
}
