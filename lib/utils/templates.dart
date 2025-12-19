// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/data/web_client.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'dialogs.dart';

void loadEmailTemplate({
  required BuildContext context,
  required Function(String?, String?, String?, String?, String?) onComplete,
  String? template,
  String? subject,
  String? body,
}) {
  if (Config.DEMO_MODE) {
    onComplete(subject, body, '', '', '');
    return;
  }

  final webClient = WebClient();
  final state = StoreProvider.of<AppState>(context).state;
  final credentials = state.credentials;
  final url = '${credentials.url}/templates';

  /*
  final invoice = state.invoiceState.list.isEmpty
      ? InvoiceEntity(state: state)
      : state.invoiceState.map[state.invoiceState.list.first];
   */

  subject ??= '';
  body ??= '';

  if (template != null) {
    template = 'email_template_$template';
  }

  webClient
      .post(url, credentials.token,
          data: json.encode({
            'entity': '',
            'entity_id': '',
            'template': template,
            'subject': subject,
            'body': body,
          }))
      .then((dynamic response) {
    onComplete(
      response['subject'],
      response['body'],
      response['wrapper'].replaceFirst('\$body', response['body']),
      response['raw_subject'],
      response['raw_body'],
    );
  }).catchError((dynamic error) {
    showErrorDialog(message: '$error');
    onComplete(subject, body, body, subject, body);
  });
}
