import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_input_ip_port_dialog.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_toast.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting_dialog.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/screens/HOME/SCAN_IP_PORT/scan_ip_port_screen_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/file_transfert_service.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/APP_BAR/app_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/GENERAL_WIDGETS/custom_button.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/button_entrer_sortie.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Server_Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanIpPortScreen extends StatefulWidget {
  const ScanIpPortScreen({required this.filePath, required this.isAllFiles});
  final String filePath;
  final bool isAllFiles;

  @override
  _ScanIpPortScreenState createState() => _ScanIpPortScreenState();
}

class _ScanIpPortScreenState extends State<ScanIpPortScreen> {
  CameraController? cameraController;
  TextRecognizer? textRecognizer;
  bool isProcessing = false;
  String detectedCode = '';
  List<CameraDescription> _cameras = [];
  // int _selectedCameraIndex = 0; // 0 for rear, 1 for front
  bool _isFlashOn = false; // Flash state
  bool _isProcessing = false; // For preventing multiple actions at once
  String scanStatus = GbsSystemStrings.str_scanning;
  String? ip, port;
  bool isScanReady = false;
  final m = Get.put<ScanIpPortScreenController>(ScanIpPortScreenController());
  final AudioPlayer _audioPlayer = AudioPlayer();

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
  //   await Permission.camera.request();

  //   _cameras = await availableCameras();
  //   if (_cameras.isEmpty) {
  //     print('No cameras found!');
  //     return;
  //   }
  //   // Initialize camera with the selected index
  //   cameraController = CameraController(
  //     _cameras[_selectedCameraIndex],
  //     ResolutionPreset.medium,
  //     enableAudio: false,
  //   );

  //   await cameraController?.initialize();

  //   if (mounted) {
  //     cameraController?.startImageStream(processCameraImage);
  //     setState(() {});
  //   }
  // }

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

  void processCameraImage(CameraImage image) async {
    try {
      if (isProcessing) return;
      isProcessing = true;

      // Initial state for scanning result
      setState(() {
        scanStatus = GbsSystemStrings.str_scanning;
      });

      final inputImage = convertCameraImage(image);
      final recognizedText = await textRecognizer?.processImage(inputImage);
      if (recognizedText != null) {
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            final text = line.text;

            if (m.testCard(text: text).isNotEmpty) {
              _playSound();
              ip = m.testCard(text: text)[0];
              port = m.testCard(text: text)[1];

              setState(() {
                detectedCode = '$ip:$port';
                // Set the success status
                scanStatus = GbsSystemStrings.str_scan_succes;
              });
              stopTextRecognizer();

              break;
            }
          }
        }
      }

      isProcessing = false;
    } catch (e) {
      print("error $e");
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

    final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: InputImageRotation
            .rotation0deg, // You may adjust this depending on your camera orientation
        format: InputImageFormat.yuv420,
        bytesPerRow: 10);

    // Return the InputImage from bytes and metadata
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetadata,
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: GBSystemCustomAppBarScanIP(
              title: "Scan IP and Port",
              subtitle: "(Manual Scan)",
              onBackTap: () {
                Get.back();
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Camera Preview
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AspectRatio(
                                aspectRatio: 1, // Square view
                                child: cameraController != null &&
                                        cameraController!.value.isInitialized
                                    ? CameraPreview(cameraController!)
                                    : Container(),
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
                        // Scanned Code Count
                        Container(
                          padding: const EdgeInsets.all(10),
                          color: GbsSystemStrings.str_primary_color
                              .withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                                  InputDialog.show(
                                    onConfirm: (ipGet, portGet) {
                                      setState(() {
                                        ip = ipGet;
                                        port = portGet;
                                        detectedCode = "$ip:$port";
                                      });

                                      print(
                                          "User entered IP: $ip and Port: $port");
                                      // Save to SharedPreferences or use in your application logic
                                    },
                                  );
                                },
                                number: null,
                                icon: const Icon(
                                  CupertinoIcons.text_append,
                                  color: Colors.white,
                                ),
                                verPadd:
                                    GBSystem_ScreenHelper.screenWidthPercentage(
                                        context, 0.02),
                                text: GbsSystemStrings.str_saisire,
                                color: GbsSystemStrings.str_primary_color,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ButtonEntrerSortieWithIconAndText(
                                onTap: () {
                                  stopTextRecognizer();
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

                        Visibility(
                          visible: detectedCode.isNotEmpty &&
                              ip != null &&
                              port != null,
                          child: Column(
                            children: [
                              Container(
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
                                child: GBSystem_TextHelper().normalText(
                                  text: detectedCode,
                                  textColor: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                  verPadding: 10,
                                  horPadding: 25,
                                  onTap: () async {
                                    WaitingDialog.show(
                                        message: "Uploading file...");

                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    sharedPreferences.setString(
                                        GbsSystemServerStrings.kIP, ip!);
                                    sharedPreferences.setString(
                                        GbsSystemServerStrings.kPort, port!);
                                    // upload single file
                                    if (!widget.isAllFiles) {
                                      try {
                                        ADBFileTransferService.uploadFile(
                                                context,
                                                filePath:
                                                    // "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                                                    widget.filePath,
                                                ip: ip!,
                                                port: int.parse(port!))
                                            .then(
                                          (value) {
                                            WaitingDialog.hide();

                                            if (value) {
                                              showSuccesDialog(
                                                  context,
                                                  GbsSystemStrings
                                                      .str_operation_effectuer);
                                            } else {
                                              showToast(
                                                  text: GbsSystemStrings
                                                      .str_error_send_data);
                                            }
                                          },
                                        );
                                      } catch (e) {
                                        WaitingDialog.hide();

                                        debugPrint(e.toString());
                                      }
                                    } else {
                                      try {
                                        ADBFileTransferService.uploadFolder(
                                                context,
                                                folderPath:
                                                    // "/storage/emulated/0/Android/data/com.example.scan_cart_mobilis/files/",
                                                    widget.filePath,
                                                ip: ip!,
                                                port: int.parse(port!))
                                            .then(
                                          (value) {
                                            WaitingDialog.hide();

                                            if (value) {
                                              showSuccesDialog(
                                                  context,
                                                  GbsSystemStrings
                                                      .str_operation_effectuer);
                                            } else {
                                              showToast(
                                                  text: GbsSystemStrings
                                                      .str_error_send_data);
                                            }
                                          },
                                        );
                                      } catch (e) {
                                        WaitingDialog.hide();

                                        debugPrint(e.toString());
                                      }
                                    }
                                  },
                                  text: "Start Copier")
                            ],
                          ),
                        ),
                      ],
                    ),
            )),
        isLoading ? Waiting() : Container()
      ],
    );
  }
}
