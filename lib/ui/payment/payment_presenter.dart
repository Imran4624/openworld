import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/ui/app/presenters/entity_presenter.dart';

class PaymentPresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      // STARTER: constant fields - do not remove comment
      PaymentFields.id,

      PaymentFields.idempotencyKey,

      PaymentFields.isChanged,

      PaymentFields.amount,

      PaymentFields.transactionReference,

      PaymentFields.date,

      PaymentFields.typeId,

      PaymentFields.privateNotes,

      PaymentFields.exchangeRate,

      PaymentFields.exchangeCurrencyId,

      PaymentFields.refunded,

      PaymentFields.applied,

      PaymentFields.statusId,

      PaymentFields.updatedAt,

      PaymentFields.archivedAt,

      PaymentFields.isDeleted,

      PaymentFields.isManual,

      PaymentFields.paymentables,

      PaymentFields.invoices,

      PaymentFields.assignedUserId,

      PaymentFields.createdAt,

      PaymentFields.createdUserId,

      PaymentFields.number,

      PaymentFields.sendEmail,

      PaymentFields.companyGatewayId,

      PaymentFields.clientContactId,

      PaymentFields.currencyId,

      PaymentFields.transactionId,

      PaymentFields.invitationId,

      PaymentFields.isApplying,
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
    final payment = entity as PaymentEntity;

    switch (field) {
      // STARTER: switch case - do not remove comment
      case PaymentFields.id:
        return Text(payment.id);
      case PaymentFields.idempotencyKey:
        return Text(payment.idempotencyKey);
      case PaymentFields.isChanged:
        return Text(payment.isChanged.toString());
      case PaymentFields.amount:
        return Text(payment.amount.toString());
      case PaymentFields.transactionReference:
        return Text(payment.transactionReference);
      case PaymentFields.date:
        return Text(payment.date);
      case PaymentFields.typeId:
        return Text(payment.typeId);
      case PaymentFields.privateNotes:
        return Text(payment.privateNotes);
      case PaymentFields.exchangeRate:
        return Text(payment.exchangeRate.toString());
      case PaymentFields.exchangeCurrencyId:
        return Text(payment.exchangeCurrencyId);
      case PaymentFields.refunded:
        return Text(payment.refunded.toString());
      case PaymentFields.applied:
        return Text(payment.applied.toString());
      case PaymentFields.statusId:
        return Text(payment.statusId);
      case PaymentFields.updatedAt:
        return Text(payment.updatedAt.toString());
      case PaymentFields.archivedAt:
        return Text(payment.archivedAt.toString());
      case PaymentFields.isDeleted:
        return Text(payment.isDeleted.toString());
      case PaymentFields.isManual:
        return Text(payment.isManual.toString());
      case PaymentFields.paymentables:
        return Text(payment.paymentables);
      case PaymentFields.invoices:
        return Text(payment.invoices);
      case PaymentFields.assignedUserId:
        return Text(payment.assignedUserId);
      case PaymentFields.createdAt:
        return Text(payment.createdAt.toString());
      case PaymentFields.createdUserId:
        return Text(payment.createdUserId);
      case PaymentFields.number:
        return Text(payment.number);
      case PaymentFields.sendEmail:
        return Text(payment.sendEmail.toString());
      case PaymentFields.companyGatewayId:
        return Text(payment.companyGatewayId);
      case PaymentFields.clientContactId:
        return Text(payment.clientContactId);
      case PaymentFields.currencyId:
        return Text(payment.currencyId);
      case PaymentFields.transactionId:
        return Text(payment.transactionId);
      case PaymentFields.invitationId:
        return Text(payment.invitationId);
      case PaymentFields.isApplying:
        return Text(payment.isApplying.toString());
    }

    return super.getField(field: field, context: context);
  }
}
