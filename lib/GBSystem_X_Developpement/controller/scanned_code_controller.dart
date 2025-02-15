import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/models/code_scanned_model.dart';

class GBSystemScannedCodeController extends GetxController {
  Rx<List<String>?>? _allCodes = Rx<List<String>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel = Rx<List<CodeScannedModel>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel_mobilis2000 =
      Rx<List<CodeScannedModel>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel_mobilis1000 =
      Rx<List<CodeScannedModel>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel_mobilis500 =
      Rx<List<CodeScannedModel>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel_mobilis200_one_line =
      Rx<List<CodeScannedModel>?>([]);
  Rx<List<CodeScannedModel>?>? _allCodesModel_mobilis200_two_line =
      Rx<List<CodeScannedModel>?>([]);

  Rx<String?>? _currentCode = Rx<String?>(null);
  RxInt _cardSelectedNumber = RxInt(0); // from drop down
  RxInt _cardSelectedNumberResult = RxInt(0); // from drop down result

  RxBool _createNewFolder = RxBool(true);
  RxBool _isAuto = RxBool(true);

  set setCode(String Code) {
    _allCodes?.value?.add(Code);
    update();
  }

  set setAutoManual(bool auto) {
    _isAuto.value = auto;
    update();
  }

  set setCreateFolder(bool CreateFolder) {
    _createNewFolder.value = CreateFolder;
    update();
  }

  set setSelectedCardNumber(int cardNumber) {
    _cardSelectedNumber.value = cardNumber;
    update();
  }

  set setSelectedCardNumberResult(int cardNumberResult) {
    _cardSelectedNumberResult.value = cardNumberResult;
    update();
  }

  set setCodeIfNotExiste(String Code) {
    if (_allCodes?.value?.contains(Code) != true) {
      _allCodes?.value?.add(Code);
    }
    update();
  }

  set setCodeModelIfNotExiste(CodeScannedModel CodeModel) {
    _allCodesModel?.value?.add(CodeModel);
    _allCodesModel?.value = _allCodesModel?.value?.toSet().toList();
    update();
  }

  set setCodeModelIfNotExiste_Mobilis2000(CodeScannedModel CodeModel) {
    _allCodesModel_mobilis2000?.value?.add(CodeModel);
    _allCodesModel_mobilis2000?.value =
        _allCodesModel_mobilis2000?.value?.toSet().toList();
    update();
  }

  set setCodeModelIfNotExiste_Mobilis1000(CodeScannedModel CodeModel) {
    _allCodesModel_mobilis1000?.value?.add(CodeModel);
    _allCodesModel_mobilis1000?.value =
        _allCodesModel_mobilis1000?.value?.toSet().toList();
    update();
  }

  set setCodeModelIfNotExiste_Mobilis500(CodeScannedModel CodeModel) {
    _allCodesModel_mobilis500?.value?.add(CodeModel);
    _allCodesModel_mobilis500?.value =
        _allCodesModel_mobilis500?.value?.toSet().toList();
    update();
  }

  set setCodeModelIfNotExiste_Mobilis200_one_line(CodeScannedModel CodeModel) {
    _allCodesModel_mobilis200_one_line?.value?.add(CodeModel);
    _allCodesModel_mobilis200_one_line?.value =
        _allCodesModel_mobilis200_one_line?.value?.toSet().toList();
    update();
  }

  set setCodeModelIfNotExiste_Mobilis200_two_line(CodeScannedModel CodeModel) {
    _allCodesModel_mobilis200_two_line?.value?.add(CodeModel);
    _allCodesModel_mobilis200_two_line?.value =
        _allCodesModel_mobilis200_two_line?.value?.toSet().toList();
    update();
  }

  set setCurrentCodeCode(String? Code) {
    _currentCode?.value = Code;
    update();
  }

  set setCodeToLeft(String Code) {
    _allCodes?.value?.insert(0, Code);
    update();
  }

  set setCodeToRight(String Code) {
    _allCodes?.value?.insert(_allCodes!.value!.length, Code);
    update();
  }

  set setAllCode(List<String>? Codes) {
    _allCodes?.value = Codes;
    update();
  }

