// import 'dart:async';
// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';
// import 'package:get/get.dart';
// import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
// import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';
// import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/true_false_ball_widget.dart';
// import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
// import 'package:screenshot/screenshot.dart';

// class HomePage extends StatefulWidget {
//   const HomePage(
//       {super.key, this.isCommingFromOut = false, required this.typeCard});
//   final bool isCommingFromOut;
//   final int
//       typeCard; // 1 - 1000 , 2000 one line 15 char ; 2 - 100 , 200 two lines 14 char ;  3 - 100 , 200 one line 14 char
//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final StreamController<String> controller = StreamController<String>();

//   bool torchOn = false;
//   bool loading = false;
//   int cameraSelection = 0;
//   String? result;
//   Uint8List? _imageData;
//   final ScreenshotController screenshotController = ScreenshotController();
//   bool codeScanned = false;

//   Future<void> captureScreen(String textContent) async {
//     try {
//       final image = await screenshotController.capture();
//       setState(() {
//         _imageData = image;
//       });
//       if (_imageData != null) {
//         // await StockageService.saveImageAndTextWithUniqueCodeLog(
//         //     _imageData!, textContent,);
//       }
//     } catch (e) {
//       debugPrint("Capture error: $e");
//     }
//   }

//   bool initialiseTestString(String value) {
//     if (widget.typeCard == 1) {
//       return (value.replaceAll(" ", "").replaceAll("-", "").length == 15) &&
//           value.contains(" ") &&
//           RegExp(r'\d\s+\d').hasMatch(value);
//     } else if (widget.typeCard == 2) {
//       return (value.replaceAll(" ", "").replaceAll("-", "").length == 14) &&
//           value.contains(" ") &&
//           RegExp(r'\d\s+\d').hasMatch(value);
//       // && value.contains("\n")
//     } else {
//       return (value.replaceAll(" ", "").replaceAll("-", "").length == 14);
//       //  &&
//       //     !value.contains(" ") &&
//       //     !RegExp(r'\d\s+\d').hasMatch(value);
//     }
//   }

//   void setText(String value) async {
//     // Filter numeric codes only using a regex
//     final numericCodePattern = RegExp(r'\d{15}');
//     final matches = numericCodePattern.allMatches(value);

//     // Check if any match is found
//     if (matches.isNotEmpty) {
//       String detectedCode = matches.first.group(0)!; // Get the first match
//       print("resusuult $value");
//       try {
//         int.parse(value.replaceAll(" ", "").replaceAll("-", ""));
//         if (initialiseTestString(value)) {
//           await captureScreen(value.replaceAll(' ', "").replaceAll("-", ""));
//           setState(() {
//             codeScanned = true;
//             result = value.replaceAll(' ', "").replaceAll("-", "");
//           });
//           controller.add(result!);
//         } else {
//           setState(() {
//             codeScanned = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           codeScanned = false;
//         });
//       }
//     }
//   }

//   void clearResult() {
//     result = "";
//     controller.add("");
//   }

//   void toggleTorch() {
//     setState(() {
//       loading = true;
//       torchOn = !torchOn;
//     });
//     Future.delayed(const Duration(milliseconds: 150), () {
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   void toggleCamera() {
//     setState(() {
//       loading = true;
//       cameraSelection = cameraSelection == 0 ? 1 : 0;
//     });
//     Future.delayed(const Duration(milliseconds: 150), () {
//       setState(() {
//         loading = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: GbsSystemStrings.str_primary_color.withOpacity(0.8),
//       extendBodyBehindAppBar: false,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 4.0,
//         shadowColor: GbsSystemStrings.str_primary_color,
//         toolbarHeight: 80,
//         backgroundColor: GbsSystemStrings.str_primary_color,
//         title: const Text(
//           GbsSystemStrings.str_scan_page,
//           style: TextStyle(color: Colors.white),
//         ),
//         leading: widget.isCommingFromOut
//             ? InkWell(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: const Icon(
//                   CupertinoIcons.arrow_left,
//                   color: Colors.white,
//                 ),
//               )
//             : Container(),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             loading
//                 ? Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       height: MediaQuery.of(context).size.height / 3,
//                       width: MediaQuery.of(context).size.width,
//                       child: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                   )
//                 : CameraScreenShootWidget(
//                     typeCard: widget.typeCard,
//                     cameraSelection: cameraSelection,
//                     torchOn: torchOn,
//                     onScannedText: setText,
//                     screenshotController: screenshotController,
//                   ),
//             StreamBuilder<String>(
//               stream: controller.stream,
//               builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//                 return Result(
//                   scanned: codeScanned,
//                   text: snapshot.data ?? "",
//                 );
//               },
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Visibility(
//                   visible: false,
//                   child: ElevatedButton.icon(
//                     onPressed: clearResult,
//                     icon: const Icon(
//                       Icons.done,
//                       color: Colors.white,
//                     ),
//                     label: const Text(
//                       "Sauvegarder",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: GbsSystemStrings.str_primary_color,
//                       shape: const StadiumBorder(),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: clearResult,
//                   icon: const Icon(
//                     CupertinoIcons.clear,
//                     color: Colors.white,
//                   ),
//                   label: const Text(
//                     "Clear",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     shape: const StadiumBorder(),
//                   ),
//                 ),
//               ],
//             ),
//             Visibility(
//               visible: false,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(color: Colors.white),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         clearResult();
//                       },
//                       child: CircleAvatar(
//                         radius: 25,
//                         backgroundColor: Colors.grey.shade400,
//                         child: Icon(CupertinoIcons.return_icon),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         clearResult();
//                       },
//                       child: CircleAvatar(
//                         radius: 25,
//                         backgroundColor: Colors.grey.shade400,
//                         child: Icon(Icons.done),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Result extends StatelessWidget {
//   const Result({
//     Key? key,
//     required this.text,
//     required this.scanned,
//   }) : super(key: key);

//   final String text;
//   final bool scanned;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         GBSystem_TextHelper().largeText(
//             text: text.isNotEmpty ? text : "vide",
//             fontWeight: FontWeight.bold,
//             textColor: Colors.white),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 30),
//           child: TrueFalseBall(isValid: scanned),
//         ),
//       ],
//     );
//   }
// }

// class CameraScreenShootWidget extends StatelessWidget {
//   const CameraScreenShootWidget({
//     Key? key,
//     required this.torchOn,
//     required this.cameraSelection,
//     required this.onScannedText,
//     required this.screenshotController,
//     required this.typeCard,
//   }) : super(key: key);

//   final bool torchOn;
//   final int cameraSelection;
//   final int typeCard;
//   final Function(String) onScannedText;
//   final ScreenshotController screenshotController;

//   @override
//   Widget build(BuildContext context) {
//     return Screenshot(
//       controller: screenshotController,
//       child: ScalableOCR(
//         torchOn: torchOn,
//         cameraSelection: cameraSelection,
//         paintboxCustom: Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 4.0
//           ..color = const Color.fromARGB(153, 102, 160, 241),
//         boxLeftOff: typeCard == 2 ? 4 : 15,
//         boxBottomOff: typeCard == 2 ? 6 : 2.5,
//         boxRightOff: typeCard == 2 ? 4 : 15,
//         boxTopOff: typeCard == 2 ? 6 : 2.5,
//         boxHeight: MediaQuery.of(context).size.height / 3.5,
//         getRawData: (value) {
//           inspect(value);
//         },
//         getScannedText: onScannedText,
//       ),
//     );
//   }
// }
