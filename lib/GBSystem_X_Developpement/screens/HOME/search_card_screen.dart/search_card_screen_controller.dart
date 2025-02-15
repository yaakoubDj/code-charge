import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/services/stockage_service.dart';

class SearchCardScreenController extends GetxController {
  SearchCardScreenController({
    required this.context,
  });
  BuildContext context;

  RxBool isLoading = RxBool(false), isSelectedImage = RxBool(false);
  RxList<FileSystemEntity> photos = RxList<FileSystemEntity>([]);
  Rx<FileSystemEntity?> selectedImage = Rx<FileSystemEntity?>(null);

  RxInt imageIndex = RxInt(0);

  RxString? text = RxString("");
  TextEditingController controllerSearch = TextEditingController();

  void updateString(String str) {
    text?.value = str;
    update();
  }

  Future<void> filterDataCards(String query) async {
    text?.value = query;
    await StockageService().getImagesFromFolder(cardNumber: query).then(
      (value) {
        print("photo found : ${value.length}");
        photos.value = value;
      },
    );
  }
}
