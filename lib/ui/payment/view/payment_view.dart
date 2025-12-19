import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';
import 'package:flutter_boilerplate/ui/payment/view/payment_view_vm.dart';
import 'package:flutter_boilerplate/ui/app/view_scaffold.dart';
// STARTER: import - do not remove comment
import 'package:flutter_boilerplate/data/models/payment_model.dart';
import 'package:flutter_boilerplate/ui/app/FieldGrid.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final PaymentViewVM viewModel;
  final bool isFilter;

  @override
  _PaymentViewState createState() => new _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final payment = viewModel.payment;

    return ViewScaffold(
      isFilter: widget.isFilter,
      entity: payment,
      //STARTER: primary field - do not remove comment
      title: payment.id,
      onBackPressed: () => viewModel.onBackPressed(),
      body: ScrollableListView(
        children: <Widget>[
          const SizedBox(height: 16.0),
          FieldGrid(
            {
              // STARTER: field grid - do not remove comment
              PaymentFields.id: payment.id,
              PaymentFields.idempotencyKey: payment.idempotencyKey,
              PaymentFields.isChanged: payment.isChanged.toString(),
              PaymentFields.amount: payment.amount.toString(),
              PaymentFields.transactionReference: payment.transactionReference,
              PaymentFields.date: payment.date,
              PaymentFields.typeId: payment.typeId,
              PaymentFields.privateNotes: payment.privateNotes,
              PaymentFields.exchangeRate: payment.exchangeRate.toString(),
              PaymentFields.exchangeCurrencyId: payment.exchangeCurrencyId,
              PaymentFields.refunded: payment.refunded.toString(),
              PaymentFields.applied: payment.applied.toString(),
              PaymentFields.statusId: payment.statusId,
              PaymentFields.updatedAt: payment.updatedAt.toString(),
              PaymentFields.archivedAt: payment.archivedAt.toString(),
              PaymentFields.isDeleted: payment.isDeleted.toString(),
              PaymentFields.isManual: payment.isManual.toString(),
              PaymentFields.paymentables: payment.paymentables,
              PaymentFields.invoices: payment.invoices,
              PaymentFields.assignedUserId: payment.assignedUserId,
              PaymentFields.createdAt: payment.createdAt.toString(),
              PaymentFields.createdUserId: payment.createdUserId,
              PaymentFields.number: payment.number,
              PaymentFields.sendEmail: payment.sendEmail.toString(),
              PaymentFields.companyGatewayId: payment.companyGatewayId,
              PaymentFields.clientContactId: payment.clientContactId,
              PaymentFields.currencyId: payment.currencyId,
              PaymentFields.transactionId: payment.transactionId,
              PaymentFields.invitationId: payment.invitationId,
              PaymentFields.isApplying: payment.isApplying.toString(),
            },
          ),
        ],
      ),
    );
  }
}
