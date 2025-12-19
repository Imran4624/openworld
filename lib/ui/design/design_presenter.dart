// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class DesignPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity? userCompany) {
    return [];
  }

  static List<String> getAllTableFields(UserCompanyEntity userCompany) {
    return [
      ...getDefaultTableFields(userCompany),
    ];
  }

  @override
  Widget getField({String? field, required BuildContext context}) {
    //final state = StoreProvider.of<AppState>(context).state;
    //final design = entity as InvoiceEntity;

    switch (field) {
      //
    }

    return super.getField(field: field, context: context);
  }
}
