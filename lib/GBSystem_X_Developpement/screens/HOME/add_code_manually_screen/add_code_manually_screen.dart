import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_code_formatter.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/models/code_scanned_model.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/add_code_manually_screen/add_code_manually_screen_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:image/image.dart' as img;

class AddCodeManuallyScreen extends StatefulWidget {
  const AddCodeManuallyScreen({super.key, required this.updateUI});

  final Function updateUI;
  @override
  State<AddCodeManuallyScreen> createState() => _AddCodeManuallyScreenState();
}

class _AddCodeManuallyScreenState extends State<AddCodeManuallyScreen> {
  bool isScanReady = false;
  Uint8List? _imageData;
  bool isProcessing = false;
  String detectedCode = '';
  Rx<ScrollController> scrollController =
      Rx<ScrollController>(ScrollController(initialScrollOffset: 0));
  int nombreCardScanner = 0;
  int captureCount = 0; // Counter to track the number of captures
  String scanStatus = GbsSystemStrings.str_scanning;
  TextEditingController controllerCode = TextEditingController();
  File? pickedFile; // To store the selected image

  final m = Get.put<AddCodeManuallyScreenController>(
      AddCodeManuallyScreenController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/scanner-beep.mp3'));
  }

  void setCardtoController(String detectedCode) {
    m.scannedCodeController.setCodeModelIfNotExiste = CodeScannedModel(
        codeCart: detectedCode,
        cartType: m.scannedCodeController.getSelectedCard);
    if (m.scannedCodeController.getSelectedCard == 0) {
      m.scannedCodeController.setCodeModelIfNotExiste_Mobilis2000 =
          CodeScannedModel(
              codeCart: detectedCode,
              cartType: m.scannedCodeController.getSelectedCard);
    } else if (m.scannedCodeController.getSelectedCard == 1) {
      m.scannedCodeController.setCodeModelIfNotExiste_Mobilis1000 =
          CodeScannedModel(
              codeCart: detectedCode,
              cartType: m.scannedCodeController.getSelectedCard);
    } else if (m.scannedCodeController.getSelectedCard == 2) {
      m.scannedCodeController.setCodeModelIfNotExiste_Mobilis500 =
          CodeScannedModel(
              codeCart: detectedCode,
              cartType: m.scannedCodeController.getSelectedCard);
    } else if (m.scannedCodeController.getSelectedCard == 3) {
      m.scannedCodeController.setCodeModelIfNotExiste_Mobilis200_one_line =
          CodeScannedModel(
              codeCart: detectedCode,
              cartType: m.scannedCodeController.getSelectedCard);
    } else if (m.scannedCodeController.getSelectedCard == 4) {
      m.scannedCodeController.setCodeModelIfNotExiste_Mobilis200_two_line =
          CodeScannedModel(
              codeCart: detectedCode,
              cartType: m.scannedCodeController.getSelectedCard);
    }
  }

  Future<Uint8List?> diminierQualiterImage({required Uint8List? image}) async {
    if (image != null) {
      // Convert the Uint8List image into an Image object
      img.Image originalImage = img.decodeImage(Uint8List.fromList(image))!;

      // Resize the image to lower quality (e.g., 50% of original size)
      img.Image resizedImage = img.copyResize(originalImage,
          width: (originalImage.width ~/ 2),
          height: (originalImage.height ~/ 2));
      Uint8List resizedImageBytes = Uint8List.fromList(img.encodeJpg(
          resizedImage,
          quality: 70)); // Optionally, adjust quality here
      return resizedImageBytes;
    } else {
      return null;
    }
  }

  Future<Uint8List?> fileToUint8List(File? file) async {
    if (file == null) {
      return null;
    }
    return await file.readAsBytes();
  }

  Future<void> captureScreen(String textContent, Uint8List? image) async {
    try {
      image = await diminierQualiterImage(image: image);
      setState(() {
        _imageData = image;
      });
      if (_imageData != null) {
        await StockageService.saveImageAndTextWithUniqueCodeLog(
            _imageData!,
            textContent,
            m.scannedCodeController.getSelectedCard,
            m.scannedCodeController.getAllCodesModel?.isEmpty ?? true);
      }
    } catch (e) {
      debugPrint("Capture error: $e");
    }
  }

