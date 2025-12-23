// Dart imports:

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_state.dart';

import 'package:flutter_boilerplate/utils/web_stub.dart'
    if (dart.library.html) 'package:flutter_boilerplate/utils/web.dart';

class UpdateDialog extends StatefulWidget {
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final appVersionEntity = state.appVersion;

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appVersionEntity!.releaseNotes,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () async {
            if (kIsWeb) {
              WebUtils.reloadBrowser();
            } else {
              if (appVersionEntity.updateUrl.isNotEmpty) {
                final Uri url = Uri.parse(appVersionEntity.updateUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              }
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
