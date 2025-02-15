import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:scan_cart_mobilis/GBSystem_X_Developpement/widgets/APP_BAR/app_bar.dart';

class ServerLauncher extends StatefulWidget {
  @override
  _ServerLauncherState createState() => _ServerLauncherState();
}

class _ServerLauncherState extends State<ServerLauncher> {
  String? serverStatus;
  String? ipAddress, port;
  Process? serverProcess; // Variable to store the running server process

  // Function to retrieve the local IP address
  Future<void> _getIPAddress() async {
    try {
      // Run the ipconfig command
      final result = await Process.run('ipconfig', []);
      final output = result.stdout as String;
      // Extract IPv4 address using regex
      final match =
          RegExp(r"Adresse IPv4[.\s]*[:\s]*([\d.]+)").firstMatch(output);

      if (match != null) {
        setState(() {
          ipAddress = match.group(1);
        });
        print("ip $ipAddress");
      } else {
        setState(() {
          ipAddress = "IPv4 Address not found.";
        });
      }
    } catch (e) {
      setState(() {
        ipAddress = "Error retrieving IP address: $e";
      });
    }
  }

  // Function to kill any previous server running on port 3000
  Future<void> _killPreviousServer() async {
    try {
      final result =
          await Process.run('cmd', ['/c', 'netstat -ano | findstr :3000']);
      final output = result.stdout as String;

      final pidMatch = RegExp(r'(\d+)$').firstMatch(output);
      if (pidMatch != null) {
        final pid = pidMatch.group(1);
        await Process.run('cmd', ['/c', 'taskkill /PID $pid']);
        print('Killed previous server on port 3000');
      }
    } catch (e) {
      print("Error killing previous server: $e");
    }
  }

