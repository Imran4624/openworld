import 'dart:typed_data';
import 'package:flutter_boilerplate/.env.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_boilerplate/ui/app/shared.dart';

class AzureClient {
  AzureClient({
    required this.containerName,
  });

  final String containerName;

  static const String _baseUrl =
      Config.AZURE_CLIENT_BASE_URL;
  static const String _sasToken =
      Config.AZURE_CLIENT_SAS_TOKEN;

  Future<String> uploadFile(Uint8List fileData, String fileName,
      {String? subPath}) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String safeName = fileName.replaceAll(RegExp(r'[^\w\s\-\.]'), '_');
      final String fullPath = subPath != null
          ? '$subPath/${timestamp}_$safeName'
          : '${timestamp}_$safeName';
      final String blobName = '$containerName/$fullPath';
      final String url = '$_baseUrl/$blobName?$_sasToken';

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': 'application/octet-stream',
        },
        body: fileData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final String downloadUrl = '$_baseUrl/$blobName';
        logInfo('File uploaded to Azure successfully: $downloadUrl');
        return downloadUrl;
      } else {
        logError(
            ' Error uploading to Azure: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to upload file Try again later');
      }
    } catch (e) {
      logError(' Error uploading file to Azure: $e');
      throw Exception('Failed to upload file Try again later');
    }
  }

  Future<List<String>> uploadMultipleFiles(List<Map<String, dynamic>> filesData,
      {String? subPath}) async {
    try {
      final List<Future<String>> uploadFutures = filesData.map((fileData) {
        final bytes = fileData['bytes'] as Uint8List;
        final name = fileData['name'] as String? ?? 'file';
        return uploadFile(bytes, name, subPath: subPath);
      }).toList();

      final List<String> fileUrls = await Future.wait(uploadFutures);
      logInfo('All files uploaded successfully: ${fileUrls.length} files');
      return fileUrls;
    } catch (e) {
      logError(' Error azure uploading multiple files : $e');
      throw Exception(' Failed azure to upload multiple files: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final uri = Uri.parse(fileUrl);
      final blobName = uri.path.substring(1);
      final url = '$_baseUrl/$blobName?$_sasToken';

      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 202) {
        logInfo('File deleted successfully: $fileUrl');
      } else if (response.statusCode == 404) {
        logInfo('File not found: $fileUrl');
      } else {
        logError(
            ' Error deleting file: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to delete file: ${response.body}');
      }
    } catch (e) {
      logError(' Error deleting file from Azure: $e');
      rethrow;
    }
  }
}
