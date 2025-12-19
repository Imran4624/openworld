import 'package:flutter_boilerplate/data/models/notification_model.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class EmailValidator {
  static bool isValid(EmailMessage email) {
    final isValid = email.subject?.trim().isNotEmpty == true &&
        email.body?.trim().isNotEmpty == true &&
        email.to?.trim().isNotEmpty == true;
    if (!isValid) {
      logError('Email validation failed: subject, body, or to is empty');
    }
    return isValid;
  }
}
