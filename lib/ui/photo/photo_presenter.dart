import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class PhotoPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      PhotoFields.category,

      PhotoFields.storageType,

      PhotoFields.url,

      PhotoFields.isProcessed,

      PhotoFields.tags,
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
    final photo = entity as PhotoEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case PhotoFields.category:
        return Text(photo.category);
      case PhotoFields.storageType:
        return Text(photo.storageType.toString());
      case PhotoFields.url:
        return Text(photo.url);
      case PhotoFields.isProcessed:
        return Text(photo.isProcessed.toString());
      case PhotoFields.tags:
        return Text(photo.tags);
    }

    return super.getField(field: field, context: context);
  }
}
