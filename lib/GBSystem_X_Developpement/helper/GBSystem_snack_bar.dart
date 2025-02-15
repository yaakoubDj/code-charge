import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';

void showWarningSnackBar(context, String text, void Function()? btnOkOnPress) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    animType: AnimType.rightSlide,
    title: GbsSystemStrings.str_dialog_avertissement.tr,
    desc: text,
    // autoHide: const Duration(seconds: 2),
    btnCancelOnPress: () {},
    btnOkOnPress: btnOkOnPress,
    showCloseIcon: true,
    btnCancelText: GbsSystemStrings.str_annuler.tr,
    btnOkText: GbsSystemStrings.str_ok.tr,
  ).show();
}

void showErrorDialog(context, String text) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  // try {
  //   if (Get.isSnackbarOpen) {
  //     Get.closeAllSnackbars();
  //   }
  // } catch (e) {
  //   if (Get.isSnackbarOpen) {
  //     Get.closeCurrentSnackbar();
  //   }
  // }

  Get.snackbar(
    GbsSystemStrings.str_dialog_erreur.tr,
    text,
    backgroundColor: Colors.white,
    colorText: Colors.black,
    isDismissible: false,
    leftBarIndicatorColor: Colors.red,
    borderWidth: 1,
    borderColor: Colors.grey.shade300,
    borderRadius: 0,
    duration: Duration(minutes: 1),
    animationDuration: Duration(milliseconds: 800),
    snackbarStatus: (status) {
      // print("dialog sattus : ${status}");
      // if (status == SnackbarStatus.OPENING) {
      //   if (Get.isSnackbarOpen) {
      //   Get.closeCurrentSnackbar();
      //   }
      // }
    },
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: Text(
          GbsSystemStrings.str_fermer.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),
    icon: Icon(
      Icons.error_outlined,
      size: 30,
      color: Colors.red,
    ),
  );
  // ElegantNotification.error(
  //     // autoDismiss: false,
  //     displayCloseButton: true,
  //     height: 120,
  //     toastDuration: Duration(minutes: 1),
  //     // notificationPosition: NotificationPosition.bottomRight,
  //     // width: GBSystem_ScreenHelper.screenWidth(context),
  //     iconSize: 35,
  //     title: Text(
  //       GbsSystemStrings.str_dialog_erreur.tr,
  //     ),
  //     description: Flexible(
  //       child: Text(
  //         text,
  //         maxLines: 3,
  //         style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
  //       ),
  //     )).show(context);
}

void showSuccesDialog(context, String text) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  Get.snackbar(
    GbsSystemStrings.str_dialog_succes.tr, text,
    // showProgressIndicator: true,
    backgroundColor: Colors.white,

    colorText: Colors.black,
    isDismissible: false,
    leftBarIndicatorColor: Colors.green,
    animationDuration: Duration(milliseconds: 800),

    mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: Text(
          GbsSystemStrings.str_fermer.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),

    borderWidth: 1,
    borderColor: Colors.grey.shade300,
    borderRadius: 0,
    // duration: Duration(minutes: 1),
    snackbarStatus: (status) => true,
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),

    icon: Icon(
      Icons.check_circle,
      size: 30,
      color: Colors.green,
    ),
  );

  // ElegantNotification.success(
  //     // notificationPosition: NotificationPosition.bottomRight,
  //     width: GBSystem_ScreenHelper.screenWidth(context),
  //     iconSize: 35,
  //     height: 120,
  //     title: Text(
  //       GbsSystemStrings.str_dialog_succes.tr,
  //     ),
  //     description: Flexible(
  //       child: Text(
  //         text,
  //         maxLines: 3,
  //         style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
  //       ),
  //     )).show(context);
}

void showWarningDialog(context, String text) {
  // AwesomeDialog(
  //   context: context,
  //   dialogType: DialogType.info,
  //   animType: AnimType.rightSlide,
  //   title: GbsSystemStrings.str_dialog_info,
  //   desc: text,
  //   btnCancelOnPress: () {},
  //   btnOkOnPress: () {},
  //   showCloseIcon: true,
  //   btnCancelText: GbsSystemStrings.str_annuler,
  //   btnOkText: GbsSystemStrings.str_ok,
  // ).show();
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  Get.snackbar(
    GbsSystemStrings.str_dialog_info.tr, text,
    // showProgressIndicator: true,
    backgroundColor: Colors.white,

    colorText: Colors.black,
    isDismissible: false,
    leftBarIndicatorColor: Colors.yellow,
    borderWidth: 1,
    borderColor: Colors.grey.shade300,
    borderRadius: 0,
    duration: Duration(minutes: 1),
    animationDuration: Duration(milliseconds: 800),

    snackbarStatus: (status) => true,
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
        child: Text(
          GbsSystemStrings.str_fermer.tr,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        )),

    icon: Icon(
      Icons.info,
      size: 30,
      color: Colors.yellow,
    ),
  );

  // ElegantNotification.info(
  //     toastDuration: Duration(minutes: 1),
  //     // notificationPosition: NotificationPosition.bottomRight,
  //     width: GBSystem_ScreenHelper.screenWidth(context),
  //     iconSize: 35,
  //     height: 120,
  //     title: Text(
  //       GbsSystemStrings.str_dialog_info.tr,
  //     ),
  //     description: Flexible(
  //       child: Text(
  //         text,
  //         maxLines: 3,
  //         style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
  //       ),
  //     )).show(context);
}
