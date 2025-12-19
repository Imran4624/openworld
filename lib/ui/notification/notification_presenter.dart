import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class NotificationPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      NotificationFields.title,

      NotificationFields.body,

      NotificationFields.type,

      NotificationFields.channel,

      NotificationFields.actionUrl,

      NotificationFields.payload,

      NotificationFields.priority,
    ];
  }

  static List<String> getAllTableFields(UserCompanyEntity userCompany) {
    return [
      ...getDefaultTableFields(userCompany),
      ...EntityPresenter.getBaseFields(),
    ];
  }

  @override
  Widget getField({String? field, required BuildContext context}) {
    // final state = StoreProvider.of<AppState>(context).state;
    final notification = entity as NotificationEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case NotificationFields.title:
        return Text(notification.title);
      case NotificationFields.body:
        return Text(notification.body);
      case NotificationFields.type:
        return Text(notification.type);
      case NotificationFields.channel:
        return Text(notification.channel);
      case NotificationFields.actionUrl:
        return Text(notification.actionUrl);
      case NotificationFields.payload:
        return Text(notification.payload);
      case NotificationFields.priority:
        return Text(notification.priority);
    }

    return super.getField(field: field, context: context);
  }
}
