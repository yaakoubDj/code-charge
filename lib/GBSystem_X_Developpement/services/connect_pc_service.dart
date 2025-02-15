import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

class ConnectPcService {
  HttpServer? _server;
  String? serverAddress;

  /// Starts an HTTP server to share the specified file.
  /// Returns the server address if successful.
  Future<String?> startServer(String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    // Create a handler to serve the file's parent directory.
    final handler = createStaticHandler(
      file.parent.path,
      defaultDocument: file.uri.pathSegments.last,
    );

    // Start the server on an available port.
    _server = await serve(handler, InternetAddress.anyIPv4, 8080);

    serverAddress =
        'http://${_server!.address.host}:${_server!.port}/${file.uri.pathSegments.last}';

    return serverAddress;
  }

  /// Stops the running HTTP server.
  Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      serverAddress = null;
    }
  }

  /// Checks if the device is connected to Wi-Fi.
  Future<bool> isConnectedToWiFi() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  /// Returns whether the server is currently running.
  bool isServerRunning() {
    return _server != null;
  }
}
