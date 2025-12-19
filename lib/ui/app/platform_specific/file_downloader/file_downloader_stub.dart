import 'package:flutter/material.dart';
import 'file_downloader.dart';

class StubFileDownloader implements FileDownloader {
  @override
  Future<void> downloadAttachment(BuildContext context, String attachmentUrl) {
    throw UnimplementedError('File downloading not supported on this platform');
  }
}

FileDownloader getFileDownloader() => StubFileDownloader();
