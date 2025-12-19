// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:

class CustomSurcharges extends StatelessWidget {
  const CustomSurcharges({
    required this.surcharge1Controller,
    required this.surcharge2Controller,
    required this.surcharge3Controller,
    required this.surcharge4Controller,
    this.onSavePressed,
    this.isAfterTaxes = false,
  });

  final TextEditingController surcharge1Controller;
  final TextEditingController surcharge2Controller;
  final TextEditingController surcharge3Controller;
  final TextEditingController surcharge4Controller;
  final Function(BuildContext)? onSavePressed;
  final bool isAfterTaxes;

  @override
  Widget build(BuildContext context) {
    // final state = StoreProvider.of<AppState>(context).state;
    // final CompanyEntity company = state.company;

    return Column(
      children: <Widget>[
        // if (company.hasCustomField(CustomFieldType.surcharge4) &&
        //     ((isAfterTaxes && !company.enableCustomSurchargeTaxes4) ||
        //         (!isAfterTaxes && company.enableCustomSurchargeTaxes4)))
        //   DecoratedFormField(
        //     controller: surcharge4Controller,
        //     label: company.getCustomFieldLabel(CustomFieldType.surcharge4),
        //     keyboardType:
        //         TextInputType.numberWithOptions(decimal: true, signed: true),
        //     onSavePressed: onSavePressed,
        //   ),
      ],
    );
  }
}
