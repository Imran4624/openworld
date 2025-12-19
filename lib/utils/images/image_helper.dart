import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:convert';

class ImageHelper {
  static const int MAX_IMAGE_SIZE_KB = kMaxImageSizeInKb;

  static Future<String> getProcessedImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final imageBytes = response.bodyBytes;

      final sizeInKB = imageBytes.length / 1024;
      logInfo('Original image size: $sizeInKB KB');

      if (sizeInKB <= MAX_IMAGE_SIZE_KB) {
        logInfo('Image size is under 12KB, using original');
        return imageUrl;
      }

      logInfo('Image size is over 12KB, resizing...');

      final img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        logError(' Could not decode image');
        return imageUrl;
      }

      final resizedImage = img.copyResize(
        originalImage,
        width: 150,
        height: (150 * originalImage.height / originalImage.width).round(),
      );

      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);

      final newSizeInKB = compressedBytes.length / 1024;
      logInfo('Size after compression: $newSizeInKB KB');

      final base64String = base64Encode(compressedBytes);
      return 'data:image/jpeg;base64,$base64String';
    } catch (e) {
      logError(' Error processing image: $e');
      return imageUrl;
    }
  }
}
