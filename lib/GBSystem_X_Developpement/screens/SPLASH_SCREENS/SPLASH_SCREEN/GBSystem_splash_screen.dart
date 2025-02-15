import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/SPLASH_SCREENS/BOARDING_SCREEN/GBSystem_boarding_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/SPLASH_SCREENS/SPLASH_SCREEN/GBSystem_splash_screen_controller.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';

class GBSystemSplashScreen extends StatelessWidget {
  const GBSystemSplashScreen({super.key, this.toMainChat = false});
  final bool toMainChat;
  @override
  Widget build(BuildContext context) {
    final m = Get.put<GBSystemSplashController>(
        GBSystemSplashController(context: context));
    return FutureBuilder(
      future: m.loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashWidget();
        } else {
          if (m.isFirstTime?.value == true || m.isFirstTime?.value == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.off(GBSystem_BoardingScreen());
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.off(RechargeCodeScanner());
              // Get.off(ChoseCardScreen());
            });
          }

          return const SplashWidget();
        }
      },
    );
  }
}

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: GbsSystemStrings.str_primary_color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    GbsSystemServerStrings.str_logo_image_path,
                    color: Colors.white,
                    width: GBSystem_ScreenHelper.screenWidthPercentage(
                        context, 0.2),
                    height: GBSystem_ScreenHelper.screenWidthPercentage(
                        context, 0.25),
                  ),
                  Transform.translate(
                      offset: const Offset(5, -17),
                      child: GBSystem_TextHelper().normalText(
                        text: GbsSystemStrings.str_app_name,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                  LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 20,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
