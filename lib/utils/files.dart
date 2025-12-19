// Dart imports:
import 'dart:io';
import 'dart:io' as file;

// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:flutter_boilerplate/utils/platforms.dart';

// ignore: unused_import
import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<List<MultipartFile>?> pickFiles({
  String? fileIndex,
  FileType? fileType,
  List<String>? allowedExtensions,
  bool allowMultiple = true,
}) async {
  if (isWeb() || isDesktopOS()) {
    return _pickFiles(
      fileIndex: fileIndex,
      fileType: fileType,
      allowedExtensions: allowedExtensions,
      allowMultiple: allowMultiple,
    );
  } else {
    PermissionStatus? status;

    if (Platform.isIOS) {
      if (fileType == FileType.image) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    }

    if (status == PermissionStatus.granted) {
      return _pickFiles(
        fileIndex: fileIndex,
        fileType: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
      );
    } else {
      openAppSettings();
      return null;
    }
  }
}

Future<List<MultipartFile>?> _pickFiles({
  String? fileIndex,
  FileType? fileType,
  List<String>? allowedExtensions,
  required bool allowMultiple,
}) async {
  final result = await FilePicker.platform.pickFiles(
    type: fileType ?? FileType.custom,
    allowedExtensions:
        fileType == FileType.image ? [] : allowedExtensions ?? [],
    allowCompression: true,
    withData: true,
    allowMultiple: allowMultiple,
  );

  if (result != null && result.files.isNotEmpty) {
    final multipartFiles = <MultipartFile>[];
    for (var index = 0; index < result.files.length; index++) {
      final file = result.files[index];
      multipartFiles.add(MultipartFile.fromBytes(
          allowMultiple ? 'documents[$index]' : fileIndex!, file.bytes!,
          filename: file.name));
    }

    return multipartFiles;
  }

  return null;
}

void saveDownloadedFile(
  Uint8List data,
  String fileName, {
  String? prefix,
  String languageId = kLanguageEnglish,
}) async {
  if (prefix != null) {
    final localization = AppLocalization.of(navigatorKey.currentContext!)!;
    final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
    final localeCode = store.state.staticState.languageMap[languageId]!.locale;

    fileName = localization.lookup(prefix, overrideLocaleCode: localeCode) +
        '_' +
        fileName;
  }

  if (isWeb()) {
    WebUtils.downloadBinaryFile(fileName, data);
  } else {
    final directory = await getAppDownloadDirectory();
    if (directory != null) {
      String filePath = '$directory/${file.Platform.pathSeparator}$fileName';

      if (file.File(filePath).existsSync()) {
        final extension = fileName.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        filePath =
            filePath.replaceFirst('.$extension', '_$timestamp.$extension');
      }

      await File(filePath).writeAsBytes(data);

      if (isDesktopOS()) {
        showToast(AppLocalization.of(navigatorKey.currentContext!)!
            .fileSavedInPath
            .replaceFirst(':path', directory));
      } else {
        await Share.shareXFiles([XFile(filePath)]);
      }
    }
  }
}

Future<String?> getAppDownloadDirectory() async {
  if (isWeb()) {
    return null;
  }

  var path = '';

  final store = StoreProvider.of<AppState>(navigatorKey.currentContext!);
  final state = store.state;

  if (state.prefState.donwloadsFolder.isNotEmpty) {
    path = state.prefState.donwloadsFolder;
  } else {
    final directory = await (isDesktopOS()
        ? getDownloadsDirectory()
        : getApplicationDocumentsDirectory());

    if (directory == null) {
      return null;
    }

    path = directory.path;
  }

  if (!Directory(path).existsSync()) {
    showErrorDialog(
        message: AppLocalization.of(navigatorKey.currentContext!)!
            .downloadsFolderDoesNotExist
            .replaceFirst(':value', path));

    return null;
  }

  return path;
}

Future<void> shareContent(
  BuildContext context,
  String content, {
  String? subject,
  String? filename,
  Uint8List? bytes,
}) async {
  if (filename != null && (bytes != null || content.isNotEmpty)) {
    if (isWeb()) {
      if (bytes != null) {
        WebUtils.downloadBinaryFile(filename, bytes);
      } else {
        WebUtils.downloadTextFile(filename, content);
      }
    } else {
      if (bytes != null) {
        saveDownloadedFile(bytes, filename);
      } else {
        final contentBytes = Uint8List.fromList(content.codeUnits);
        saveDownloadedFile(contentBytes, filename);
      }
    }
  } else {
    if (isWeb()) {
      await Clipboard.setData(ClipboardData(text: content));
      showToast('Link copied to clipboard');
    } else {
      await Share.share(content, subject: subject);
    }
  }
}
