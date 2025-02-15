import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_toast.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/models/code_scanned_model.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/RECHARGE_CARD_SCANNER/recharge_card_scanner_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/add_code_manually_screen/add_code_manually_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/display_scanned_cart_screen/display_scanned_cart_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/search_card_screen.dart/search_card_screen.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/APP_BAR/app_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/GENERAL_WIDGETS/custom_text_field.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/button_entrer_sortie.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'package:vibration/vibration.dart';

class RechargeCodeScanner extends StatefulWidget {
  @override
  _RechargeCodeScannerState createState() => _RechargeCodeScannerState();
}

class _RechargeCodeScannerState extends State<RechargeCodeScanner> {
  bool isScanReady = false;

  CameraController? cameraController;
  TextRecognizer? textRecognizer;
  bool isProcessing = false;
  String detectedCode = '';
  Rx<ScrollController> scrollController =
      Rx<ScrollController>(ScrollController(initialScrollOffset: 0));
  int nombreCardScanner = 0;
  Uint8List? _imageData;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0; // 0 for rear, 1 for front
  bool _isFlashOn = false; // Flash state
  bool _isProcessing = false; // For preventing multiple actions at once
  int captureCount = 0; // Counter to track the number of captures
  String scanStatus = GbsSystemStrings.str_scanning;

  final ScreenshotController screenshotController = ScreenshotController();

  final m =
      Get.put<RechargeCardScannerController>(RechargeCardScannerController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  updateUI() {
    setState(() {});
  }

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sounds/scanner-beep.mp3'));
  }

  void _stopSound() async {
    await _audioPlayer.stop();
  }

  void startTextRecognizer() {
    setState(() {
      isScanReady = true;
    });
    if (textRecognizer == null) {
      textRecognizer = TextRecognizer();
    }
  }

