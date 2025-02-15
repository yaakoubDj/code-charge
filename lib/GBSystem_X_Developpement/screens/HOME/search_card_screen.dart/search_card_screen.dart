import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/SCAN_IP_PORT/scan_ip_port_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/search_card_screen.dart/search_card_screen_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/file_transfert_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/share_file_service.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class SearchCardScreen extends StatefulWidget {
  const SearchCardScreen({super.key});

  @override
  State<SearchCardScreen> createState() => _SearchCardScreenState();
}

class _SearchCardScreenState extends State<SearchCardScreen> {
  bool isLoading = false;
  updateLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SearchCardScreenController m =
        Get.put(SearchCardScreenController(context: context));

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.to(RechargeCodeScanner());
      },
      child: Stack(
        children: [
          Scaffold(
              extendBodyBehindAppBar: false,
              appBar: AppBar(
                elevation: 4.0,
                shadowColor: GbsSystemStrings.str_primary_color,
                toolbarHeight: 70,
                backgroundColor: GbsSystemStrings.str_primary_color,
                centerTitle: true,
                title: Text(
                  "Search Card",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  Visibility(
                    visible: false,
                    child: IconButton(
                        onPressed: () async {
                          String? ip, port;
                          updateLoading(true);
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
                                    showSuccesDialog(
                                        context,
                                        GbsSystemStrings
                                            .str_operation_effectuer);
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
                          updateLoading(false);
                        },
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.copy_all,
                              color: Colors.white,
                            ),
                            Positioned(
                              top: -15,
                              right: -5,
                              child: GBSystem_TextHelper().smallText(
                                  text: "Copy",
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.white),
                            ),
                            Positioned(
                              bottom: -15,
                              left: 5,
                              child: GBSystem_TextHelper().smallText(
                                  text: "All",
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.white),
                            )
                          ],
                        )),
                  )
                ],
                leading: InkWell(
                    onTap: () {
                      Get.to(RechargeCodeScanner());
                    },
                    child: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    )),
              ),
              body: Obx(
                () => Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: m.isSelectedImage.value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                GBSystem_ScreenHelper.screenWidthPercentage(
                                    context, 0.02),
                            vertical:
                                GBSystem_ScreenHelper.screenHeightPercentage(
                                    context, 0.02)),
                        child: Column(
                          children: [
                            SearchBar(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              hintText: GbsSystemStrings.str_rechercher,
                              controller: m.controllerSearch,
                              leading: const Icon(CupertinoIcons.search),
                              trailing: [
                                GestureDetector(
                                    onTap: () {
                                      m.controllerSearch.text = "";
                                      m.text?.value = "";
                                      m.photos.value = [];
                                    },
                                    child: const Icon(Icons.close))
                              ],
                              onChanged: (String query) {
                                m.filterDataCards(query);
                              },
                            ),
                            Expanded(
                                child: Obx(
                              () => m.photos.isEmpty
                                  ? const Center(child: Text("No images found"))
                                  : GridView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // Number of columns
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                      ),
                                      itemCount: m.photos.length,
                                      itemBuilder: (context, index) {
                                        final file = m.photos[index];
                                        return InkWell(
                                          onTap: () {
                                            m.isSelectedImage.value = true;
                                            m.selectedImage.value =
                                                m.photos[index];
                                            m.imageIndex.value = index;
                                          },
                                          child: Stack(
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            children: [
                                              Image.file(
                                                File(file.path),
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: GBSystem_TextHelper()
                                                    .smallText(
                                                        text: file.path
                                                            .split('_')
                                                            .last
                                                            .split('.')
                                                            .first,
                                                        maxLines: 3,
                                                        textAlign:
                                                            TextAlign.center,
                                                        textColor:
                                                            Colors.white),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    m.isSelectedImage.value
                        ? Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Center(
                                child: Container(
                                  child: BackdropFilter(
                                    filter: ui.ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY:
                                            5.0), // you can adjust blur radius here
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          children: [
                                            Obx(
                                              () => Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Image.file(
                                                  File(m.selectedImage.value!
                                                      .path),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: GBSystem_TextHelper()
                                                  .smallText(
                                                      text: m.selectedImage
                                                          .value!.path
                                                          .split('_')
                                                          .last
                                                          .split('.')
                                                          .first,
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.center,
                                                      textColor: Colors.white),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (m.imageIndex.value > 0) {
                                                  m.imageIndex.value--;
                                                } else {
                                                  m.imageIndex.value =
                                                      m.photos.length - 1;
                                                }
                                                m.selectedImage.value = m
                                                    .photos[m.imageIndex.value];
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .circle, // Makes the shadow circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.3), // Shadow color
                                                      spreadRadius:
                                                          2, // How far the shadow spreads
                                                      blurRadius:
                                                          8, // How blurred the shadow is
                                                      offset: Offset(3,
                                                          3), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  CupertinoIcons
                                                      .arrow_left_circle_fill,
                                                  size: 45,
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                // m.selectedImage.value =
                                                // m.photos[m.imageIndex.value];
                                                if (m.selectedImage.value !=
                                                    null) {
                                                  await ShareFileService
                                                      .shareFile(
                                                          m.selectedImage.value!
                                                              .path,
                                                          context);
                                                }

                                                print(m
                                                    .selectedImage.value?.path);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .circle, // Makes the shadow circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.3), // Shadow color
                                                      spreadRadius:
                                                          2, // How far the shadow spreads
                                                      blurRadius:
                                                          8, // How blurred the shadow is
                                                      offset: Offset(3,
                                                          3), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  CupertinoIcons.share,
                                                  size: 45,
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (m.imageIndex.value <
                                                    m.photos.length - 1) {
                                                  m.imageIndex.value++;
                                                } else {
                                                  m.imageIndex.value = 0;
                                                }
                                                m.selectedImage.value = m
                                                    .photos[m.imageIndex.value];
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .circle, // Makes the shadow circular
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.3), // Shadow color
                                                      spreadRadius:
                                                          2, // How far the shadow spreads
                                                      blurRadius:
                                                          8, // How blurred the shadow is
                                                      offset: Offset(3,
                                                          3), // Shadow position
                                                    ),
                                                  ],
                                                ),
                                                child: Icon(
                                                  CupertinoIcons
                                                      .arrow_right_circle_fill,
                                                  size: 45,
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: GBSystem_ScreenHelper
                                      .screenHeightPercentage(context, 0.06),
                                  right: 10,
                                  child: InkWell(
                                    onTap: () {
                                      m.isSelectedImage.value = false;
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors
                                                .black38, // You can change opacity to suit your needs
                                            spreadRadius: 1,
                                            blurRadius: 16,
                                            offset: Offset(
                                                0, 3), // Position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape
                                              .circle, // Makes the shadow circular
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.3), // Shadow color
                                              spreadRadius:
                                                  2, // How far the shadow spreads
                                              blurRadius:
                                                  8, // How blurred the shadow is
                                              offset: Offset(
                                                  3, 3), // Shadow position
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          CupertinoIcons.xmark_circle_fill,
                                          size: 45,
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                    ),
                                  )), // make color context
                            ],
                          )
                        : Container()
                  ],
                ),
              )),
          isLoading ? Waiting() : Container()
        ],
      ),
    );
  }
}