  Future<String> extractServerAssets() async {
    final tempDir = await getTemporaryDirectory();
    final serverDir = Directory('${tempDir.path}/my-server');

    // Delete and recreate the server directory
    if (serverDir.existsSync()) {
      serverDir.deleteSync(recursive: true);
    }
    serverDir.createSync(recursive: true);

    // Copy individual files
    final files = ['index.js', 'package.json', 'package-lock.json', 'node.exe'];
    for (final file in files) {
      final data = await rootBundle.load('assets/scripts/my-server/$file');
      final bytes = data.buffer.asUint8List();
      final filePath = '${serverDir.path}/$file';
      final tempFile = File(filePath);
      await tempFile.writeAsBytes(bytes);
    }

    // Extract `node_modules.zip`
    final zipData =
        await rootBundle.load('assets/scripts/my-server/node_modules.zip');
    final zipBytes = zipData.buffer.asUint8List();
    final archive = ZipDecoder().decodeBytes(zipBytes);

    for (final file in archive) {
      final filePath = '${serverDir.path}/${file.name}';
      if (file.isFile) {
        final output = File(filePath)..createSync(recursive: true);
        output.writeAsBytesSync(file.content as List<int>);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
    }

    return serverDir.path;
  }

  // Future<String> extractServerAssets() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final serverDir = Directory('${tempDir.path}/my-server');

  //   // Delete and recreate the server directory
  //   if (serverDir.existsSync()) {
  //     serverDir.deleteSync(recursive: true);
  //   }
  //   serverDir.createSync(recursive: true);

  //   // List of files to copy from assets
  //   final files = [
  //     'index.js',
  //     'package.json',
  //     'package-lock.json',
  //     'node.exe', // Include node.exe
  //   ];

  //   // Copy files from assets to the temporary directory
  //   for (final file in files) {
  //     final data = await rootBundle.load('assets/scripts/my-server/$file');
  //     final bytes = data.buffer.asUint8List();
  //     final filePath = '${serverDir.path}/$file';
  //     final tempFile = File(filePath);
  //     await tempFile.writeAsBytes(bytes);
  //   }

  //   // Handle `node_modules` directory from assets
  //   final nodeModulesSourceDir =
  //       Directory('assets/scripts/my-server/node_modules');
  //   final nodeModulesDestDir = Directory('${serverDir.path}/node_modules');

  //   if (nodeModulesSourceDir.existsSync()) {
  //     nodeModulesDestDir.createSync(recursive: true);

  //     for (final entity in nodeModulesSourceDir.listSync(recursive: true)) {
  //       final relativePath =
  //           entity.path.replaceFirst(nodeModulesSourceDir.path, '');
  //       final destPath = '${nodeModulesDestDir.path}/$relativePath';

  //       if (entity is File) {
  //         final destFile = File(destPath);
  //         destFile.createSync(recursive: true);
  //         destFile.writeAsBytesSync(entity.readAsBytesSync());
  //       } else if (entity is Directory) {
  //         Directory(destPath).createSync(recursive: true);
  //       }
  //     }
  //   }

  //   return serverDir.path; // Return the extracted server path
  // }

  Future<void> _startServer() async {
    try {
      setState(() {
        serverStatus = "Starting server...";
      });

      // Extract server assets
      final serverPath = await extractServerAssets();
      final nodePath = '$serverPath/node.exe';

      // Ensure `node_modules` is present
      final nodeModulesDir = Directory('$serverPath/node_modules');
      if (!nodeModulesDir.existsSync()) {
        setState(() {
          serverStatus = "Installing dependencies...";
        });

        final npmPath =
            '$serverPath/node_modules/npm/bin/npm-cli.js'; // npm CLI
        final result = await Process.run(
          nodePath,
          [npmPath, 'install'],
          workingDirectory: serverPath,
          runInShell: true,
        );

        // Log the output of the npm install process
        print('npm install stdout: ${result.stdout}');
        print('npm install stderr: ${result.stderr}');

        if (result.exitCode != 0) {
          setState(() {
            serverStatus = "Error installing dependencies: ${result.stderr}";
          });
          return;
        }
      }

      // Start the server
      serverProcess = await Process.start(
        nodePath,
        ['index.js'],
        workingDirectory: serverPath,
        mode: ProcessStartMode.normal,
      );

      // Capture stdout and stderr to listen for server start
      serverProcess!.stdout.transform(utf8.decoder).listen((data) {
        print('stdout: $data'); // Print to console for debugging

        if (data.contains('Server running at')) {
          // Update UI when the server is successfully running
          print('stdout: $data'); // Print to console for debugging
          // Look for the "Server running at" string and extract IP and port
          final match =
              RegExp(r"Server running at http://(localhost|[\d.]+):(\d+)")
                  .firstMatch(data);

          if (match != null) {
            setState(() {
              // ipAddress = match.group(1); // IP Address
              port = match.group(2); // Port
            });
          }

          setState(() {
            serverStatus = data.replaceAll("localhost", ipAddress!);
            // "Server started successfully at ${data.replaceAll("localhost", ipAddress!)}";
          });
        } else {
          setState(() {
            serverStatus = data;
          });
        }
      });

      serverProcess!.stderr.transform(utf8.decoder).listen((data) {
        print('stderr: $data'); // Print errors to console for debugging
      });

      // Wait for the process to exit and check the exit code
      final exitCode = await serverProcess!.exitCode;
      if (exitCode != 0) {
        // setState(() {
        //   serverStatus = "Error starting server: Exit code $exitCode";
        // });
      }
    } catch (e) {
      setState(() {
        serverStatus = "Error starting server: $e";
      });
    }
  }

  // Function to start the Node.js server FROM D
  Future<void> _startServerInDiskD() async {
    try {
      await _killPreviousServer(); // Kill any existing server on port 3000
      setState(() {
        serverStatus = "Starting server...";
      });

      final serverPath = r"C:\Users\hp\my-server";

      // Start the server process
      serverProcess = await Process.start(
        'cmd',
        ['/c', 'node index.js'],
        workingDirectory: serverPath,
        mode: ProcessStartMode.normal,
      );

      // Capture stdout and stderr to listen for server start
      serverProcess!.stdout.transform(utf8.decoder).listen((data) {
        print('stdout: $data'); // Print to console for debugging

        if (data.contains('Server running at')) {
          // Update UI when the server is successfully running
          print('stdout: $data'); // Print to console for debugging
          // Look for the "Server running at" string and extract IP and port
          final match =
              RegExp(r"Server running at http://(localhost|[\d.]+):(\d+)")
                  .firstMatch(data);

          if (match != null) {
            setState(() {
              // ipAddress = match.group(1); // IP Address
              port = match.group(2); // Port
            });
          }

          setState(() {
            serverStatus = data.replaceAll("localhost", ipAddress!);
            // "Server started successfully at ${data.replaceAll("localhost", ipAddress!)}";
          });
        } else {
          setState(() {
            serverStatus = data;
          });
        }
      });

      serverProcess!.stderr.transform(utf8.decoder).listen((data) {
        print('stderr: $data'); // Print errors to console for debugging
      });

      // Wait for the process to exit and check the exit code
      final exitCode = await serverProcess!.exitCode;
      if (exitCode != 0) {
        // setState(() {
        //   serverStatus = "Error starting server: Exit code $exitCode";
        // });
      }
    } catch (e) {
      setState(() {
        serverStatus = "Error starting server: $e";
      });
    }
  }

  Future<void> _stopServer() async {
    try {
      // Find the process using port 3000
      final result = await Process.run(
        'cmd',
        ['/c', 'netstat -ano | findstr :3000'],
        stdoutEncoding: utf8,
      );

      final output = result.stdout as String;

      // If the port is being used, it will return a PID
      if (output.isNotEmpty) {
        final pid =
            output.split(' ').last.trim(); // Extract the PID from the output
        print('Found process with PID: $pid');

        // Kill the process using the PID
        final killResult = await Process.run(
          'cmd',
          ['/c', 'taskkill /PID $pid /F'], // Forcefully kill the process
        );

        // Print the result of the kill command
        print(killResult.exitCode);

        if (killResult.exitCode == 0) {
          setState(() {
            serverStatus = "Server stopped successfully";
            port = null;
          });
          print("Server stopped successfully.");
        } else {
          print("Failed to stop server: ${killResult.stderr}");
        }
      } else {
        print("No process found using port 3000.");
      }
    } catch (e) {
      print("Error stopping server: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getIPAddress(); // Retrieve the IP address on app launch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: GBSystemCustomAppBarScanIP(
          showBackBtn: false,
          title: "Server Control",
          subtitle: "(Start-Stop-Scan Server)"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Server IP Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Server IP Address",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        ipAddress ?? "Loading...",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Visibility(
                        visible: port != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Server Port",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              port ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _startServer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(CupertinoIcons.play_fill,
                          color: Colors.white),
                      label: const Text(
                        "Start Server",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _stopServer,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(CupertinoIcons.stop_fill,
                          color: Colors.white),
                      label: const Text(
                        "Stop Server",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Server Status Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Server Status",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          serverStatus ?? "Server not launched",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ((serverStatus?.contains("Server running") ??
                                        false) ||
                                    (serverStatus?.contains(
                                            "File uploaded successfully") ??
                                        false))
                                ? Colors.green
                                : (serverStatus?.contains("Starting server") ??
                                        false)
                                    ? Colors.black54
                                    : Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Server Status Section
              Visibility(
                visible: ipAddress != null && port != null,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Data to Scan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            "Server running at http://$ipAddress:$port",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
