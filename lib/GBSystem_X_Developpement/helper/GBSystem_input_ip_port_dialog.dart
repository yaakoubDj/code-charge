import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputDialog {
  static void show({
    required Function(String ip, String port) onConfirm,
    String initialIp = '',
    String initialPort = '',
  }) {
    final ipController = TextEditingController(text: initialIp);
    final portController = TextEditingController(text: initialPort);

    Get.dialog(
      AlertDialog(
        title: Text("Enter IP and Port"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              decoration: InputDecoration(
                labelText: "IP Address",
                hintText: "e.g., 192.168.1.100",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: portController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Port",
                hintText: "e.g., 3000",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final ip = ipController.text.trim();
              final port = portController.text.trim();

              if (ip.isNotEmpty && port.isNotEmpty) {
                onConfirm(ip, port); // Pass entered data to the callback
                Get.back(); // Close dialog
              } else {
                Get.snackbar("Error", "Both fields are required.");
              }
            },
            child: Text("Confirm"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
