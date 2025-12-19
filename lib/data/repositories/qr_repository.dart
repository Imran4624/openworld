// Dart imports:
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Package imports:
import 'package:path_provider/path_provider.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Project imports:
// import 'package:flutter_boilerplate/ui/app/platform_specific/file_downloader/downloader_factory.dart';

/// Repository for handling QR code operations
/// Supports cross-platform QR code generation and download functionality
class QRRepository {
  static final QRRepository _instance = QRRepository._internal();
  factory QRRepository() => _instance;
  QRRepository._internal();

  /// Downloads a QR code as an image file
  /// Supports multiple platforms: Web, iOS, Android, Desktop
  Future<void> downloadQRCode({
    required String url,
    required String title,
    int size = 512,
    BuildContext? context,
  }) async {
    try {
      // Validate inputs
      if (url.isEmpty) {
        throw Exception('URL cannot be empty');
      }
      if (title.isEmpty) {
        throw Exception('Title cannot be empty');
      }
      if (size <= 0) {
        throw Exception('Size must be greater than 0');
      }

      // Generate QR code as bytes using QrPainter
      final qrPainter = QrPainter(
        data: url,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.M,
      );

      final imageData = await qrPainter.toImageData(size.toDouble());
      
      if (imageData == null) {
        throw Exception('Failed to generate QR code image');
      }

      final bytes = imageData.buffer.asUint8List();
      
      // Generate filename
      final filename = _generateFilename(title);
      
      // Handle different platforms
      if (isWeb()) {
        // Web platform - use WebUtils
        WebUtils.downloadBinaryFile(filename, bytes);
              // Show success message for web
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('QR code download started'),
            backgroundColor: Colors.green,
          ),
        );
      }
      } else {
        // Native platforms - use file downloader
        if (context != null) {
          await _downloadOnNativePlatform(context, bytes, filename);
        } else {
          throw Exception('Context is required for native platform downloads');
        }
      }
    } catch (e) {
      // Log error for debugging
      debugPrint('Error downloading QR code: $e');
      rethrow;
    }
  }

  /// Generates a filename for the QR code image
  String _generateFilename(String title) {
    final sanitizedTitle = title
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[-\s]+'), '-')
        .toLowerCase()
        .trim();
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${sanitizedTitle}_qr_$timestamp.png';
  }

  /// Downloads QR code on native platforms (iOS, Android, Desktop)
  Future<void> _downloadOnNativePlatform(
    BuildContext context,
    Uint8List bytes,
    String filename,
  ) async {
    try {
      // For native platforms, we'll save to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$filename');
      
      // Write bytes to temporary file
      await tempFile.writeAsBytes(bytes);
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('QR code saved as $filename'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Open',
              onPressed: () {
                // On native platforms, we could open the file with the default app
                // For now, just show a message
                showToast('File saved to: ${tempFile.path}');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download QR code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
  }
} 