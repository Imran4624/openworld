// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/company/company_selectors.dart';

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:flutter_boilerplate/ui/app/entity_header.dart';
import 'package:flutter_boilerplate/ui/app/lists/list_divider.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
import 'package:flutter_boilerplate/ui/design/view/design_view_vm.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class DesignView extends StatefulWidget {
  const DesignView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final DesignViewVM viewModel;
  final bool isFilter;

  @override
  _DesignViewState createState() => new _DesignViewState();
}

class _DesignViewState extends State<DesignView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final design = viewModel.design;
    final localization = AppLocalization.of(context)!;

    int count = 0;

    // count += state.invoiceState.list
    //     .map((invoiceId) => state.invoiceState.map[invoiceId])
    //     .where(
    //         (invoice) => !invoice!.isDeleted! && invoice.designId == design.id)
    //     .length;

    return ViewScaffold(
        isFilter: widget.isFilter,
        entity: design,
        onBackPressed: () => viewModel.onBackPressed(),
        body: ScrollableListView(
          children: [
            EntityHeader(
              entity: design,
              value: '$count',
              label: localization.count,
              secondLabel: localization.lastUpdated,
              secondValue: timeago.format(
                  convertTimestampToDate(design.updatedAt),
                  locale: localeSelector(state, twoLetter: true)),
            ),
            ListDivider(),
            // if (company.isModuleEnabled(EntityType.invoice))
            //   EntitiesListTile(
            //     entity: design,
            //     isFilter: widget.isFilter,
            //     title: localization.invoices,
            //     entityType: EntityType.invoice,
            //     subtitle: memoizedInvoiceStatsForDesign(
            //             design.id, state.invoiceState.map)
            //         .present(localization.active, localization.archived),
            //   ),
          ],
        ));
  }
}
