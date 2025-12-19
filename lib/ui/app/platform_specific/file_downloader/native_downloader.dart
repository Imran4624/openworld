// lib/ui/app/platform_specific/file_downloader/native_downloader.dart
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'file_downloader.dart';

class NativeFileDownloader implements FileDownloader {
  @override
  Future<void> downloadAttachment(BuildContext context, String attachmentUrl) {
    // Native download logic here
    printL("Downloading attachment on native platform: $attachmentUrl");
    return Future.value();
  }
}

FileDownloader getFileDownloader() => NativeFileDownloader();

// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_boilerplate/ui/app/platform_specific/file_downloader/file_downloader.dart';
// import 'package:http/http.dart' as http;

// class NativeFileDownloader implements FileDownloader {
//   @override
//   Future<void> downloadAttachment(BuildContext context, String url) async {
//     try {
//       final fileName = url.split('/').last;
//       final result = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save file as',
//         fileName: fileName,
//       );

//       if (result != null) {
//         final response = await http.get(Uri.parse(url));
//         final file = File(result);
//         await file.writeAsBytes(response.bodyBytes);

//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('File downloaded successfully')),
//           );
//         }
//       }
//     } catch (e) {
//       printL('Error downloading file: $e');
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error downloading file')),
//         );
//       }
//     }
//   }
// }