  int getCurrentTypeCard() {
    if (m.scannedCodeController.getSelectedCard == 0 ||
        m.scannedCodeController.getSelectedCard == 1 ||
        m.scannedCodeController.getSelectedCard == 2) {
      return 0;
    } else if (m.scannedCodeController.getSelectedCard == 3) {
      return 1;
    } else {
      return 2;
    }
  }

  late int theme;
  @override
  void initState() {
    theme = getCurrentTypeCard();
    super.initState();
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
            appBar: AppBar(
              elevation: 4.0,
              shadowColor: GbsSystemStrings.str_primary_color,
              toolbarHeight: 80,
              backgroundColor: GbsSystemStrings.str_primary_color,
              centerTitle: true,
              title: Text(
                "Add Cart Manually",
                style: TextStyle(color: Colors.white),
              ),
              leading: InkWell(
                  onTap: () {
                    // Get.to(RechargeCodeScanner());
                    Get.to(RechargeCodeScanner());
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                  )),
            ),
            body: Center(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      const Text(
                        "Add Code and Cart Photo",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Code input field
                      TextField(
                        controller: controllerCode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CodeInputFormatter(theme),
                        ],
                        maxLength: theme == 0
                            ? 19
                            : theme == 2
                                ? 15
                                : 14,
                        decoration: InputDecoration(
                          labelText: "Cart Code",
                          hintText: theme == 0
                              ? "XXXX XXXX XXXX XXX"
                              : theme == 2
                                  ? "XXXXXXX XXXXXXX"
                                  : "XXXXXXXXXXXXXX",
                          counterText: "", // Hide character count
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Display selected image or placeholder
                      Center(
                        child: pickedFile == null
                            ? const Text(
                                "No image selected",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  pickedFile!,
                                  height: 150,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Button to capture photo
                      ElevatedButton.icon(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);

                          if (image != null) {
                            setState(() {
                              pickedFile = File(image.path);
                            });
                          }
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Capture Photo"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Custom action button
                      OutlinedButton(
                        onPressed: () async {
                          String code = controllerCode.text.replaceAll(' ', '');
                          int requiredLength = theme == 0 ? 15 : 14;

                          if (code.length != requiredLength) {
                            showErrorDialog(
                              context,
                              "The code must be exactly $requiredLength digits.",
                            );
                            return;
                          } else if (pickedFile == null) {
                            showErrorDialog(
                              context,
                              "Please add photo cart",
                            );

                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });

                          if (m.testCard(
                              numberTopic:
                                  m.scannedCodeController.getSelectedCard,
                              text: controllerCode.text)) {
                            _playSound();
                            setState(() {
                              detectedCode = m
                                  .getNumericPattern(
                                      numberTopic: m.scannedCodeController
                                          .getSelectedCard)
                                  .firstMatch(controllerCode.text)!
                                  .group(0)!
                                  .replaceAll(' ', '');
                              scanStatus = GbsSystemStrings.str_scan_succes;
                            });

                            Uint8List? imageData =
                                await fileToUint8List(pickedFile);

                            await captureScreen(
                                m
                                    .getNumericPattern(
                                        numberTopic: m.scannedCodeController
                                            .getSelectedCard)
                                    .firstMatch(controllerCode.text)!
                                    .group(0)!
                                    .replaceAll(' ', ''),
                                imageData);

                            setState(() {
                              m.scannedCodeController.setCodeIfNotExiste =
                                  detectedCode;
                              setCardtoController(detectedCode);
                            });
                          }

                          print("Valid code entered: $code");
                          setState(() {
                            isLoading = false;
                          });

                          widget.updateUI();
                          Get.to(RechargeCodeScanner());
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Colors.black),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading ? Waiting() : Container()
        ],
      ),
    );
  }
}
