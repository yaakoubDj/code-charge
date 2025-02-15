import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ShareFileService {
  /// Shares a single file.
  ///
  /// [filePath]: The path to the file to be shared.
  /// [context]: Required to display error messages using SnackBar.
  static Future<void> shareFile(String filePath, BuildContext context) async {
    final file = File(filePath);

    if (await file.exists()) {
      try {
        await Share.shareXFiles([XFile(filePath)]);
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to share file: $e');
      }
    } else {
      _showErrorSnackBar(context, 'File not found at $filePath');
    }
  }

  /// Shares multiple files.
  ///
  /// [filePaths]: A list of file paths to share.
  /// [context]: Required to display error messages using SnackBar.
  static Future<void> shareFiles(
      List<String> filePaths, BuildContext context) async {
    final files = filePaths.map((path) => XFile(path)).toList();

    if (files.isNotEmpty) {
      try {
        await Share.shareXFiles(files);
      } catch (e) {
        _showErrorSnackBar(context, 'Failed to share files: $e');
      }
    } else {
      _showErrorSnackBar(context, 'No files to share');
    }
  }

  /// Shares plain text.
  ///
  /// [text]: The text to be shared.
  static Future<void> shareText(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      debugPrint('Failed to share text: $e');
    }
  }

  /// Shares a URL or link.
  ///
  /// [url]: The URL to be shared.
  static Future<void> shareLink(String url) async {
    try {
      await Share.share(url);
    } catch (e) {
      debugPrint('Failed to share link: $e');
    }
  }

  /// Displays an error message using SnackBar.
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
