import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/chat_model.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class ChatPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment

      ChatFields.groupName,

      ChatFields.centityType,

      ChatFields.centityId,

      ChatFields.groupThumbnail,

      ChatFields.unreadCount,
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
    final chat = entity as ChatEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment

      case ChatFields.groupName:
        return Text(chat.groupName);

      case ChatFields.status:
      case ChatFields.centityType:
      case ChatFields.centityId:
        return Text(chat.centityId);

      case ChatFields.groupThumbnail:
        return Text(chat.groupThumbnail);
    }

    return super.getField(field: field, context: context);
  }
}
