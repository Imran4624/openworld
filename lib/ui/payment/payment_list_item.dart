import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/entity_state_label.dart';
import 'package:flutter_boilerplate/utils/formatting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/dismissible_entity.dart';

class PaymentListItem extends StatelessWidget {
  const PaymentListItem({
    required this.user,
    required this.payment,
    required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
  });

  final UserEntity? user;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;
  final PaymentEntity payment;
  final String? filter;
  final Function(bool?)? onCheckboxChanged;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = state.uiState;
    final paymentUIState = uiState.paymentUIState;
    final listUIState = paymentUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;

    final filterMatch =
        filter?.isNotEmpty == true ? payment.matchesFilterValue(filter!) : null;

    return DismissibleEntity(
      userCompany: state.userCompany,
      entity: payment,
      isSelected: payment.id ==
          (uiState.isEditing
              ? paymentUIState.editing?.id
              : paymentUIState.selectedId),
      child: ListTile(
        onTap: () => onTap != null ? onTap!() : selectEntity(entity: payment),
        onLongPress: () => onLongPress != null
            ? onLongPress!()
            : selectEntity(entity: payment, longPress: true),
        leading: showCheckbox
            ? IgnorePointer(
                ignoring: listUIState.isInMultiselect(),
                child: Checkbox(
                  value: isChecked,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onChanged: (value) => onCheckboxChanged?.call(value),
                  activeColor: Theme.of(context).colorScheme.secondary,
                ),
              )
            : null,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  //STARTER: primary field - do not remove comment
                  payment.id,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                formatNumber(payment.listDisplayAmount, context)!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (filterMatch != null && filterMatch.isNotEmpty)
              Text(
                filterMatch,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            EntityStateLabel(payment),
          ],
        ),
      ),
    );
  }
}
