// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class EntityStatusChip extends StatelessWidget {
  const EntityStatusChip({
    required this.entity,
    this.addGap = false,
    this.width = 105,
    this.showState = false,
  });

  final BaseEntity? entity;
  final bool addGap;
  final double? width;
  final bool showState;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final localization = AppLocalization.of(context)!;
    String? label = '';
    Color? color;
    // bool isBounced = false;

    if (showState && !entity!.isActive) {
      if (entity!.isArchived) {
        label = localization.archived;
        color = Colors.orange;
      } else if (entity!.isDeleted!) {
        label = localization.deleted;
        color = state.prefState.colorThemeModel!.colorDanger;
      }
    } else {
      switch (entity!.entityType) {
        // case EntityType.purchaseOrder:
        //   final purchaseOrder = entity as InvoiceEntity;
        //   label = kPurchaseOrderStatuses[purchaseOrder.calculatedStatusId];
        //   color = PurchaseOrderStatusColors(state.prefState.colorThemeModel)
        //       .colors[purchaseOrder.calculatedStatusId];
        //   isBounced = purchaseOrder.isBounced;
        //   break;
        default:
          return SizedBox();
      }

      // label = localization.lookup(label);

      // if (label.isEmpty) {
      //   label = localization.logged;
      // }
    }

    return Padding(
      padding: EdgeInsets.only(left: addGap ? 16 : 0),
      child: Tooltip(
        message: '',
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(kBorderRadius)),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: width ?? 100,
                  maxWidth: width ?? 200,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 13, color: Colors.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            // if (isBounced)
            // Padding(
            //   padding: const EdgeInsets.only(left: 4),
            //   child: Icon(
            //     MdiIcons.alertCircleOutline,
            //     size: 16,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