  void stopTextRecognizer() {
    setState(() {
      isScanReady = false;
    });

    // Close and nullify TextRecognizer
    textRecognizer?.close();
    textRecognizer = null;
  }

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    textRecognizer?.close();
    super.dispose();
  }

  void vibration() async {
    if (await Vibration.hasVibrator() == true) {
      Vibration.vibrate();
    }
  }

  Future<void> initializeCamera() async {
    try {
      print("Requesting camera permission...");
      var status = await Permission.camera.request();
      if (status.isDenied) {
        print("Camera permission denied");
        return;
      }

      print("Fetching available cameras...");
      _cameras = await availableCameras();

      // Find the rear camera
      final rearCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => throw Exception("No rear camera found"),
      );

      print("Rear camera found: ${rearCamera.name}");

      // Initialize with the rear camera
      cameraController = CameraController(
        rearCamera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      await cameraController?.initialize();
      print("Camera initialized successfully!");

      if (mounted) {
        cameraController?.startImageStream(processCameraImage);
        setState(() {});
      }
    } catch (e, stackTrace) {
      print("Camera initialization failed: $e");
      print("Stack trace: $stackTrace");
    }
  }

  // Initialize the camera and get available cameras
  // Future<void> initializeCamera() async {
  //   try {
  //     await Permission.camera.request();

  //     _cameras = await availableCameras();
  //     for (var camera in _cameras) {
  //       print('Camera: ${camera.name}');
  //     }

  //     if (_cameras.isEmpty) {
  //       print('No cameras found!');
  //       return;
  //     }
  //     // Initialize camera with the selected index
  //     cameraController = CameraController(
  //       _cameras[_selectedCameraIndex],
  //       ResolutionPreset.medium,
  //       enableAudio: false,
  //     );

  //     await cameraController?.initialize();

  //     if (mounted) {
  //       cameraController?.startImageStream(processCameraImage);
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     print("camera initialise faildeddd");
  //   }
  // }

  // Flip between front and rear cameras
  Future<void> flipCamera() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Toggle the camera index
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;

    // Dispose the current controller before switching
    await cameraController?.dispose();
    cameraController = null; // Clear the old controller reference

    // Re-initialize the new camera
    cameraController = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.high,
    );

    try {
      // Ensure the new controller is initialized
      await cameraController?.initialize();
      if (mounted) {
        cameraController?.startImageStream(processCameraImage);
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> toggleFlash() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    if (_isFlashOn) {
      await cameraController?.setFlashMode(FlashMode.off);
      setState(() {
        _isFlashOn = false;
      });
    } else {
      await cameraController?.setFlashMode(FlashMode.torch);
      setState(() {
        _isFlashOn = true;
      });
    }

    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> captureScreen(String textContent) async {
    try {
      var image = await screenshotController.capture();
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

// Method to pause the camera stream
  Future<void> pauseCamera() async {
    if (cameraController != null && cameraController!.value.isStreamingImages) {
      await cameraController?.stopImageStream();
      setState(() {}); // Update UI state
    }
  }

// Method to resume the camera stream
  Future<void> resumeCamera() async {
    if (cameraController != null &&
        !cameraController!.value.isStreamingImages) {
      await cameraController?.startImageStream(processCameraImage);
      setState(() {}); // Update UI state
    }
  }

  void maxScrollListView() {
    if (scrollController.value.hasClients &&
        scrollController.value.position.maxScrollExtent > 0) {
      scrollController.value.animateTo(
        scrollController.value.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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

  Future<void> processAssetImage() async {
    String? reconizedText;
    try {
      // Load the asset image
      final byteData = await rootBundle.load('assets/images/cardTest.jpg');
      final file = File('${(await getTemporaryDirectory()).path}/cardTest.jpg');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      // Create an InputImage
      final inputImage = InputImage.fromFilePath(file.path);

      // Initialize TextRecognizer
      final textRecognizer = TextRecognizer();

      // Process the image
      final recognizedTextResult =
          await textRecognizer.processImage(inputImage);

      setState(() {
        reconizedText = recognizedTextResult.text.isNotEmpty
            ? recognizedTextResult.text
            : 'No text recognized in the image.';
      });

      // Dispose of the TextRecognizer
      textRecognizer.close();
      print("reconizeeed $reconizedText");
    } catch (e) {
      setState(() {
        reconizedText = 'Error processing image: $e';
      });
    }
  }

  void processCameraImage(CameraImage image) async {
    if (m.scannedCodeController.getSelectedCard != 4) {
      if (isProcessing) return;
      isProcessing = true;

      // Initial state for scanning result
      setState(() {
        scanStatus = GbsSystemStrings.str_scanning;
      });

      final inputImage = convertCameraImage(image);
      // final byteData = await rootBundle.load('assets/images/cardTest.jpg');
      // final file = File('${(await getTemporaryDirectory()).path}/cardTest.jpg');
      // await file.writeAsBytes(byteData.buffer.asUint8List());

      // // Create an InputImage
      // final inputImage = InputImage.fromFilePath(file.path);

      final recognizedText = await textRecognizer?.processImage(inputImage);
      if (recognizedText != null) {
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            final text = line.text;

            if (m.testCard(
                numberTopic: m.scannedCodeController.getSelectedCard,
                text: text)) {
              print("here !!! ");
              if (!m.scannedCodeController.getAutoManual.value) {
                stopTextRecognizer();
              }

              _playSound();

              setState(() {
                detectedCode = m
                    .getNumericPattern(
                        numberTopic: m.scannedCodeController.getSelectedCard)
                    .firstMatch(text)!
                    .group(0)!
                    .replaceAll(' ', '');
                // Set the success status
                scanStatus = GbsSystemStrings.str_scan_succes;
              });
              if (captureCount < 2) {
                await captureScreen(m
                    .getNumericPattern(
                        numberTopic: m.scannedCodeController.getSelectedCard)
                    .firstMatch(text)!
                    .group(0)!
                    .replaceAll(' ', ''));
              }

              setState(() {
                // Extract the matched number and remove spaces
                m.scannedCodeController.setCodeIfNotExiste = detectedCode;

                setCardtoController(detectedCode);
              });

              maxScrollListView();

              if (captureCount == 2) {
                // Reset counter after capturing twice
                captureCount = 0; // Reset the counter for the next valid scan
                break; // Exit the loop after capturing twice
              }

              break;
            }
          }
        }
      }

      isProcessing = false;
    } else {
      if (isProcessing) return;
      isProcessing = true;

      // Initial state for scanning result
      setState(() {
        scanStatus = GbsSystemStrings.str_scanning;
      });

      final inputImage = convertCameraImage(image);

      final recognizedText = await textRecognizer?.processImage(inputImage);
      String concatenatedText = ""; // To store combined text of two lines
      // Iterate through text blocks and lines
      if (textRecognizer != null) {
        for (TextBlock block in recognizedText!.blocks) {
          for (int i = 0; i < block.lines.length - 1; i++) {
            final currentLineText = block.lines[i].text;
            final nextLineText = block.lines[i + 1].text;

            // Combine the current line with the next line
            concatenatedText = "$currentLineText $nextLineText";

            print("Concatenated Text: $concatenatedText");
            print("Text Length: ${concatenatedText.length}");

            // Test the combined text pattern
            if (m.testCard(
                numberTopic: m.scannedCodeController.getSelectedCard,
                text: concatenatedText)) {
              print("Match Found!");
              if (!m.scannedCodeController.getAutoManual.value) {
                stopTextRecognizer();
              }

              _playSound();

              setState(() {
                detectedCode =
                    // concatenatedText.replaceAll(" ", "");
                    m
                        .getNumericPattern(
                            numberTopic:
                                m.scannedCodeController.getSelectedCard)
                        .firstMatch(concatenatedText)!
                        .group(0)!
                        .replaceAll(' ', '');

                // Set the success status
                scanStatus = GbsSystemStrings.str_scan_succes;
              });

              if (captureCount < 2) {
                await captureScreen(detectedCode);
              }

              setState(() {
                // Update the scanned code controller
                m.scannedCodeController.setCodeIfNotExiste = detectedCode;
                setCardtoController(detectedCode);
              });

              maxScrollListView();

              if (captureCount == 2) {
                // Reset counter after capturing twice
                captureCount = 0; // Reset the counter for the next valid scan
                break; // Exit the loop after capturing twice
              }

              break;
            }
          }
        }
      }

      isProcessing = false;
    }
  }

  InputImageRotation _determineRotation(CameraDescription description) {
    switch (description.sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        throw Exception(
            "Invalid sensor orientation: ${description.sensorOrientation}");
    }
  }

  InputImageFormat _determineFormat(CameraImage image) {
    switch (image.format.group) {
      case ImageFormatGroup.yuv420:
        return InputImageFormat.yuv420;
      case ImageFormatGroup.nv21:
        return InputImageFormat.nv21;
      case ImageFormatGroup.jpeg:
        return InputImageFormat.bgra8888; // Adjust as needed
      default:
        throw Exception("Unsupported image format: ${image.format.group}");
    }
  }

  InputImage convertCameraImage(CameraImage image) {
    // Convert CameraImage to InputImage for Google ML Kit
    final WriteBuffer allBytes = WriteBuffer();

    // Combine the bytes from all the planes into a single buffer
    for (var plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();

    // Prepare the image metadata
    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final rotation = cameraController != null
        ? _determineRotation(cameraController!.description)
        : InputImageRotation.rotation0deg; // Dynamic rotation
    final format = _determineFormat(image); // Dynamic format

    final inputImageMetadata = InputImageMetadata(
      size: imageSize,
      // rotation: InputImageRotation
      //     .rotation0deg, // You may adjust this depending on your camera orientation
      rotation: rotation,
      // format: InputImageFormat.yuv420,
      format: format,
      bytesPerRow: image.planes.isNotEmpty ? image.planes[0].bytesPerRow : 10,

      // bytesPerRow: 10
    );
    // Return the InputImage from bytes and metadata
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetadata,
    );
  }

  void updateCode({required String cardCode, required int type}) {
    TextEditingController controllerCode =
        TextEditingController(text: cardCode);
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

                    int scienceScanNumber = await StockageService
                        .getLastScienceScanNumberAutomatically();
                    await StockageService.modifyTextFileFolderAndImages(
                            scienceScanNumber: scienceScanNumber,
                            cardType: carteTypeString[type],
                            cardCode: cardCode,
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
                        m.scannedCodeController.updateCodeFromAllCode(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                        m.scannedCodeController.updateCodeFromMobilis2000(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                      });
                    } else if (type == 1) {
                      setState(() {
                        m.scannedCodeController.updateCodeFromAllCode(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                        m.scannedCodeController.updateCodeFromMobilis1000(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                      });
                    } else if (type == 2) {
                      setState(() {
                        m.scannedCodeController.updateCodeFromAllCode(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                        m.scannedCodeController.updateCodeFromMobilis500(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                      });
                    } else if (type == 3) {
                      setState(() {
                        m.scannedCodeController.updateCodeFromAllCode(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                        m.scannedCodeController
                            .updateCodeFromMobilis200_one_line(
                                codeCartToUpdate: cardCode,
                                newCodeCart: controllerCode.text);
                      });
                    } else {
                      setState(() {
                        m.scannedCodeController.updateCodeFromAllCode(
                            codeCartToUpdate: cardCode,
                            newCodeCart: controllerCode.text);
                        m.scannedCodeController
                            .updateCodeFromMobilis200_two_lines(
                                codeCartToUpdate: cardCode,
                                newCodeCart: controllerCode.text);
                      });
                    }

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

  void deleteCode({required String cardCode, required int type}) {
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

        int scienceScanNumber =
            await StockageService.getLastScienceScanNumberAutomatically();
        await StockageService.deleteFolder(
          scienceScanNumber: scienceScanNumber,
          cardType: carteTypeString[type],
          cardCode: cardCode,
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
            m.scannedCodeController.deleteCodeFromAllCodes(
              codeCartToDelete: cardCode,
            );
            m.scannedCodeController.deleteCodeFromMobilis2000(
              codeCartToDelete: cardCode,
            );
          });
        } else if (type == 1) {
          setState(() {
            m.scannedCodeController.deleteCodeFromAllCodes(
              codeCartToDelete: cardCode,
            );
            m.scannedCodeController.deleteCodeFromMobilis1000(
              codeCartToDelete: cardCode,
            );
          });
        } else if (type == 2) {
          setState(() {
            m.scannedCodeController.deleteCodeFromAllCodes(
              codeCartToDelete: cardCode,
            );
            m.scannedCodeController.deleteCodeFromMobilis500(
              codeCartToDelete: cardCode,
            );
          });
        } else if (type == 3) {
          setState(() {
            m.scannedCodeController.deleteCodeFromAllCodes(
              codeCartToDelete: cardCode,
            );
            m.scannedCodeController.deleteCodeFromMobilis200_one_line(
              codeCartToDelete: cardCode,
            );
          });
        } else {
          setState(() {
            m.scannedCodeController.deleteCodeFromAllCodes(
              codeCartToDelete: cardCode,
            );
            m.scannedCodeController.deleteCodeFromMobilis200_two_line(
              codeCartToDelete: cardCode,
            );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        exit(0);
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: !m.scannedCodeController.getAutoManual.value
              ? FloatingActionButton(
                  backgroundColor: GbsSystemStrings.str_primary_color,
                  child: Icon(
                    Icons.autorenew,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (!m.scannedCodeController.getAutoManual.value) {
                      startTextRecognizer();
                    }
                  },
                )
              : null,
          appBar: GBSystemCustomAppBar(
            reInitiliseCamera: initializeCamera,
            stopTextReconizer: stopTextRecognizer,
            title: "Recharge Card Mobilis",
            onSearchTap: () {
              stopTextRecognizer();
              Get.to(SearchCardScreen());
            },
            onAddManuallyTap: () {
              Get.to(AddCodeManuallyScreen(
                updateUI: updateUI,
              ));
            },
          ),
          backgroundColor: Colors.grey[200],
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: cameraController == null
                ? Center(child: Waiting())
                : Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera Preview
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AspectRatio(
                                aspectRatio: 1, // Square view
                                child: Screenshot(
                                    controller: screenshotController,
                                    child: cameraController != null &&
                                            cameraController!
                                                .value.isInitialized
                                        ? CameraPreview(cameraController!)
                                        : Container()),
                              ),
                            ),
                            // Detected Code Display
                            Positioned(
                              top: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isFlashOn
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        toggleFlash, // Toggle flash on button press
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // Scanned Code Count
                      Container(
                        padding: const EdgeInsets.all(10),
                        color:
                            GbsSystemStrings.str_primary_color.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  if (m.scannedCodeController.getAllCodesModelRx
                                              ?.value !=
                                          null &&
                                      m
                                          .scannedCodeController
                                          .getAllCodesModelRx!
                                          .value!
                                          .isNotEmpty) {
                                    // Concatenate all items into a single string
                                    String concatenatedText = m
                                        .scannedCodeController
                                        .getAllCodesModelRx!
                                        .value!
                                        .map(
                                          (e) => e.codeCart,
                                        )
                                        .join("\n");

                                    // Copy to clipboard
                                    Clipboard.setData(
                                        ClipboardData(text: concatenatedText));
                                    // Show confirmation message
                                    showToast(
                                        text: "Codes copied to clipboard");
                                  } else {
                                    showToast(
                                        text: "There is no code to copy !");
                                  }
                                },
                                child: Icon(Icons.copy)),
                            GBSystem_TextHelper().normalText(
                              text: isScanReady == false
                                  ? GbsSystemStrings.str_not_started_yet
                                  : scanStatus,
                              textColor: isScanReady &&
                                      scanStatus ==
                                          GbsSystemStrings.str_scan_succes
                                  ? Colors.green
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_scanner,
                                    color: Colors.black87),
                                SizedBox(
                                  width: 5,
                                ),
                                GBSystem_TextHelper().smallText(
                                  text:
                                      "${m.scannedCodeController.getAllTypeCarteLength.toString()}",
                                  textColor: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ButtonEntrerSortieWithIconAndText(
                              onTap: () {
                                startTextRecognizer();
                              },
                              number: null,
                              icon: const Icon(
                                CupertinoIcons.hand_draw_fill,
                                color: Colors.white,
                              ),
                              verPadd:
                                  GBSystem_ScreenHelper.screenWidthPercentage(
                                      context, 0.02),
                              text: GbsSystemStrings.str_debut,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ButtonEntrerSortieWithIconAndText(
                              onTap: () {
                                // processAssetImage();
                                stopTextRecognizer();
                                Get.to(DisplayScannedCartScreen());
                              },
                              number: null,
                              icon: const Icon(
                                CupertinoIcons.hand_draw_fill,
                                color: Colors.white,
                              ),
                              verPadd:
                                  GBSystem_ScreenHelper.screenWidthPercentage(
                                      context, 0.02),
                              text: GbsSystemStrings.str_fin,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      // Scanned Codes List

                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Obx(
                            () => m.scannedCodeController.getAllCodesRx
                                            ?.value !=
                                        null &&
                                    m.scannedCodeController.getAllCodesRx!
                                        .value!.isNotEmpty
                                ? ListView.separated(
                                    controller: scrollController.value,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: m
                                            .scannedCodeController
                                            .getAllCodesModelRx
                                            ?.value
                                            ?.length ??
                                        0,
                                    separatorBuilder: (_, __) => const Divider(
                                      height: 5,
                                      color: Colors.grey,
                                    ),
                                    itemBuilder: (context, index) => ListTile(
                                      leading: Icon(
                                        Icons.qr_code_2,
                                        color:
                                            GbsSystemStrings.str_primary_color,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit,
                                                color: Colors.black54),
                                            onPressed: () {
                                              // Handle update action
                                              updateCode(
                                                  cardCode: m
                                                      .scannedCodeController
                                                      .getAllCodesModelRx!
                                                      .value![index]
                                                      .codeCart,
                                                  type: m.scannedCodeController
                                                      .getSelectedCard);
                                              debugPrint(
                                                  "Update button pressed for: ${m.scannedCodeController.getAllCodesModelRx?.value?[index].codeCart}");
                                              // Add your update logic here
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.black54),
                                            onPressed: () {
                                              // Handle delete action
                                              deleteCode(
                                                  cardCode: m
                                                      .scannedCodeController
                                                      .getAllCodesModelRx!
                                                      .value![index]
                                                      .codeCart,
                                                  type: m.scannedCodeController
                                                      .getSelectedCard);
                                              debugPrint(
                                                  "Delete button pressed for: ${m.scannedCodeController.getAllCodesModelRx?.value?[index].codeCart}");
                                            },
                                          ),
                                        ],
                                      ),
                                      title: GBSystem_TextHelper().smallText(
                                        text: m
                                                .scannedCodeController
                                                .getAllCodesModelRx
                                                ?.value?[index]
                                                .codeCart ??
                                            "",
                                        textColor: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: GBSystem_TextHelper().smallText(
                                      text: "No code scanned yet",
                                      textColor: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
          )),
    );
  }
}
