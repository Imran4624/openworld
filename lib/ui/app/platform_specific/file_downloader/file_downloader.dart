import 'package:flutter/material.dart';

abstract class FileDownloader {
  Future<void> downloadAttachment(BuildContext context, String attachmentUrl);
}
