import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class ProfilePresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      ProfileFields.name ?? '',
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
    final profile = entity as ProfileEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case ProfileFields.name:
        return Text(profile.name);
    }

    return super.getField(field: field, context: context);
  }
}
