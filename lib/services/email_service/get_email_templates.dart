import 'package:flutter/services.dart';

Future<String> getInviteEmailTemplate({
  required String attendeeName,
  required String hostName,
  required String eventName,
  required String joinEventLink,
}) async {
  String htmlTemplate = await rootBundle.loadString('assets/loopjam/email_templates/invite_email_template.html');
  htmlTemplate = htmlTemplate
      .replaceAll('{{attendeeName}}', attendeeName)
      .replaceAll('{{hostName}}', hostName)
      .replaceAll('{{eventName}}', eventName)
      .replaceAll('{{joinEventLink}}', joinEventLink);
  return htmlTemplate;
}

Future<String> getProfileApprovedEmailTemplate() async {
  String htmlTemplate = await rootBundle.loadString('assets/cac/email_templates/profile_approved_template.html');
  return htmlTemplate;
}
