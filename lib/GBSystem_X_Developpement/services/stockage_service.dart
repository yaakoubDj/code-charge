import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/models/code_scanned_model.dart';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';

class StockageService {
  static Future<bool> storagePermission() async {
    final DeviceInfoPlugin info =
        DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    debugPrint('releaseVersion : ${androidInfo.version.release}');
    final double androidVersion = double.parse(androidInfo.version.release);
    bool havePermission = false;

    // Here you can use android api level
    // like android api level 33 = android 13
    // This way you can also find out how to request storage permission

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
        //..... as needed
      ].request(); //import 'package:permission_handler/permission_handler.dart';

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }

  static Future<String> zipDirectory(String directoryPath) async {
    // Get the directory to zip
    final directory = Directory(directoryPath);

    if (await directory.exists()) {
      // Create a new archive
      final archive = Archive();

      // Recursively add files and directories to the archive
      await _addFilesToArchive(directory, archive, directoryPath);

      // Get the path where you want to save the zip file (app's document directory)
      final appDocDir = await getApplicationDocumentsDirectory();
      final zipFilePath = '${appDocDir.path}/zipped_content.zip';

      // Create the zip file
      final zipFile = File(zipFilePath);
      if (ZipEncoder().encode(archive) != null) {
        await zipFile.writeAsBytes(ZipEncoder().encode(archive)!);
      }
      print('Zip file created at: $zipFilePath');

      return zipFilePath;
    } else {
      print('Directory does not exist.');
      return "";
    }
  }

