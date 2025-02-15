import 'package:get/get.dart';

class ScanIpPortScreenController extends GetxController {
  List<String> testCard({required String text}) {
    RegExp regex = RegExp(r'http:\/\/(\d+\.\d+\.\d+\.\d+):(\d+)');

    // Apply the regular expression to the string
    Match? match = regex.firstMatch(text);

    if (match != null) {
      // Extract the IP address and port from the match
      String ip = match.group(1)!; // IP address
      String port = match.group(2)!; // Port

      print("IP Address: $ip");
      print("Port: $port");
      return [ip, port];
    } else {
      print("IP and Port not found.");
      return [];
    }
  }

  RegExp getNumericPattern({required int numberTopic}) {
    // carte 1000 , 2000 ,500
    if (numberTopic == 0 || numberTopic == 1 || numberTopic == 2) {
      // return RegExp(r'^(\d[\s\n]?){14}$');

      return RegExp(r'(\d\s?){15}');
      // carte 200 une line
    } else if (numberTopic == 3) {
      return RegExp(r'^\d{14}$');
    }
    // carte 200 2 line

    else {
      {
        return RegExp(r'(\d[\s\n]?){14}');
      }
    }
  }
}
