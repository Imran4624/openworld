import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'file_downloader.dart';

class WebFileDownloader implements FileDownloader {
  @override
  Future<void> downloadAttachment(BuildContext context, String url) async {
    html.window.open(url, '_blank');
  }
}

FileDownloader getFileDownloader() => WebFileDownloader();
