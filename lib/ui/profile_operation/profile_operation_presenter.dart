import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class ProfileOperationPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      ProfileOperationFields.status,

      ProfileOperationFields.comment,

      ProfileOperationFields.type,
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
    final profileOperation = entity as ProfileOperationEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case ProfileOperationFields.status:
        return Text(profileOperation.status.toString());
      case ProfileOperationFields.comment:
        return Text(profileOperation.comment);
      case ProfileOperationFields.type:
        return Text(profileOperation.type.toString());
    }

    return super.getField(field: field, context: context);
  }
}