// Function to recursively add files and subdirectories to the archive
  static Future<void> _addFilesToArchive(
      Directory directory, Archive archive, String parentPath) async {
    await for (var entity in directory.list(recursive: true)) {
      if (entity is File) {
        // Add files to the archive
        final fileBytes = await entity.readAsBytes();
        final relativePath = entity.path.replaceFirst(parentPath, '');
        archive.addFile(ArchiveFile(relativePath, fileBytes.length, fileBytes));
      }
    }
  }

  static Future<String> getAppSpecificFilesPath() async {
    try {
      // Get the app's specific directory
      final directory = await getExternalStorageDirectory();

      // Construct the desired path
      final fullPath = path.join(
        directory!.path,
      );

      // Check if the path exists
      final fullDirectory = Directory(fullPath);
      if (!await fullDirectory.exists()) {
        // Optionally, create the directory if it doesn't exist
        await fullDirectory.create(recursive: true);
      }

      return fullPath;
    } catch (e) {
      print('Error retrieving app-specific files path: $e');
      return '';
    }
  }

  static Future<bool> deleteFolder({
    required int scienceScanNumber,
    required String cardType,
    required String cardCode,
  }) async {
    try {
      // Get the external storage directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception("Storage directory not available");

      // Get the current date
      final currentDate = DateTime.now();
      final formattedDate =
          '${currentDate.day}-${currentDate.month}-${currentDate.year}';

      // Define the path to the folder
      final targetFolderPath = path.join(
        directory.path,
        'Pictures',
        'MyApp',
        formattedDate,
        'science_scan_$scienceScanNumber',
        cardType,
        cardCode,
      );

      // Check if the folder exists
      final folderToDelete = Directory(targetFolderPath);
      if (!await folderToDelete.exists()) {
        print('Folder not found at: $targetFolderPath');
        return false; // Folder does not exist
      }

      // Delete the folder and its contents
      await folderToDelete.delete(recursive: true);
      print('Folder deleted successfully: $targetFolderPath');
      return true; // Success
    } catch (e) {
      print('Error deleting folder: $e');
      return false; // Failure
    }
  }

  static Future<bool> modifyTextFileFolderAndImages({
    required int scienceScanNumber,
    required String cardType,
    required String cardCode,
    required String newCode,
  }) async {
    try {
      // Get the external storage directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception("Storage directory not available");

      // Get the current date
      final currentDate = DateTime.now();
      final formattedDate =
          '${currentDate.day}-${currentDate.month}-${currentDate.year}';

      // Define the path to the target folder
      final targetFolderPath = path.join(
        directory.path,
        'Pictures',
        'MyApp',
        formattedDate,
        'science_scan_$scienceScanNumber',
        cardType,
        cardCode,
      );

      // Define the path to the text file
      final textFilePath = path.join(targetFolderPath, 'content.txt');

      // Check if the text file exists
      final textFile = File(textFilePath);
      if (!await textFile.exists()) {
        print('Text file not found at: $textFilePath');
        return false; // File not found
      }

      // Modify the content of the text file
      await textFile.writeAsString(newCode);
      print('Text file modified successfully: $textFilePath');

      // Rename all image files in the folder
      final folderToRename = Directory(targetFolderPath);
      if (await folderToRename.exists()) {
        final imageFiles = folderToRename
            .listSync()
            .whereType<File>()
            .where((file) =>
                file.path.contains('saved_image') &&
                file.path.contains('_code_$cardCode'))
            .toList();

        if (imageFiles.isNotEmpty) {
          for (var imageFile in imageFiles) {
            final newImageName = imageFile.path
                .replaceFirst('_code_$cardCode', '_code_$newCode');
            await imageFile.rename(newImageName);
            print('Image file renamed successfully: $newImageName');
          }
        } else {
          print('No image files found for cardCode: $cardCode');
        }
      } else {
        print('Folder not found for renaming images: $targetFolderPath');
        return false; // Folder not found
      }

      // Rename the folder
      final newFolderPath = path.join(
        directory.path,
        'Pictures',
        'MyApp',
        formattedDate,
        'science_scan_$scienceScanNumber',
        cardType,
        newCode,
      );

      if (await folderToRename.exists()) {
        await folderToRename.rename(newFolderPath);
        print('Folder renamed successfully to: $newFolderPath');
      } else {
        print('Folder not found to rename: $targetFolderPath');
        return false; // Folder not found
      }

      return true; // Success
    } catch (e) {
      print(
          'Error modifying text file, renaming folder, or renaming images: $e');
      return false; // Failure
    }
  }

  static String generateFormattedString({
    required List<CodeScannedModel> mobilis2000,
    required List<CodeScannedModel> mobilis1000,
    required List<CodeScannedModel> mobilis500,
    required List<CodeScannedModel> mobilis200OneLine,
    required List<CodeScannedModel> mobilis200TwoLine,
    required int scienceNumber,
  }) {
    // Get the current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('dd_MM_yyyy_HH_mm').format(now);

    // Create the string using lengths of the lists
    final result = StringBuffer();
    if (mobilis1000.isNotEmpty) {
      result.write('R1000_${mobilis1000.length}CARTES_');
    }
    if (mobilis2000.isNotEmpty) {
      result.write('R2000_${mobilis2000.length}CARTES_');
    }
    if (mobilis500.isNotEmpty) {
      result.write('R500_${mobilis500.length}CARTES_');
    }
    if (mobilis200OneLine.isNotEmpty) {
      result.write('R200-ONE-LINE_${mobilis200OneLine.length}CARTES_');
    }
    if (mobilis200TwoLine.isNotEmpty) {
      result.write('R200-TWO-LINE_${mobilis200TwoLine.length}CARTES_');
    }

    // Append the date, time, and science number
    result.write('${formattedDate}_SCIENCE_$scienceNumber');

    return result.toString();
  }

  static Future<List<String>?> createOrganizedTextFiles({
    required List<CodeScannedModel> mobilis2000,
    required List<CodeScannedModel> mobilis1000,
    required List<CodeScannedModel> mobilis500,
    required List<CodeScannedModel> mobilis200_one_line,
    required List<CodeScannedModel> mobilis200_two_line,
    required int scinceNumber,
  }) async {
    try {
      // Request storage permission if necessary
      bool permission = await storagePermission();
      if (permission) {
        // Get the external storage directory
        final directory = await getExternalStorageDirectory();
        final appDirectory =
            Directory(path.join(directory!.path, 'OrganizedCodes'));

        // Ensure the directory exists
        if (!await appDirectory.exists()) {
          await appDirectory.create(recursive: true);
        }

        // Get current date and time
        final now = DateTime.now();
        final date = '${now.day}/${now.month}/${now.year}';
        final time = '${now.hour}:${now.minute}';

        // Initialize a list to store file paths
        List<String> filePaths = [];

        // Helper function to create text files for each section
        Future<void> createFile(
            String title, List<CodeScannedModel> list) async {
          if (list.isNotEmpty) {
            // Generate file name
            String fileName =
                '${title.replaceAll(' ', '_')}_${now.millisecondsSinceEpoch}.txt';

            // Define the file path
            final textFilePath = path.join(appDirectory.path, fileName);

            // Prepare the content
            final buffer = StringBuffer();
            buffer.writeln(title);
            buffer.writeln(list.map((e) => e.codeCart).join('\n'));
            buffer.writeln('-------------------------');
            buffer.writeln('Details:');
            buffer.writeln('Date: $date $time');
            buffer.writeln('Type Cartes: $title');
            buffer.writeln('Nombre Cartes: ${list.length}');
            buffer.writeln('Science Number: $scinceNumber');

            // Write to the file
            final textFile = File(textFilePath);
            await textFile.writeAsString(buffer.toString());

            // Add the file path to the list
            filePaths.add(textFilePath);
            print('File created: $textFilePath');
          }
        }

        // Create individual files for each section
        await createFile('Mobilis 2000 Codes', mobilis2000);
        await createFile('Mobilis 1000 Codes', mobilis1000);
        await createFile('Mobilis 500 Codes', mobilis500);
        await createFile(
            'Mobilis 200 DA (One Line) Codes', mobilis200_one_line);
        await createFile(
            'Mobilis 200 DA (Two Line) Codes', mobilis200_two_line);

        return filePaths; // Return the list of file paths
      }
    } catch (e) {
      print('Error creating text files: $e');
      return null; // Return null in case of an error
    }
    return null;
  }

  // static Future<String?> createOrganizedTextFile({
  //   required List<CodeScannedModel> mobilis2000,
  //   required List<CodeScannedModel> mobilis1000,
  //   required List<CodeScannedModel> mobilis500,
  //   required List<CodeScannedModel> mobilis200_one_line,
  //   required List<CodeScannedModel> mobilis200_two_line,
  //   required int scinceNumber,
  // }) async {
  //   try {
  //     // Request storage permission if necessary
  //     bool permission = await storagePermission();
  //     if (permission) {
  //       // File name
  //       String fileName = generateFormattedString(
  //         mobilis1000: mobilis1000,
  //         mobilis2000: mobilis2000,
  //         mobilis200OneLine: mobilis200_one_line,
  //         mobilis200TwoLine: mobilis200_two_line,
  //         mobilis500: mobilis500,
  //         scienceNumber: scinceNumber,
  //       );

  //       // Get the external storage directory
  //       final directory = await getExternalStorageDirectory();
  //       final appDirectory =
  //           Directory(path.join(directory!.path, 'OrganizedCodes'));

  //       // Ensure the base directory exists
  //       if (!await appDirectory.exists()) {
  //         await appDirectory.create(recursive: true);
  //       }

  //       // Get current date and format it as a folder name
  //       final now = DateTime.now();
  //       final dateFolderName = '${now.day}-${now.month}-${now.year}';
  //       final dateFolderPath = path.join(appDirectory.path, dateFolderName);
  //       final dateFolder = Directory(dateFolderPath);

  //       // Ensure the date folder exists
  //       if (!await dateFolder.exists()) {
  //         await dateFolder.create(recursive: true);
  //       }

  //       // Define the text file path
  //       final textFilePath = path.join(dateFolder.path, '$fileName.txt');

  //       // Create content for the text file
  //       final buffer = StringBuffer();

  //       // Helper function to add data conditionally
  //       void addSection(String title, List<CodeScannedModel> list) {
  //         if (list.isNotEmpty) {
  //           buffer.writeln(title);
  //           buffer.writeln(list.map((e) => e.codeCart).join('\n'));
  //           buffer.writeln('-------------------------');
  //         }
  //       }

  //       // Add sections
  //       addSection('Mobilis 2000 Codes:', mobilis2000);
  //       addSection('Mobilis 1000 Codes:', mobilis1000);
  //       addSection('Mobilis 500 Codes:', mobilis500);
  //       addSection('Mobilis 200 DA (One Line) Codes:', mobilis200_one_line);
  //       addSection('Mobilis 200 DA (Two Line) Codes:', mobilis200_two_line);

  //       // Add summary details at the end
  //       final date = '${now.day}/${now.month}/${now.year}';
  //       final time = '${now.hour}:${now.minute}';
  //       final typeCartes = [
  //         if (mobilis2000.isNotEmpty) 'Mobilis 2000',
  //         if (mobilis1000.isNotEmpty) 'Mobilis 1000',
  //         if (mobilis500.isNotEmpty) 'Mobilis 500',
  //         if (mobilis200_one_line.isNotEmpty) 'Mobilis 200 DA (One Line)',
  //         if (mobilis200_two_line.isNotEmpty) 'Mobilis 200 DA (Two Line)',
  //       ].join('-');

  //       final totalCartes = [
  //         mobilis2000.length,
  //         mobilis1000.length,
  //         mobilis500.length,
  //         mobilis200_one_line.length,
  //         mobilis200_two_line.length,
  //       ].reduce((a, b) => a + b);

  //       buffer.writeln('Details:');
  //       buffer.writeln('Date: $date $time');
  //       buffer.writeln('Type Cartes: $typeCartes');
  //       buffer.writeln('Nombre Cartes: $totalCartes');
  //       buffer.writeln('Science Number: $scinceNumber');

  //       // Write to the text file
  //       final textFile = File(textFilePath);
  //       await textFile.writeAsString(buffer.toString());

  //       print('Text file created at: $textFilePath');
  //       return textFilePath; // Return the file path
  //     }
  //   } catch (e) {
  //     print('Error creating text file: $e');
  //     return null; // Return null in case of an error
  //   }
  //   return null;
  // }

  static Future<String?> createOrganizedTextFile(
      {required List<CodeScannedModel> mobilis2000,
      required List<CodeScannedModel> mobilis1000,
      required List<CodeScannedModel> mobilis500,
      required List<CodeScannedModel> mobilis200_one_line,
      required List<CodeScannedModel> mobilis200_two_line,
      required int scinceNumber,
      bool? saveInDownload}) async {
    try {
      // Request storage permission if necessary
      bool permission = await storagePermission();
      if (permission) {
        // File name
        String fileName = generateFormattedString(
          mobilis1000: mobilis1000,
          mobilis2000: mobilis2000,
          mobilis200OneLine: mobilis200_one_line,
          mobilis200TwoLine: mobilis200_two_line,
          mobilis500: mobilis500,
          scienceNumber: scinceNumber,
        );

        // Get the external storage directory
        final directory = await getExternalStorageDirectory();
        final appDirectory =
            Directory(path.join(directory!.path, 'OrganizedCodes'));

        // Ensure the directory exists
        if (!await appDirectory.exists()) {
          await appDirectory.create(recursive: true);
        }

        // Define the text file path
        final textFilePath = path.join(appDirectory.path, '$fileName.txt');

        // Create content for the text file
        final buffer = StringBuffer();

        // Helper function to add data conditionally
        void addSection(String title, List<CodeScannedModel> list) {
          if (list.isNotEmpty) {
            buffer.writeln(title);
            buffer.writeln(list.map((e) => e.codeCart).join('\n'));
            buffer.writeln('-------------------------');
          }
        }

        // Add sections
        addSection('Mobilis 2000 Codes:', mobilis2000);
        addSection('Mobilis 1000 Codes:', mobilis1000);
        addSection('Mobilis 500 Codes:', mobilis500);
        addSection('Mobilis 200 DA (One Line) Codes:', mobilis200_one_line);
        addSection('Mobilis 200 DA (Two Line) Codes:', mobilis200_two_line);

        // Add summary details at the end
        final now = DateTime.now();
        final date = '${now.day}/${now.month}/${now.year}';
        final time = '${now.hour}:${now.minute}';
        final typeCartes = [
          if (mobilis2000.isNotEmpty) 'Mobilis 2000',
          if (mobilis1000.isNotEmpty) 'Mobilis 1000',
          if (mobilis500.isNotEmpty) 'Mobilis 500',
          if (mobilis200_one_line.isNotEmpty) 'Mobilis 200 DA (One Line)',
          if (mobilis200_two_line.isNotEmpty) 'Mobilis 200 DA (Two Line)',
        ].join('-');

        final totalCartes = [
          mobilis2000.length,
          mobilis1000.length,
          mobilis500.length,
          mobilis200_one_line.length,
          mobilis200_two_line.length,
        ].reduce((a, b) => a + b);

        buffer.writeln('Details:');
        buffer.writeln('Date: $date $time');
        buffer.writeln('Type Cartes: $typeCartes');
        buffer.writeln('Nombre Cartes: $totalCartes');
        buffer.writeln('Science Number: $scinceNumber');

        // Write to the text file
        final textFile = File(textFilePath);
        await textFile.writeAsString(buffer.toString());

        print('Text file created at: $textFilePath');
        if (saveInDownload ?? false) {
          // Save the same file content to the Downloads folder
          final downloadsFilePath =
              await saveTextToDownloads(buffer.toString(), fileName);
          if (downloadsFilePath != null) {
            print(
                'File successfully saved in Downloads folder: $downloadsFilePath');
            return downloadsFilePath; // Return Downloads folder file path
          } else {
            throw Exception("Failed to save file in Downloads folder");
          }
        }

        return textFilePath; // Return the file path
      }
    } catch (e) {
      print('Error creating text file: $e');
      return null; // Return null in case of an error
    }
    return null;
  }

  static Future<String?> saveTextToDownloads(
      String content, String fileName) async {
    try {
      // Request storage permission
      if (!(await Permission.storage.request().isGranted)) {
        throw Exception("Storage permission not granted");
      }

      // Get the path to the public Downloads directory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        throw Exception("Downloads directory not found");
      }

      // Define the full path for the file
      final filePath = path.join(downloadsDir.path, "$fileName.txt");

      // Convert the content into bytes
      Uint8List fileBytes = Uint8List.fromList(content.codeUnits);

      // Write the content to the file
      final file = File(filePath);
      await file.writeAsBytes(fileBytes, flush: true);

      print("File successfully saved in Downloads: $filePath");
      return filePath;
    } catch (e) {
      print("Error saving file to Downloads: $e");
      return null;
    }
  }

  // static Future<String?> createOrganizedTextFile({
  //   required List<CodeScannedModel> mobilis2000,
  //   required List<CodeScannedModel> mobilis1000,
  //   required List<CodeScannedModel> mobilis500,
  //   required List<CodeScannedModel> mobilis200_one_line,
  //   required List<CodeScannedModel> mobilis200_two_line,
  //   required int scinceNumber,
  // }) async {
  //   try {
  //     // Request storage permission if necessary
  //     bool permission = await storagePermission();
  //     if (permission) {
  //       // File name
  //       String fileName = generateFormattedString(
  //         mobilis1000: mobilis1000,
  //         mobilis2000: mobilis2000,
  //         mobilis200OneLine: mobilis200_one_line,
  //         mobilis200TwoLine: mobilis200_two_line,
  //         mobilis500: mobilis500,
  //         scienceNumber: scinceNumber,
  //       );

  //       // Get the external storage directory
  //       final directory = await getExternalStorageDirectory();
  //       final appDirectory =
  //           Directory(path.join(directory!.path, 'OrganizedCodes'));

  //       // Ensure the directory exists
  //       if (!await appDirectory.exists()) {
  //         await appDirectory.create(recursive: true);
  //       }

  //       // Define the text file path
  //       final textFilePath = path.join(appDirectory.path, '$fileName.txt');

  //       // Create content for the text file
  //       final buffer = StringBuffer();

  //       // Helper function to add data conditionally
  //       void addSection(String title, List<CodeScannedModel> list) {
  //         if (list.isNotEmpty) {
  //           buffer.writeln(title);
  //           buffer.writeln(list.map((e) => e.codeCart).join('\n'));
  //           buffer.writeln('-------------------------');
  //         }
  //       }

  //       // Add sections
  //       addSection('Mobilis 2000 Codes:', mobilis2000);
  //       addSection('Mobilis 1000 Codes:', mobilis1000);
  //       addSection('Mobilis 500 Codes:', mobilis500);
  //       addSection('Mobilis 200 DA (One Line) Codes:', mobilis200_one_line);
  //       addSection('Mobilis 200 DA (Two Line) Codes:', mobilis200_two_line);

  //       // Write to the text file
  //       final textFile = File(textFilePath);
  //       await textFile.writeAsString(buffer.toString());

  //       print('Text file created at: $textFilePath');
  //       return textFilePath; // Return the file path
  //     }
  //   } catch (e) {
  //     print('Error creating text file: $e');
  //     return null; // Return null in case of an error
  //   }
  //   return null;
  // }

  // static Future<String?> createOrganizedTextFile(
  //     {required List<CodeScannedModel> mobilis2000,
  //     required List<CodeScannedModel> mobilis1000,
  //     required List<CodeScannedModel> mobilis500,
  //     required List<CodeScannedModel> mobilis200_one_line,
  //     required List<CodeScannedModel> mobilis200_two_line,
  //     required int scinceNumber}) async {
  //   try {
  //     // Request storage permission if necessary
  //     bool permission = await storagePermission();
  //     if (permission) {
  //       // file name
  //       String fileName = generateFormattedString(
  //           mobilis1000: mobilis1000,
  //           mobilis2000: mobilis2000,
  //           mobilis200OneLine: mobilis200_one_line,
  //           mobilis200TwoLine: mobilis200_two_line,
  //           mobilis500: mobilis500,
  //           scienceNumber: scinceNumber);
  //       // Get the external storage directory
  //       final directory = await getExternalStorageDirectory();
  //       final appDirectory =
  //           Directory(path.join(directory!.path, 'OrganizedCodes'));

  //       // Ensure the directory exists
  //       if (!await appDirectory.exists()) {
  //         await appDirectory.create(recursive: true);
  //       }

  //       // Define the text file path
  //       final textFilePath = path.join(appDirectory.path, '$fileName.txt');

  //       // Create content for the text file
  //       final buffer = StringBuffer();
  //       buffer.writeln('Mobilis 2000 Codes:');
  //       buffer.writeln(
  //         mobilis2000.isNotEmpty
  //             ? mobilis2000.map((e) => e.codeCart).join('\n')
  //             : 'No codes available',
  //       );
  //       buffer.writeln('\nMobilis 1000 Codes:');
  //       buffer.writeln(
  //         mobilis1000.isNotEmpty
  //             ? mobilis1000.map((e) => e.codeCart).join('\n')
  //             : 'No codes available',
  //       );
  //       buffer.writeln('\nMobilis 500 Codes:');
  //       buffer.writeln(
  //         mobilis500.isNotEmpty
  //             ? mobilis500.map((e) => e.codeCart).join('\n')
  //             : 'No codes available',
  //       );
  //       buffer.writeln('\nMobilis 200 DA (One Line) Codes:');
  //       buffer.writeln(
  //         mobilis200_one_line.isNotEmpty
  //             ? mobilis200_one_line.map((e) => e.codeCart).join('\n')
  //             : 'No codes available',
  //       );
  //       buffer.writeln('\nMobilis 200 DA (Two Line) Codes:');
  //       buffer.writeln(
  //         mobilis200_two_line.isNotEmpty
  //             ? mobilis200_two_line.map((e) => e.codeCart).join('\n')
  //             : 'No codes available',
  //       );

  //       // Write to the text file
  //       final textFile = File(textFilePath);
  //       await textFile.writeAsString(buffer.toString());

  //       print('Text file created at: $textFilePath');
  //       return textFilePath; // Return the file path
  //     }
  //   } catch (e) {
  //     print('Error creating text file: $e');
  //     return null; // Return null in case of an error
  //   }
  //   return null;
  // }

  static Future<void> saveImageAndTextWithUniqueCodeLog(Uint8List imageBytes,
      String textContent, int carteType, bool createNewFolder) async {
    // List of carteType values to be used as subfolder names
    List<String> carteTypeString = [
      "MOBILIS_2000_DA",
      "MOBILIS_1000_DA",
      "MOBILIS_500_DA",
      "MOBILIS_200_DA_1_LINE",
      "MOBILIS_200_DA_2_LINE",
    ];

    try {
      // Request storage permission
      bool permission = await storagePermission();
      if (permission) {
        // Get the external storage directory (Pictures folder) for Android
        final directory = await getExternalStorageDirectory();
        final appDirectory =
            Directory(path.join(directory!.path, 'Pictures', 'MyApp'));

        // Ensure the main directory exists
        if (!await appDirectory.exists()) {
          await appDirectory.create(recursive: true);
        }

        // Get the current date and format it
        final currentDate = DateTime.now();
        final formattedDate =
            '${currentDate.day}-${currentDate.month}-${currentDate.year}';

        // Create a folder for the current date inside 'MyApp'
        final dateDirectory =
            Directory(path.join(appDirectory.path, formattedDate));
        if (!await dateDirectory.exists()) {
          await dateDirectory.create();
        }

        // Get the folder for the selected carteType based on the index
        String carteTypeFolder = carteTypeString[carteType];

        // Determine the folder (create new or use the last existing)
        String folderName;
        Directory targetFolder;
        if (createNewFolder) {
          // Find the next available 'science_scan_x' folder
          int folderIndex = 1;
          do {
            folderName = "science_scan_$folderIndex";
            targetFolder = Directory(path.join(dateDirectory.path, folderName));
            folderIndex++;
          } while (await targetFolder.exists());
          await targetFolder.create();
        } else {
          // Find the last existing 'science_scan_x' folder
          final existingFolders = dateDirectory
              .listSync()
              .whereType<Directory>()
              .where((dir) => RegExp(r'science_scan_\d+$')
                  .hasMatch(path.basename(dir.path)))
              .toList()
            ..sort((a, b) =>
                path.basename(a.path).compareTo(path.basename(b.path)));

          if (existingFolders.isNotEmpty) {
            targetFolder = existingFolders.last;
          } else {
            // If no existing folder, default to 'science_scan_1'
            folderName = "science_scan_1";
            targetFolder = Directory(path.join(dateDirectory.path, folderName));
            await targetFolder.create();
          }
        }

        // Inside the target folder, create the carteType folder
        final uniqueCarteTypeDirectory =
            Directory(path.join(targetFolder.path, carteTypeFolder));
        if (!await uniqueCarteTypeDirectory.exists()) {
          await uniqueCarteTypeDirectory.create();
        }

        // Create the folder named with the textContent
        final sanitizedTextContent =
            textContent.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
        final textContentDirectory = Directory(
            path.join(uniqueCarteTypeDirectory.path, sanitizedTextContent));

        // Ensure the textContent folder exists
        if (!await textContentDirectory.exists()) {
          await textContentDirectory.create();
        }

        // Define the path for saving the image and text file
        final imagePath = path.join(textContentDirectory.path,
            'saved_image_${DateTime.now().millisecondsSinceEpoch}_code_${textContent}.png');
        print("iiiii ${imagePath}");
        final textFilePath =
            path.join(textContentDirectory.path, 'content.txt');

        // Save the image
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);
        print('Image saved at: $imagePath');

        // Save the text content
        final textFile = File(textFilePath);
        await textFile.writeAsString(textContent);
        print('Text file saved at: $textFilePath');
      }
    } catch (e) {
      print('Error saving files: $e');
    }
  }

  static Future<int> getLastScienceScanNumberAutomatically() async {
    try {
      // Request storage permission
      bool permission = await storagePermission();

      if (permission) {
        // Get the external storage directory (Pictures folder) for Android
        final directory = await getExternalStorageDirectory();
        final appDirectory =
            Directory(path.join(directory!.path, 'Pictures', 'MyApp'));

        // If the main app directory doesn't exist, return 1
        if (!await appDirectory.exists()) {
          return 1;
        }

        // Get today's date in DD-MM-YYYY format
        final today = DateTime.now();
        final todayFolderName =
            '${today.day.toString()}-${today.month.toString()}-${today.year}';
        final todayDirectory =
            Directory(path.join(appDirectory.path, todayFolderName));
        print(todayFolderName);

        // If today's directory doesn't exist, return 1
        if (!await todayDirectory.exists()) {
          return 1;
        }

        // Find all 'science_scan_x' folders in today's date directory
        final scienceScanFolders = todayDirectory
            .listSync()
            .whereType<Directory>()
            .where((dir) =>
                RegExp(r'science_scan_\d+$').hasMatch(path.basename(dir.path)))
            .toList();

        if (scienceScanFolders.isEmpty) {
          return 1; // No science_scan folders found for today
        }

        // Extract numbers and find the highest one
        final numbers = scienceScanFolders.map((dir) {
          final match = RegExp(r'science_scan_(\d+)$')
              .firstMatch(path.basename(dir.path));
          return match != null ? int.parse(match.group(1)!) : 1;
        }).toList();

        return numbers.isNotEmpty ? numbers.reduce((a, b) => a > b ? a : b) : 1;
      } else {
        return 1;
      }
    } catch (e) {
      print('Error getting last science_scan number: $e');
      return 1;
    }
  }

  // static Future<int> getLastScienceScanNumberAutomatically() async {
  //   try {
  //     // Request storage permission
  //     await storagePermission();

  //     // Get the external storage directory (Pictures folder) for Android
  //     final directory = await getExternalStorageDirectory();
  //     final appDirectory =
  //         Directory(path.join(directory!.path, 'Pictures', 'MyApp'));

  //     // If the main app directory doesn't exist, return 0
  //     if (!await appDirectory.exists()) {
  //       return 0;
  //     }

  //     // Find all date directories (format: DD-MM-YYYY)
  //     final dateDirectories = appDirectory
  //         .listSync()
  //         .whereType<Directory>()
  //         .where((dir) =>
  //             RegExp(r'^\d{2}-\d{2}-\d{4}$').hasMatch(path.basename(dir.path)))
  //         .toList();

  //     if (dateDirectories.isEmpty) {
  //       return 0; // No date directories found
  //     }

  //     // Sort date directories by their parsed date in descending order
  //     dateDirectories.sort((a, b) {
  //       final dateA =
  //           DateTime.parse(path.basename(a.path).split('-').reversed.join('-'));
  //       final dateB =
  //           DateTime.parse(path.basename(b.path).split('-').reversed.join('-'));
  //       return dateB.compareTo(dateA); // Latest date first
  //     });

  //     // Use the most recent date directory
  //     final mostRecentDateDirectory = dateDirectories.first;

  //     // Find all 'science_scan_x' folders in the most recent date directory
  //     final scienceScanFolders = mostRecentDateDirectory
  //         .listSync()
  //         .whereType<Directory>()
  //         .where((dir) =>
  //             RegExp(r'science_scan_\d+$').hasMatch(path.basename(dir.path)))
  //         .toList();

  //     if (scienceScanFolders.isEmpty) {
  //       return 0; // No science_scan folders found
  //     }

  //     // Extract numbers and find the highest one
  //     final numbers = scienceScanFolders.map((dir) {
  //       final match =
  //           RegExp(r'science_scan_(\d+)$').firstMatch(path.basename(dir.path));
  //       return match != null ? int.parse(match.group(1)!) : 0;
  //     }).toList();

  //     return numbers.isNotEmpty ? numbers.reduce((a, b) => a > b ? a : b) : 0;
  //   } catch (e) {
  //     print('Error getting last science_scan number: $e');
  //     return 0;
  //   }
  // }

  static Future<void> saveImageAndTextWithUniqueCodeLogWithoutScienceScan(
      Uint8List imageBytes, String textContent, int carteType) async {
    // List of carteType values to be used as subfolder names
    List<String> carteTypeString = [
      "MOBILIS_2000_DA",
      "MOBILIS_1000_DA",
      "MOBILIS_500_DA",
      "MOBILIS_200_DA_1_LINE",
      "MOBILIS_200_DA_2_LINE",
    ];

    try {
      // Request storage permission (you can customize this function)
      bool permission = await storagePermission();
      if (permission) {
        // Get the external storage directory (Pictures folder) for Android
        final directory = await getExternalStorageDirectory();
        final appDirectory =
            Directory(path.join(directory!.path, 'Pictures', 'MyApp'));

        // Ensure the main directory exists
        if (!await appDirectory.exists()) {
          await appDirectory.create(recursive: true);
        }

        // Get the current date and format it (e.g., 20-11-2024)
        final currentDate = DateTime.now();
        final formattedDate =
            '${currentDate.day}-${currentDate.month}-${currentDate.year}';

        // Create a folder for the current date inside 'MyApp'
        final dateDirectory =
            Directory(path.join(appDirectory.path, formattedDate));
        if (!await dateDirectory.exists()) {
          await dateDirectory.create();
        }

        // Get the folder for the selected carteType based on the index
        String carteTypeFolder = carteTypeString[carteType];
        final carteTypeDirectory =
            Directory(path.join(dateDirectory.path, carteTypeFolder));

        // Ensure the carteType folder exists
        if (!await carteTypeDirectory.exists()) {
          await carteTypeDirectory.create();
        }

        // Create the folder named with the textContent (sanitize the name)
        final sanitizedTextContent =
            textContent.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
        final textContentDirectory =
            Directory(path.join(carteTypeDirectory.path, sanitizedTextContent));

        // Ensure the textContent folder exists
        if (!await textContentDirectory.exists()) {
          await textContentDirectory.create();
        }

        // Define the path for saving the image and text file
        final imagePath = path.join(textContentDirectory.path,
            'saved_image_${DateTime.now().millisecondsSinceEpoch}_code_${textContent}.png');
        print("iiiii ${imagePath}");
        final textFilePath =
            path.join(textContentDirectory.path, 'content.txt');

        // Save the image
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);
        print('Image saved at: $imagePath');

        // Save the text content
        final textFile = File(textFilePath);
        await textFile.writeAsString(textContent);
        print('Text file saved at: $textFilePath');
      }
    } catch (e) {
      print('Error saving files: $e');
    }
  }

  // Future<List<FileSystemEntity>> getImagesFromFolder({
  //   required String
  //       cardNumber, // Card number to look for inside the final folder
  // }) async {
  //   // Request permission (for Android)
  //   PermissionStatus status = await Permission.storage.request();
  //   if (!status.isGranted) {
  //     print("Permission denied");
  //     return [];
  //   }

  //   // Get the path to the external directory (e.g., storage/emulated/0)
  //   final directory = await getExternalStorageDirectory();
  //   if (directory == null) {
  //     print("Directory not found");
  //     return [];
  //   }

  //   // Build the base folder path
  //   final baseFolderPath = '${directory.path}/Pictures/MyApp';

  //   final baseFolder = Directory(baseFolderPath);

  //   // Check if the base folder exists
  //   if (!await baseFolder.exists()) {
  //     print("Folder does not exist");
  //     return [];
  //   }

  //   // List to store found image files
  //   List<FileSystemEntity> imageFiles = [];

  //   // Recursively search through all subdirectories inside 'MyApp'
  //   await for (var entity
  //       in baseFolder.list(recursive: true, followLinks: false)) {
  //     final fileName = entity.path.toLowerCase();

  //     // Check if the file is an image and if it's inside the desired card number folder
  //     if (entity is File &&
  //         fileName.contains(cardNumber) &&
  //         (fileName.endsWith('.jpg') ||
  //             fileName.endsWith('.jpeg') ||
  //             fileName.endsWith('.png'))) {
  //       imageFiles.add(entity);
  //     }
  //   }

  //   return imageFiles;
  // }

  Future<bool> storagePermissionGranted() async {
    final DeviceInfoPlugin info =
        DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
    final AndroidDeviceInfo androidInfo = await info.androidInfo;
    debugPrint('releaseVersion : ${androidInfo.version.release}');
    final double androidVersion = double.parse(androidInfo.version.release);
    bool havePermission = false;

    // Here you can use android api level
    // like android api level 33 = android 13
    // This way you can also find out how to request storage permission

    if (androidVersion >= 13) {
      final request = await [
        Permission.videos,
        Permission.photos,
        //..... as needed
      ].request(); //import 'package:permission_handler/permission_handler.dart';

      havePermission =
          request.values.every((status) => status == PermissionStatus.granted);
    } else {
      final status = await Permission.storage.request();
      havePermission = status.isGranted;
    }

    if (!havePermission) {
      // if no permission then open app-setting
      await openAppSettings();
    }

    return havePermission;
  }

  Future<List<FileSystemEntity>> getImagesFromFolder({
    required String
        cardNumber, // Card number to look for inside the final folder
  }) async {
    // Request permission only once, or check if already granted
    var permission = await storagePermissionGranted();

    if (permission) {
      // Get the path to the external directory (e.g., storage/emulated/0)
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        print("Directory not found");
        return [];
      }

      // Build the base folder path
      final baseFolderPath = '${directory.path}/Pictures/MyApp';
      final baseFolder = Directory(baseFolderPath);

      // Check if the base folder exists
      if (!await baseFolder.exists()) {
        print("Folder does not exist");
        return [];
      }

      // List to store found image files
      List<FileSystemEntity> imageFiles = [];

      // Recursively search through all subdirectories inside 'MyApp'
      await for (var entity
          in baseFolder.list(recursive: true, followLinks: false)) {
        final fileName = entity.path.toLowerCase();

        // Check if the file is an image and matches the desired card number
        if (entity is File &&
            fileName.contains(cardNumber) &&
            (fileName.endsWith('.jpg') ||
                fileName.endsWith('.jpeg') ||
                fileName.endsWith('.png'))) {
          imageFiles.add(entity);
        }
      }

      return imageFiles;
    } else {
      return [];
    }
  }

  // Future<List<FileSystemEntity>> getImagesFromFolder({
  //   required String cardNumber,
  // }) async {
  //   // Android version check
  //   if (Platform.isAndroid) {
  //     int sdkInt = await getSdkInt();
  //     if (sdkInt >= 30) {
  //       // Use scoped storage
  //       return await getImagesFromScopedStorage(cardNumber: cardNumber);
  //     }
  //   }

  //   // Request storage permission for Android 9 and below
  //   PermissionStatus status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.storage.request();
  //     if (!status.isGranted) {
  //       print("Permission denied");
  //       return [];
  //     }
  //   }

  //   // Fallback for older Android versions
  //   final directory = await getExternalStorageDirectory();
  //   if (directory == null) {
  //     print("Directory not found");
  //     return [];
  //   }

  //   final baseFolderPath = '${directory.path}/Pictures/MyApp';
  //   final baseFolder = Directory(baseFolderPath);

  //   if (!await baseFolder.exists()) {
  //     print("Folder does not exist");
  //     return [];
  //   }

  //   List<FileSystemEntity> imageFiles = [];
  //   await for (var entity in baseFolder.list(recursive: true)) {
  //     final fileName = entity.path.toLowerCase();
  //     if (entity is File &&
  //         fileName.contains(cardNumber) &&
  //         (fileName.endsWith('.jpg') ||
  //             fileName.endsWith('.jpeg') ||
  //             fileName.endsWith('.png'))) {
  //       imageFiles.add(entity);
  //     }
  //   }
  //   return imageFiles;
  // }

// Scoped storage implementation for Android 11+
  Future<List<FileSystemEntity>> getImagesFromScopedStorage({
    required String cardNumber,
  }) async {
    // Use MediaStore or scoped directory logic
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Scoped Directory not found");
      return [];
    }

    final folderPath = '${directory.path}/Pictures/MyApp';
    final folder = Directory(folderPath);

    if (!await folder.exists()) {
      print("Scoped Folder does not exist");
      return [];
    }

    List<FileSystemEntity> imageFiles = [];
    await for (var entity in folder.list(recursive: true)) {
      final fileName = entity.path.toLowerCase();
      if (entity is File &&
          fileName.contains(cardNumber) &&
          (fileName.endsWith('.jpg') ||
              fileName.endsWith('.jpeg') ||
              fileName.endsWith('.png'))) {
        imageFiles.add(entity);
      }
    }
    return imageFiles;
  }

// Get Android SDK version
  Future<int> getSdkInt() async {
    const platform = MethodChannel('getSdkVersion');
    try {
      final sdkInt = await platform.invokeMethod<int>('getSdkInt');
      return sdkInt ?? 0;
    } on PlatformException catch (e) {
      print("Failed to get SDK version: '${e.message}'.");
      return 0;
    }
  }
}