  void updateCodeFromAllCode(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromAllCodes({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateCodeFromMobilis2000(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel_mobilis2000?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromMobilis2000({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel_mobilis2000?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateCodeFromMobilis1000(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel_mobilis1000?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromMobilis1000({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel_mobilis1000?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateCodeFromMobilis500(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel_mobilis500?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromMobilis500({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel_mobilis500?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateCodeFromMobilis200_one_line(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel_mobilis200_one_line?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromMobilis200_one_line({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel_mobilis200_one_line?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void updateCodeFromMobilis200_two_lines(
      {required String codeCartToUpdate, required String newCodeCart}) {
    try {
      final model = _allCodesModel_mobilis200_two_line?.value?.firstWhere(
        (code) => code.codeCart == codeCartToUpdate,
      );

      // If found, modify its properties
      if (model != null) {
        model.codeCart = newCodeCart;
        debugPrint("Model updated: ${model.codeCart}, ${model.cartType}");
      } else {
        debugPrint("No model found with codeCart: $codeCartToUpdate");
      }
    } catch (e) {
      print("err $e");
    }
  }

  void deleteCodeFromMobilis200_two_line({required String codeCartToDelete}) {
    try {
      // Search for the item and remove it if found
      _allCodesModel_mobilis200_two_line?.value?.removeWhere(
        (code) => code.codeCart == codeCartToDelete,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  void clearAllData() {
    _allCodes = Rx<List<String>?>([]);
    _allCodesModel = Rx<List<CodeScannedModel>?>([]);
    _allCodesModel_mobilis2000 = Rx<List<CodeScannedModel>?>([]);
    _allCodesModel_mobilis1000 = Rx<List<CodeScannedModel>?>([]);
    _allCodesModel_mobilis500 = Rx<List<CodeScannedModel>?>([]);
    _allCodesModel_mobilis200_one_line = Rx<List<CodeScannedModel>?>([]);
    _allCodesModel_mobilis200_two_line = Rx<List<CodeScannedModel>?>([]);

    _currentCode = Rx<String?>(null);
    _cardSelectedNumber = RxInt(0);
    _cardSelectedNumberResult = RxInt(0);
    update();
  }

  Rx<List<String>?>? get getAllCodesRx => _allCodes;

  Rx<String?>? get getCurrentCodeRx => _currentCode;
  List<String>? get getAllCodes => _allCodes?.value;

  List<CodeScannedModel>? get getAllCodesModel => _allCodesModel?.value;
  Rx<List<CodeScannedModel>?>? get getAllCodesModelRx => _allCodesModel;

  List<CodeScannedModel>? get getAllCodes_mobilis2000 =>
      _allCodesModel_mobilis2000?.value;
  List<CodeScannedModel>? get getAllCodes_mobilis1000 =>
      _allCodesModel_mobilis1000?.value;
  List<CodeScannedModel>? get getAllCodes_mobilis500 =>
      _allCodesModel_mobilis500?.value;
  List<CodeScannedModel>? get getAllCodes_mobilis200_one_line =>
      _allCodesModel_mobilis200_one_line?.value;
  List<CodeScannedModel>? get getAllCodes_mobilis200_two_line =>
      _allCodesModel_mobilis200_two_line?.value;

  String? get getCurrentCode => _currentCode?.value;

  int get getSelectedCard => _cardSelectedNumber.value;
  RxInt get getSelectedCardRx => _cardSelectedNumber;

  int get getSelectedCardResult => _cardSelectedNumberResult.value;
  RxInt get getSelectedCardResultRx => _cardSelectedNumberResult;

  bool get getCreateFolderBool => _createNewFolder.value;
  RxBool get getCreateFolderBoolRx => _createNewFolder;
  RxBool get getAutoManual => _isAuto;

  int get getAllTypeCarteLength =>
      (_allCodesModel_mobilis2000?.value?.length ?? 0) +
      (_allCodesModel_mobilis1000?.value?.length ?? 0) +
      (_allCodesModel_mobilis500?.value?.length ?? 0) +
      (_allCodesModel_mobilis200_one_line?.value?.length ?? 0) +
      (_allCodesModel_mobilis200_two_line?.value?.length ?? 0);

  // Reactive variable to store the current highest folder index
  RxInt currentFolderIndex = 0.obs;

  void updateCodeAtListAll(String oldCode, String newCode) {
    try {
      CodeScannedModel model = _allCodesModel!.value!
          .firstWhere((model) => model.codeCart == oldCode);

      model.codeCart = newCode;
      update();
    } catch (e) {
      print(e);
    }
  }
}
