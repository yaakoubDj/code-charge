import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

class ADBFileTransferService {
  static Future<bool> uploadFolder(BuildContext context,
      {required String folderPath,
      required String ip,
      required int port}) async {
    try {
      // Ensure the folder exists
      Directory folder = Directory(folderPath);
      if (!folder.existsSync()) {
        print("Folder does not exist: $folderPath");
        return false;
      }

      // Create a zip file from the folder
      String zipFilePath =
          '${folder.parent.path}/${p.basename(folder.path)}.zip';
      File zipFile = File(zipFilePath);
      var encoder = ZipFileEncoder();
      encoder.create(zipFile.path);
      encoder.addDirectory(folder, includeDirName: true);
      encoder.close();

      // Server URL (constructed using IP and port)
      String url = 'http://$ip:$port/upload';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files
          .add(await http.MultipartFile.fromPath('file', zipFile.path));

      // Send the request
      var response = await request.send().timeout(Duration(seconds: 10));

      // Handle the response
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("Folder uploaded successfully.");
        print("Response body: $responseBody");

        // Clean up zip file
        if (zipFile.existsSync()) zipFile.deleteSync();

        return true;
      } else {
        print("Failed to upload folder. Status: ${response.statusCode}");
        print("Response body: $responseBody");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }

  // static Future<bool> uploadFile(BuildContext context,
  //     {required String filePath, required String ip, required int port}) async {
  //   try {
  //     print("fileeee $filePath");
  //     // Get the current date
  //     DateTime now = DateTime.now();
  //     String formattedDate = "${now.day}-${now.month}-${now.year}";

  //     // Construct the new folder path
  //     File originalFile = File(filePath);
  //     String folderPath = "${originalFile.parent.path}/$formattedDate";

  //     // Create the folder if it doesn't exist
  //     Directory(folderPath).createSync(recursive: true);

  //     // Construct the new file path
  //     String newFilePath = "$folderPath/${originalFile.uri.pathSegments.last}";
  //     print("fileeee $newFilePath");

  //     // Move the file to the new folder
  //     File newFile = originalFile.renameSync(newFilePath);

  //     // Server URL (constructed using IP and port)
  //     String url = 'http://$ip:$port/upload';

  //     // Create a multipart request
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.files
  //         .add(await http.MultipartFile.fromPath('file', newFile.path));

  //     // Send the request
  //     var response = await request.send().timeout(Duration(seconds: 10));

  //     // Handle the response
  //     String responseBody = await response.stream.bytesToString();
  //     if (response.statusCode == 200) {
  //       print("File uploaded successfully.");
  //       print("Response body: $responseBody");

  //       // Parse the response
  //       var jsonResponse = json.decode(responseBody);

  //       // Validate the presence of the filePath key
  //       if (jsonResponse is Map<String, dynamic> &&
  //           jsonResponse.containsKey('filePath') &&
  //           jsonResponse['filePath'] is String) {
  //         String savedFilePath = jsonResponse['filePath'];
  //         print('File saved at: $savedFilePath');
  //       } else {
  //         print("Invalid response: filePath key is missing or invalid.");
  //       }
  //       return true;
  //     } else {
  //       print("Failed to upload file. Status: ${response.statusCode}");
  //       print("Response body: $responseBody");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     return false;
  //   }
  // }

  static Future<bool> uploadFile(BuildContext context,
      {required String filePath, required String ip, required int port}) async {
    try {
      File file = File(filePath);

      // Server URL (constructed using IP and port)
      String url = 'http://$ip:$port/upload';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Send the request
      var response = await request.send().timeout(Duration(seconds: 10));

      // Handle the response
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("File uploaded successfully.");
        print("Response body: $responseBody");

        // Parse the response
        var jsonResponse = json.decode(responseBody);

        // Validate the presence of the filePath key
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('filePath') &&
            jsonResponse['filePath'] is String) {
          String savedFilePath = jsonResponse['filePath'];
          print('File saved at: $savedFilePath');
        } else {
          print("Invalid response: filePath key is missing or invalid.");
        }
        return true;
      } else {
        print("Failed to upload file. Status: ${response.statusCode}");
        print("Response body: $responseBody");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }

  static Future<bool> uploadFiles(
    BuildContext context, {
    required List<String> filePaths,
    required String ip,
    required int port,
  }) async {
    try {
      // Server URL (constructed using IP and port)
      String url = 'http://$ip:$port/upload';

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add each file to the request
      for (String filePath in filePaths) {
        File file = File(filePath);
        if (await file.exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('files', file.path));
        } else {
          print("File does not exist: $filePath");
          return false;
        }
      }

      // Send the request
      var response = await request.send().timeout(Duration(seconds: 10));

      // Handle the response
      String responseBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print("Files uploaded successfully.");
        print("Response body: $responseBody");

        // Parse the response
        var jsonResponse = json.decode(responseBody);

        // Validate the response
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('filePaths') &&
            jsonResponse['filePaths'] is List) {
          List<dynamic> savedFilePaths = jsonResponse['filePaths'];
          print('Files saved at: $savedFilePaths');
        } else {
          print("Invalid response: filePaths key is missing or invalid.");
        }
        return true;
      } else {
        print("Failed to upload files. Status: ${response.statusCode}");
        print("Response body: $responseBody");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }

  // static Future<bool> uploadFile(BuildContext context,
  //     {required String filePath, required String ip, required int port}) async {
  //   try {
  //     File file = File(filePath);

  //     // Server URL (constructed using IP and port)
  //     String url = 'http://$ip:$port/upload';

  //     // Create a multipart request
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.files.add(await http.MultipartFile.fromPath('file', file.path));

  //     // Send the request
  //     var response = await request.send();
  //     // // Handle the response
  //     response.stream.bytesToString().then((value) {
  //       // Check if the file upload was successful
  //       if (response.statusCode == 200) {
  //         print("File uploaded successfully.");

  //         // Parse the response and get the file path (assuming JSON response)
  //         var jsonResponse = json.decode(value);
  //         String filePath = jsonResponse['filePath'];
  //         print('File saved at: $filePath');
  //         return true;
  //       } else {
  //         print("Failed to upload file. Status: ${response.statusCode}");
  //         return false;
  //       }
  //     });
  //   } catch (e) {
  //     print("Error quelque part $e");
  //     return false;
  //   }
  //   return true;
  // }

  String ipAddress = '';
  String port = '3000'; // Default port
  String output = '';

  // Run the Node.js server and get the IP and port
  // Future<void> runCommand() async {
  //   try {
  //     // Run the Node.js server (replace with your own path and command)
  //     ProcessResult result = await Process.run('node', ['index.js'],
  //         workingDirectory: 'C:\\Users\\hp\\my-server');

  //     if (result.exitCode == 0) {
  //       output = 'Server started successfully!\n' + result.stdout.toString();
  //     } else {
  //       output = 'Error: ${result.stderr}';
  //     }

  //     // Get the local IP address
  //     var ipResult = await Process.run('ipconfig', []);
  //     ipAddress = _extractIpAddress(ipResult.stdout);
  //   } catch (e) {
  //     output = 'Failed to run command: $e';
  //   }
  //   print("output $output");
  // }

  // Extract IP address from ipconfig output
  String _extractIpAddress(String output) {
    RegExp regex = RegExp(r'IPv4 Address[. ]*:\s*(\d+\.\d+\.\d+\.\d+)');
    var match = regex.firstMatch(output);
    return match != null ? match.group(1)! : 'Unknown';
  }
}
