import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/controller/scanned_code_controller.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_ScreenHelper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_format_date.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_snack_bar.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_text_helper.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_toast.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/helper/GBSystem_waiting.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';
import 'package:scan_cart_mobilis/_RessourceStrings/GBSystem_Application_Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GBSystemCustomAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const GBSystemCustomAppBar({
    super.key,
    required this.title,
    this.onSearchTap,
    this.reInitiliseCamera,
    this.stopTextReconizer,
    this.onAddManuallyTap,
  });
  final String title;
  final void Function()? onSearchTap,
      reInitiliseCamera,
      stopTextReconizer,
      onAddManuallyTap;

  @override
  State<GBSystemCustomAppBar> createState() => _GBSystemCustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(185);
}

class _GBSystemCustomAppBarState extends State<GBSystemCustomAppBar> {
  final scannedCodeController =
      Get.put<GBSystemScannedCodeController>(GBSystemScannedCodeController());

  // Dropdown items
  final List<String> cardOptions = [
    "MOBILIS 2000",
    "MOBILIS 1000",
    "MOBILIS 500",
    "MOBILIS 200 (1 line)",
    "MOBILIS 200 (2 lines)"
  ];
  String selectedCard = "MOBILIS 2000";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? selected =
          sharedPreferences.getString(GbsSystemStrings.kSelectedCard);
      selectedCard = cardOptions[selected != null
          ? int.parse(selected)
          : scannedCodeController.getSelectedCard];
      scannedCodeController.setSelectedCardNumber =
          selected != null ? int.parse(selected) : 0;
      print("seleetttct ${scannedCodeController.getSelectedCard}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GBSystem_ScreenHelper.screenWidthPercentage(context, 0.04),
        vertical: GBSystem_ScreenHelper.screenHeightPercentage(context, 0.02),
      ),
      decoration: BoxDecoration(
        color: GbsSystemStrings.str_primary_color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title and profile icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    scannedCodeController.setAutoManual =
                        !scannedCodeController.getAutoManual.value;
                  });
                  // if (widget.stopTextReconizer != null) {
                  //   widget.stopTextReconizer!();
                  // }
                  showToast(
                      text: scannedCodeController.getAutoManual.value
                          ? "Navigate to Auto Mode"
                          : "Navigate to Manuall Mode");
                },
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Center(
                      child: GBSystem_TextHelper().largeText(
                          text: scannedCodeController.getAutoManual.value
                              ? "A"
                              : "M",
                          textColor: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              // Title
              Expanded(
                child: Center(
                  child: GBSystem_TextHelper().largeText(
                    text: widget.title,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Search icon
              InkWell(
                onTap: widget.onSearchTap,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Dropdown for selecting card type
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => DropdownButton<String>(
                  value: cardOptions[
                      scannedCodeController.getSelectedCardRx.value],
                  isExpanded: true,
                  dropdownColor: GbsSystemStrings.str_primary_color,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  onChanged: (String? newValue) async {
                    if (scannedCodeController.getAllCodesModel != null &&
                        scannedCodeController.getAllCodesModel!.isNotEmpty) {
                      showWarningDialog(context,
                          "You can't scan multi-type in same scan science");
                    } else {
                      setState(() {
                        selectedCard = newValue!;
                      });
                      if (selectedCard == 4) {
                        widget.reInitiliseCamera!();
                      }
                      // Update the controller based on selection
                      scannedCodeController.setSelectedCardNumber =
                          cardOptions.indexOf(selectedCard);
                      scannedCodeController.setSelectedCardNumberResult =
                          cardOptions.indexOf(selectedCard);

                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString(
                          GbsSystemStrings.kSelectedCard,
                          scannedCodeController.getSelectedCard.toString());
                      sharedPreferences.setString(
                          GbsSystemStrings.kSelectedCardResult,
                          scannedCodeController.getSelectedCard.toString());

                      print(
                          "seleetttct ${scannedCodeController.getSelectedCard}");

                      // if (widget.stopTextReconizer != null) {
                      //   widget.stopTextReconizer!();
                      // }
                    }
                  },
                  items:
                      cardOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          CupertinoButton(
            onPressed: widget.onAddManuallyTap,
            padding: EdgeInsets.zero,
            child: GBSystem_TextHelper().normalText(
                text: "Add Cart Manually",
                textColor: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class GBSystemCustomAppBarResult extends StatefulWidget
    implements PreferredSizeWidget {
  const GBSystemCustomAppBarResult({
    super.key,
    required this.title,
    this.onBackTap,
  });
  final String title;
  final void Function()? onBackTap;
  @override
  State<GBSystemCustomAppBarResult> createState() =>
      _GBSystemCustomAppBarResultState();

  @override
  Size get preferredSize => const Size.fromHeight(180);
}

class _GBSystemCustomAppBarResultState
    extends State<GBSystemCustomAppBarResult> {
  final scannedCodeController =
      Get.put<GBSystemScannedCodeController>(GBSystemScannedCodeController());

  // Dropdown items
  final List<String> cardOptions = [
    "MOBILIS 2000",
    "MOBILIS 1000",
    "MOBILIS 500",
    "MOBILIS 200 (1 line)",
    "MOBILIS 200 (2 lines)"
  ];
  String selectedCard = "MOBILIS 2000";
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? selected =
          sharedPreferences.getString(GbsSystemStrings.kSelectedCardResult);
      selectedCard = cardOptions[selected != null
          ? int.parse(selected)
          : scannedCodeController.getSelectedCardResult];
      scannedCodeController.setSelectedCardNumberResult =
          selected != null ? int.parse(selected) : 0;
      print("seleetttct ${scannedCodeController.getSelectedCardResult}");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GBSystem_ScreenHelper.screenWidthPercentage(context, 0.04),
        vertical: GBSystem_ScreenHelper.screenHeightPercentage(context, 0.02),
      ),
      decoration: BoxDecoration(
        color: GbsSystemStrings.str_primary_color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title and profile icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Optional avatar/profile icon
              InkWell(
                  onTap: widget.onBackTap,
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                  )),
              Visibility(
                visible: false,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              // Title
              Expanded(
                child: Center(
                  child: GBSystem_TextHelper().largeText(
                    text: widget.title,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black54,
                  ),
                  child: GBSystem_TextHelper().normalText(
                      text: scannedCodeController.getAllTypeCarteLength
                          .toString(),
                      fontWeight: FontWeight.bold,
                      textColor: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          // Dropdown for selecting card type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(
              () => DropdownButton<String>(
                value: cardOptions[
                    scannedCodeController.getSelectedCardResultRx.value],
                isExpanded: true,
                dropdownColor: GbsSystemStrings.str_primary_color,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                underline: SizedBox(),
                style: TextStyle(color: Colors.white, fontSize: 16),
                onChanged: (String? newValue) async {
                  setState(() {
                    selectedCard = newValue!;
                  });

                  // Update the controller based on selection
                  // Update the controller based on selection
                  scannedCodeController.setSelectedCardNumberResult =
                      cardOptions.indexOf(selectedCard);
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.setString(
                      GbsSystemStrings.kSelectedCardResult,
                      scannedCodeController.getSelectedCardResult.toString());
                  print(
                      "seleetttct ${scannedCodeController.getSelectedCardResult}");
                },
                items:
                    cardOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GBSystem_TextHelper().smallText(
                  text:
                      "${GbsystemFormatDate().fileDateFormat(date: DateTime.now())}  /  ",
                  textColor: Colors.white),
              FutureBuilder(
                future: StockageService.getLastScienceScanNumberAutomatically(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      return GBSystem_TextHelper().smallText(
                        text: scannedCodeController.getAllCodesModel != null &&
                                scannedCodeController
                                    .getAllCodesModel!.isNotEmpty
                            ?
                            // "science scan ${snapshot.data!.toInt() + 1}"
                            "science scan ${snapshot.data!.toInt()}"
                            :
                            // "science scan ${snapshot.data!.toInt() + 1}",
                            "science scan ${snapshot.data!.toInt()}",
                        textColor: Colors.white,
                      );
                    } else {
                      return GBSystem_TextHelper().smallText(
                        text: "new science scan",
                        textColor: Colors.white,
                      );
                    }
                  } else {
                    return WaitingWidgets();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class GBSystemCustomAppBarScanIP extends StatefulWidget
    implements PreferredSizeWidget {
  const GBSystemCustomAppBarScanIP({
    super.key,
    required this.title,
    required this.subtitle,
    this.onBackTap,
    this.showBackBtn = true,
  });
  final String title, subtitle;
  final void Function()? onBackTap;
  final bool showBackBtn;
  @override
  State<GBSystemCustomAppBarScanIP> createState() =>
      _GBSystemCustomAppBarScanIPState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _GBSystemCustomAppBarScanIPState
    extends State<GBSystemCustomAppBarScanIP> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: GBSystem_ScreenHelper.screenWidthPercentage(context, 0.04),
        vertical: GBSystem_ScreenHelper.screenHeightPercentage(context, 0.02),
      ),
      decoration: BoxDecoration(
        color: GbsSystemStrings.str_primary_color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title and profile icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: widget.showBackBtn,
                child: InkWell(
                    onTap: widget.onBackTap,
                    child: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                    )),
              ),
              Visibility(
                visible: false,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white54,
                  ),
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              // Title
              Expanded(
                child: Column(
                  children: [
                    Center(
                      child: GBSystem_TextHelper().largeText(
                        text: widget.title,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Center(
                      child: GBSystem_TextHelper().normalText(
                        text: widget.subtitle,
                        textColor: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Dropdown for selecting card type
        ],
      ),
    );
  }
}
