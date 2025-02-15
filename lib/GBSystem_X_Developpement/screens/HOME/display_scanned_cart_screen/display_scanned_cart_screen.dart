import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_toast.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/SCAN_IP_PORT/scan_ip_port_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/display_scanned_cart_screen/display_scanned_cart_screen_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/file_transfert_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/share_file_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/APP_BAR/app_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/GENERAL_WIDGETS/custom_text_field.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayScannedCartScreen extends StatefulWidget {
  const DisplayScannedCartScreen({super.key});

  @override
  State<DisplayScannedCartScreen> createState() =>
      _DisplayScannedCartScreenState();
}

class _DisplayScannedCartScreenState extends State<DisplayScannedCartScreen>
    with SingleTickerProviderStateMixin {
  final m = Get.put<DisplayScannedCartScreenController>(
      DisplayScannedCartScreenController());

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  void updateCode(int index, {required int type}) {
    late TextEditingController controllerCode;
    if (type == 0) {
      controllerCode = TextEditingController(
          text:
              m.scannedCodeController.getAllCodes_mobilis2000![index].codeCart);
    } else if (type == 1) {
      controllerCode = TextEditingController(
          text:
              m.scannedCodeController.getAllCodes_mobilis1000![index].codeCart);
    } else if (type == 2) {
      controllerCode = TextEditingController(
          text:
              m.scannedCodeController.getAllCodes_mobilis500![index].codeCart);
    } else if (type == 3) {
      controllerCode = TextEditingController(
          text: m.scannedCodeController.getAllCodes_mobilis200_one_line![index]
              .codeCart);
    } else {
      controllerCode = TextEditingController(
          text: m.scannedCodeController.getAllCodes_mobilis200_two_line![index]
              .codeCart);
    }
    Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: GBSystem_TextHelper().normalText(
              text: "update code",
              textColor: Colors.black,
              fontWeight: FontWeight.bold),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: controllerCode,
                    text: "New Code"),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: GBSystem_TextHelper().smallText(
                    text: GbsSystemStrings.str_fermer.tr,
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold)),
            TextButton(
                onPressed: () async {
                  try {
                    List<String> carteTypeString = [
                      "MOBILIS_2000_DA",
                      "MOBILIS_1000_DA",
                      "MOBILIS_500_DA",
                      "MOBILIS_200_DA_1_LINE",
                      "MOBILIS_200_DA_2_LINE",
                    ];
                    late String oldCode;
                    if (type == 0) {
                      oldCode = m.scannedCodeController
                          .getAllCodes_mobilis2000![index].codeCart;
                    } else if (type == 1) {
                      oldCode = m.scannedCodeController
                          .getAllCodes_mobilis1000![index].codeCart;
                    } else if (type == 2) {
                      oldCode = m.scannedCodeController
                          .getAllCodes_mobilis500![index].codeCart;
                    } else if (type == 3) {
                      oldCode = m.scannedCodeController
                          .getAllCodes_mobilis200_one_line![index].codeCart;
                    } else {
                      oldCode = m.scannedCodeController
                          .getAllCodes_mobilis200_two_line![index].codeCart;
                    }

                    int scienceScanNumber = await StockageService
                        .getLastScienceScanNumberAutomatically();
                    await StockageService.modifyTextFileFolderAndImages(
                            scienceScanNumber: scienceScanNumber,
                            cardType: carteTypeString[type],
                            cardCode: oldCode,
                            newCode: controllerCode.text)
                        .then(
                      (value) {
                        if (value) {
                          // showSuccesDialog(
                          //     context, GbsSystemStrings.str_updated_with_success);
                        }
                      },
                    );

                    if (type == 0) {
                      setState(() {
                        m.scannedCodeController.getAllCodes_mobilis2000![index]
                            .codeCart = controllerCode.text;
                      });
                    } else if (type == 1) {
                      setState(() {
                        m.scannedCodeController.getAllCodes_mobilis1000![index]
                            .codeCart = controllerCode.text;
                      });
                    } else if (type == 2) {
                      setState(() {
                        m.scannedCodeController.getAllCodes_mobilis500![index]
                            .codeCart = controllerCode.text;
                      });
                    } else if (type == 3) {
                      setState(() {
                        m
                            .scannedCodeController
                            .getAllCodes_mobilis200_one_line![index]
                            .codeCart = controllerCode.text;
                      });
                    } else {
                      setState(() {
                        m
                            .scannedCodeController
                            .getAllCodes_mobilis200_two_line![index]
                            .codeCart = controllerCode.text;
                      });
                    }

                    m.scannedCodeController
                        .updateCodeAtListAll(oldCode, controllerCode.text);

                    Get.back();
                    showSuccesDialog(
                        context, GbsSystemStrings.str_updated_with_success);
                  } catch (e) {
                    print(e);
                  }
                },
                child: GBSystem_TextHelper().smallText(
                    text: GbsSystemStrings.str_ok.tr,
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold))
          ],
        ),
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.5));
  }

  void deleteCode(int index, {required int type}) {
    showWarningSnackBar(
      context,
      "Vous étez sur vous voulez supprimer cette Code ?",
      () async {
        List<String> carteTypeString = [
          "MOBILIS_2000_DA",
          "MOBILIS_1000_DA",
          "MOBILIS_500_DA",
          "MOBILIS_200_DA_1_LINE",
          "MOBILIS_200_DA_2_LINE",
        ];
        late String oldCode;
        if (type == 0) {
          oldCode =
              m.scannedCodeController.getAllCodes_mobilis2000![index].codeCart;
        } else if (type == 1) {
          oldCode =
              m.scannedCodeController.getAllCodes_mobilis1000![index].codeCart;
        } else if (type == 2) {
          oldCode =
              m.scannedCodeController.getAllCodes_mobilis500![index].codeCart;
        } else if (type == 3) {
          oldCode = m.scannedCodeController
              .getAllCodes_mobilis200_one_line![index].codeCart;
        } else {
          oldCode = m.scannedCodeController
              .getAllCodes_mobilis200_two_line![index].codeCart;
        }

        int scienceScanNumber =
            await StockageService.getLastScienceScanNumberAutomatically();
        await StockageService.deleteFolder(
          scienceScanNumber: scienceScanNumber,
          cardType: carteTypeString[type],
          cardCode: oldCode,
        ).then(
          (value) {
            if (value) {
              showSuccesDialog(
                  context, GbsSystemStrings.str_deleted_with_success);
            }
          },
        );

        if (type == 0) {
          setState(() {
            m.scannedCodeController.getAllCodesModel!.remove(
                m.scannedCodeController.getAllCodes_mobilis2000![index]);
            m.scannedCodeController.getAllCodes_mobilis2000!.removeAt(index);
          });
        } else if (type == 1) {
          setState(() {
            m.scannedCodeController.getAllCodesModel!.remove(
                m.scannedCodeController.getAllCodes_mobilis1000![index]);
            m.scannedCodeController.getAllCodes_mobilis1000!.removeAt(index);
          });
        } else if (type == 2) {
          setState(() {
            m.scannedCodeController.getAllCodesModel!
                .remove(m.scannedCodeController.getAllCodes_mobilis500![index]);
            m.scannedCodeController.getAllCodes_mobilis500!.removeAt(index);
          });
        } else if (type == 3) {
          setState(() {
            m.scannedCodeController.getAllCodesModel!.remove(m
                .scannedCodeController.getAllCodes_mobilis200_one_line![index]);
            m.scannedCodeController.getAllCodes_mobilis200_one_line!
                .removeAt(index);
          });
        } else {
          setState(() {
            m.scannedCodeController.getAllCodesModel!.remove(m
                .scannedCodeController.getAllCodes_mobilis200_two_line![index]);
            m.scannedCodeController.getAllCodes_mobilis200_two_line!
                .removeAt(index);
          });
        }
      },
    );
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.to(RechargeCodeScanner());
      },
      child: Stack(
        children: [
          Scaffold(
              extendBodyBehindAppBar: false,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: FloatingActionBubble(
                items: <Bubble>[
                  Bubble(
                    title: GbsSystemStrings.str_enregistrer,
                    iconColor: GbsSystemStrings.str_primary_color,
                    bubbleColor: Colors.white,
                    icon: Icons.save,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        color: GbsSystemStrings.str_primary_color),
                    onPress: () async {
                      _animationController.reverse();
                      setState(() {
                        isLoading = true;
                      });

                      int science_number = await StockageService
                          .getLastScienceScanNumberAutomatically();
                      StockageService.createOrganizedTextFile(
                        saveInDownload: true,
                        scinceNumber: science_number,
                        mobilis1000:
                            m.scannedCodeController.getAllCodes_mobilis1000 ??
                                [],
                        mobilis2000:
                            m.scannedCodeController.getAllCodes_mobilis2000 ??
                                [],
                        mobilis500:
                            m.scannedCodeController.getAllCodes_mobilis500 ??
                                [],
                        mobilis200_one_line: m.scannedCodeController
                                .getAllCodes_mobilis200_one_line ??
                            [],
                        mobilis200_two_line: m.scannedCodeController
                                .getAllCodes_mobilis200_two_line ??
                            [],
                      ).then(
                        (value) async {
                          setState(() {
                            isLoading = false;
                          });
                          print("pathhhhh $value");
                          m.scannedCodeController.clearAllData();
                          Get.to(RechargeCodeScanner());
                        },
                      );
                    },
                  ),
                  Bubble(
                    title: "Partager",
                    iconColor: GbsSystemStrings.str_primary_color,
                    bubbleColor: Colors.white,
                    icon: Icons.share,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        color: GbsSystemStrings.str_primary_color),
                    onPress: () async {
                      _animationController.reverse();
                      int science_number = await StockageService
                          .getLastScienceScanNumberAutomatically();
                      StockageService.createOrganizedTextFile(
                        scinceNumber: science_number,
                        mobilis1000:
                            m.scannedCodeController.getAllCodes_mobilis1000 ??
                                [],
                        mobilis2000:
                            m.scannedCodeController.getAllCodes_mobilis2000 ??
                                [],
                        mobilis500:
                            m.scannedCodeController.getAllCodes_mobilis500 ??
                                [],
                        mobilis200_one_line: m.scannedCodeController
                                .getAllCodes_mobilis200_one_line ??
                            [],
                        mobilis200_two_line: m.scannedCodeController
                                .getAllCodes_mobilis200_two_line ??
                            [],
                      ).then(
                        (value) async {
                          if (value != null) {
                            print("pathhhhh $value");
                            await ShareFileService.shareFile(value, context);
                          }
                        },
                      );
                    },
                  ),
                  Bubble(
                    title: "Copier sur PC",
                    iconColor: GbsSystemStrings.str_primary_color,
                    bubbleColor: Colors.white,
                    icon: Icons.copy_all_rounded,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        color: GbsSystemStrings.str_primary_color),
                    onPress: () async {
                      try {
                        _animationController.reverse();
                        setState(() {
                          isLoading = true;
                        });
                        int science_number = await StockageService
                            .getLastScienceScanNumberAutomatically();

                        await StockageService.createOrganizedTextFile(
                          scinceNumber: science_number,
                          mobilis1000:
                              m.scannedCodeController.getAllCodes_mobilis1000 ??
                                  [],
                          mobilis2000:
                              m.scannedCodeController.getAllCodes_mobilis2000 ??
                                  [],
                          mobilis500:
                              m.scannedCodeController.getAllCodes_mobilis500 ??
                                  [],
                          mobilis200_one_line: m.scannedCodeController
                                  .getAllCodes_mobilis200_one_line ??
                              [],
                          mobilis200_two_line: m.scannedCodeController
                                  .getAllCodes_mobilis200_two_line ??
                              [],
                        ).then(
                          (path) async {
                            String? ip, port;
                            if (path != null) {
                              print("pathhhhh $path");
                              // ADBFileTransferService.uploadFile(context,
                              //     filePath: value, ip: "192.168.1.109", port: 3000);
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              ip = sharedPreferences.getString(
                                GbsSystemServerStrings.kIP,
                              );
                              port = sharedPreferences.getString(
                                GbsSystemServerStrings.kPort,
                              );

                              if (ip != null &&
                                  ip.isNotEmpty &&
                                  port != null &&
                                  port.isNotEmpty) {
                                try {
                                  await ADBFileTransferService.uploadFile(
                                          context,
                                          filePath: path,
                                          ip: ip,
                                          port: int.parse(port))
                                      .then(
                                    (value) {
                                      if (value) {
                                        showSuccesDialog(
                                            context,
                                            GbsSystemStrings
                                                .str_operation_effectuer);
                                      } else {
                                        Get.to(ScanIpPortScreen(
                                          filePath: path,
                                          isAllFiles: false,
                                        ));
                                      }
                                    },
                                  );
                                } catch (e) {
                                  Get.to(ScanIpPortScreen(
                                    filePath: path,
                                    isAllFiles: false,
                                  ));
                                }
                              } else {
                                Get.to(ScanIpPortScreen(
                                  filePath: path,
                                  isAllFiles: false,
                                ));
                              }
                            } else {
                              showToast(
                                  text: GbsSystemStrings.str_error_send_data);
                            }
                          },
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        print("error-----------");
                      }
                    },
                  ),
                  Bubble(
                    title: "Copier tout les fichier sur PC",
                    iconColor: GbsSystemStrings.str_primary_color,
                    bubbleColor: Colors.white,
                    icon: Icons.copy_all,
                    titleStyle: TextStyle(
                        fontSize: 16,
                        color: GbsSystemStrings.str_primary_color),
                    onPress: () async {
                      _animationController.reverse();
                      String? ip, port;
                      setState(() {
                        isLoading = true;
                      });

                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      ip = sharedPreferences.getString(
                        GbsSystemServerStrings.kIP,
                      );
                      port = sharedPreferences.getString(
                        GbsSystemServerStrings.kPort,
                      );

                      if (ip != null &&
                          ip.isNotEmpty &&
                          port != null &&
                          port.isNotEmpty) {
                        try {
                          await ADBFileTransferService.uploadFolder(context,
                                  folderPath:
                                      "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                                  ip: ip,
                                  port: int.parse(port))
                              .then(
                            (value) {
                              if (value) {
                                showSuccesDialog(context,
                                    GbsSystemStrings.str_operation_effectuer);
                              } else {
                                Get.to(ScanIpPortScreen(
                                  filePath:
                                      "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                                  isAllFiles: true,
                                ));
                              }
                            },
                          );
                        } catch (e) {
                          Get.to(ScanIpPortScreen(
                            filePath:
                                "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                            isAllFiles: true,
                          ));
                        }
                      } else {
                        Get.to(ScanIpPortScreen(
                          filePath:
                              "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                          isAllFiles: true,
                        ));
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                ],
                animation: _animation,
                onPress: () => _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward(),
                iconColor: GbsSystemStrings.str_primary_color,
                iconData: Icons.settings,
                backGroundColor: Colors.white,
              ),
              appBar: GBSystemCustomAppBarResult(
                onBackTap: () {
                  // Get.back();
                  Get.to(RechargeCodeScanner());
                },
                title: "Result Scan Card Mobilis",
              ),
              backgroundColor: Colors.grey[200],
              body: Obx(
                () => Column(
                  children: [
                    Visibility(
                      visible: m.scannedCodeController.getSelectedCardResultRx
                              .value ==
                          0,
                      child: ExpansionTile(
                        subtitle: GBSystem_TextHelper().smallText(
                            text:
                                "${m.scannedCodeController.getAllCodes_mobilis2000?.length ?? 0} cartes"),
                        title: Text("MOBILIS 2000 da"),
                        children: List.generate(
                          m.scannedCodeController.getAllCodes_mobilis2000
                                  ?.length ??
                              0,
                          (index) => ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update, size: 24),
                                  onPressed: () =>
                                      updateCode(index, type: 0), // Update code
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () =>
                                      deleteCode(index, type: 0), // Delete code
                                ),
                              ],
                            ),
                            title: Text(m.scannedCodeController
                                .getAllCodes_mobilis2000![index].codeCart),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: m.scannedCodeController.getSelectedCardResultRx
                              .value ==
                          1,
                      child: ExpansionTile(
                        subtitle: GBSystem_TextHelper().smallText(
                            text:
                                "${m.scannedCodeController.getAllCodes_mobilis1000?.length ?? 0} cartes"),
                        title: Text("MOBILIS 1000 da"),
                        children: List.generate(
                          m.scannedCodeController.getAllCodes_mobilis1000
                                  ?.length ??
                              0,
                          (index) => ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update, size: 24),
                                  onPressed: () =>
                                      updateCode(index, type: 1), // Update code
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () =>
                                      deleteCode(index, type: 1), // Delete code
                                ),
                              ],
                            ),
                            title: Text(m.scannedCodeController
                                .getAllCodes_mobilis1000![index].codeCart),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: m.scannedCodeController.getSelectedCardResultRx
                              .value ==
                          2,
                      child: ExpansionTile(
                        subtitle: GBSystem_TextHelper().smallText(
                            text:
                                "${m.scannedCodeController.getAllCodes_mobilis500?.length ?? 0} cartes"),
                        title: Text("MOBILIS 500 da"),
                        children: List.generate(
                          m.scannedCodeController.getAllCodes_mobilis500
                                  ?.length ??
                              0,
                          (index) => ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update, size: 24),
                                  onPressed: () =>
                                      updateCode(index, type: 2), // Update code
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () =>
                                      deleteCode(index, type: 2), // Delete code
                                ),
                              ],
                            ),
                            title: Text(m.scannedCodeController
                                .getAllCodes_mobilis500![index].codeCart),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: m.scannedCodeController.getSelectedCardResultRx
                              .value ==
                          3,
                      child: ExpansionTile(
                        subtitle: GBSystem_TextHelper().smallText(
                            text:
                                "${m.scannedCodeController.getAllCodes_mobilis200_one_line?.length ?? 0} cartes"),
                        title: Text("MOBILIS 200 da (1 line)"),
                        children: List.generate(
                          m.scannedCodeController
                                  .getAllCodes_mobilis200_one_line?.length ??
                              0,
                          (index) => ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update, size: 24),
                                  onPressed: () =>
                                      updateCode(index, type: 3), // Update code
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () =>
                                      deleteCode(index, type: 3), // Delete code
                                ),
                              ],
                            ),
                            title: Text(m
                                .scannedCodeController
                                .getAllCodes_mobilis200_one_line![index]
                                .codeCart),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: m.scannedCodeController.getSelectedCardResultRx
                              .value ==
                          4,
                      child: ExpansionTile(
                        subtitle: GBSystem_TextHelper().smallText(
                            text:
                                "${m.scannedCodeController.getAllCodes_mobilis200_two_line?.length ?? 0} cartes"),
                        title: Text("MOBILIS 200 da (2 line)"),
                        children: List.generate(
                          m.scannedCodeController
                                  .getAllCodes_mobilis200_two_line?.length ??
                              0,
                          (index) => ListTile(
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update, size: 24),
                                  onPressed: () =>
                                      updateCode(index, type: 4), // Update code
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 24),
                                  onPressed: () =>
                                      deleteCode(index, type: 4), // Delete code
                                ),
                              ],
                            ),
                            title: Text(m
                                .scannedCodeController
                                .getAllCodes_mobilis200_two_line![index]
                                .codeCart),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          isLoading ? Waiting() : Container()
        ],
      ),
    );
  }
}
