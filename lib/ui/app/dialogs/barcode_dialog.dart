import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';

class BarcodeDialog extends StatelessWidget {
  final String title;
  final String url;
  final String subtitle;

  const BarcodeDialog({
    Key? key,
    required this.title,
    required this.url,
    this.subtitle =
        'Share your event and start crowdsourcing photos and videos',
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required String title,
    required String url,
    String subtitle =
        'Share your event and start crowdsourcing photos and videos',
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => BarcodeDialog(
        title: title,
        url: url,
        subtitle: subtitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    if (url.isEmpty) {
      showToast('Error: Invalid URL');
      return const Dialog();
    }

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            if (ProjectConfig.showBarcodeSubtitle) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: QrImageView(
                    data: url,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.M,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (ProjectConfig.downloadBarcodeEnabled())
              StoreConnector<AppState, VoidCallback>(
                converter: (store) => () {
                  store.dispatch(DownloadQRCode(
                    url: url,
                    title: title,
                  ));
                },
                builder: (context, downloadCallback) {
                  return ElevatedButton.icon(
                    onPressed: downloadCallback,
                    icon: const Icon(Icons.download, color: Colors.blue),
                    label: const Text(
                      'Download QR Code',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      url,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: url));
                      showToast(localization.copiedToClipboard
                          .replaceFirst(':value', 'Link'));
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Copy',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      minimumSize: const Size(60, 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
