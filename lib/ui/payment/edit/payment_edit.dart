import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/app/edit_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/payment/edit/payment_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';
import 'package:flutter_boilerplate/ui/app/scrollable_listview.dart';

class PaymentEdit extends StatefulWidget {
  const PaymentEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final PaymentEditVM viewModel;

  @override
  _PaymentEditState createState() => _PaymentEditState();
}

class _PaymentEditState extends State<PaymentEdit> {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_paymentEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment
  final _idController = TextEditingController();
  final _idempotencyKeyController = TextEditingController();
  bool _isChangedValue = false; // Checkbox
  final _amountController = TextEditingController();
  final _transactionReferenceController = TextEditingController();
  final _dateController = TextEditingController();
  final _typeIdController = TextEditingController();
  final _privateNotesController = TextEditingController();
  final _exchangeRateController = TextEditingController();
  final _exchangeCurrencyIdController = TextEditingController();
  final _refundedController = TextEditingController();
  final _appliedController = TextEditingController();
  final _statusIdController = TextEditingController();
  final _updatedAtController = TextEditingController();
  final _archivedAtController = TextEditingController();
  bool _isDeletedValue = false; // Checkbox
  bool _isManualValue = false; // Checkbox
  final _paymentablesController = TextEditingController();
  final _invoicesController = TextEditingController();
  final _assignedUserIdController = TextEditingController();
  final _createdAtController = TextEditingController();
  final _createdUserIdController = TextEditingController();
  final _numberController = TextEditingController();
  bool _sendEmailValue = false; // Checkbox
  final _companyGatewayIdController = TextEditingController();
  final _clientContactIdController = TextEditingController();
  final _currencyIdController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _invitationIdController = TextEditingController();
  bool _isApplyingValue = false; // Checkbox
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment
      _idController,
      _idempotencyKeyController,
      _transactionReferenceController,
      _dateController,
      _typeIdController,
      _privateNotesController,
      _exchangeCurrencyIdController,
      _statusIdController,
      _updatedAtController,
      _archivedAtController,
      _paymentablesController,
      _invoicesController,
      _assignedUserIdController,
      _createdAtController,
      _createdUserIdController,
      _numberController,
      _companyGatewayIdController,
      _clientContactIdController,
      _currencyIdController,
      _transactionIdController,
      _invitationIdController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final payment = widget.viewModel.payment;
    // STARTER: read value - do not remove comment
    _idController.text = payment.id.toString();
    _idempotencyKeyController.text = payment.idempotencyKey.toString();
    _isChangedValue = payment.isChanged;
    _amountController.text = payment.amount.toString();
    _transactionReferenceController.text =
        payment.transactionReference.toString();
    _dateController.text = payment.date.toString();
    _typeIdController.text = payment.typeId.toString();
    _privateNotesController.text = payment.privateNotes.toString();
    _exchangeRateController.text = payment.exchangeRate.toString();
    _exchangeCurrencyIdController.text = payment.exchangeCurrencyId.toString();
    _refundedController.text = payment.refunded.toString();
    _appliedController.text = payment.applied.toString();
    _statusIdController.text = payment.statusId.toString();
    _updatedAtController.text = payment.updatedAt.toString();
    _archivedAtController.text = payment.archivedAt.toString();
    _isDeletedValue = payment.isDeleted;
    _isManualValue = payment.isManual;
    _paymentablesController.text = payment.paymentables.toString();
    _invoicesController.text = payment.invoices.toString();
    _assignedUserIdController.text = payment.assignedUserId.toString();
    _createdAtController.text = payment.createdAt.toString();
    _createdUserIdController.text = payment.createdUserId.toString();
    _numberController.text = payment.number.toString();
    _sendEmailValue = payment.sendEmail;
    _companyGatewayIdController.text = payment.companyGatewayId.toString();
    _clientContactIdController.text = payment.clientContactId.toString();
    _currencyIdController.text = payment.currencyId.toString();
    _transactionIdController.text = payment.transactionId.toString();
    _invitationIdController.text = payment.invitationId.toString();
    _isApplyingValue = payment.isApplying;

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final payment = widget.viewModel.payment.rebuild((b) => b
        // STARTER: set value - do not remove comment
        ..id = _idController.text.trim()
        ..idempotencyKey = _idempotencyKeyController.text.trim()
        ..isChanged = _isChangedValue
        ..amount = double.tryParse(_amountController.text.trim()) ?? 0
        ..transactionReference = _transactionReferenceController.text.trim()
        ..date = _dateController.text.trim()
        ..typeId = _typeIdController.text.trim()
        ..privateNotes = _privateNotesController.text.trim()
        ..exchangeRate =
            double.tryParse(_exchangeRateController.text.trim()) ?? 0
        ..exchangeCurrencyId = _exchangeCurrencyIdController.text.trim()
        ..refunded = double.tryParse(_refundedController.text.trim()) ?? 0
        ..applied = double.tryParse(_appliedController.text.trim()) ?? 0
        ..statusId = _statusIdController.text.trim()
        ..updatedAt = int.tryParse(_updatedAtController.text.trim()) ?? 0
        ..archivedAt = int.tryParse(_archivedAtController.text.trim()) ?? 0
        ..isDeleted = _isDeletedValue
        ..isManual = _isManualValue
        ..paymentables = _paymentablesController.text.trim()
        ..invoices = _invoicesController.text.trim()
        ..assignedUserId = _assignedUserIdController.text.trim()
        ..createdAt = int.tryParse(_createdAtController.text.trim()) ?? 0
        ..createdUserId = _createdUserIdController.text.trim()
        ..number = _numberController.text.trim()
        ..sendEmail = _sendEmailValue
        ..companyGatewayId = _companyGatewayIdController.text.trim()
        ..clientContactId = _clientContactIdController.text.trim()
        ..currencyId = _currencyIdController.text.trim()
        ..transactionId = _transactionIdController.text.trim()
        ..invitationId = _invitationIdController.text.trim()
        ..isApplying = _isApplyingValue);
      if (payment != widget.viewModel.payment) {
        widget.viewModel.onChanged(payment);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final payment = viewModel.payment;

    return EditScaffold(
      title: payment.isNew ? localization.newPayment : localization.editPayment,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState!.validate();
        if (!isValid) {
          return;
        }
        viewModel.onSavePressed(context);
      },
      entity: payment,
      body: Form(
        key: _formKey,
        child: Builder(builder: (BuildContext context) {
          return ScrollableListView(
            children: <Widget>[
              FormCard(
                children: <Widget>[
                  // STARTER: widgets - do not remove comment
                  TextFormField(
                    controller: _idController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Id',
                    ),
                  ),
                  TextFormField(
                    controller: _idempotencyKeyController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'IdempotencyKey',
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('IsChanged'),
                    value: _isChangedValue,
                    onChanged: (value) => setState(() {
                      _isChangedValue = value ?? false;
                      _onChanged();
                    }),
                  ),
                  TextFormField(
                    controller: _amountController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                  TextFormField(
                    controller: _transactionReferenceController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'TransactionReference',
                    ),
                  ),
                  TextFormField(
                    controller: _dateController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Date',
                    ),
                  ),
                  TextFormField(
                    controller: _typeIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'TypeId',
                    ),
                  ),
                  TextFormField(
                    controller: _privateNotesController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'PrivateNotes',
                    ),
                  ),
                  TextFormField(
                    controller: _exchangeRateController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'ExchangeRate',
                    ),
                  ),
                  TextFormField(
                    controller: _exchangeCurrencyIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'ExchangeCurrencyId',
                    ),
                  ),
                  TextFormField(
                    controller: _refundedController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Refunded',
                    ),
                  ),
                  TextFormField(
                    controller: _appliedController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Applied',
                    ),
                  ),
                  TextFormField(
                    controller: _statusIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'StatusId',
                    ),
                  ),
                  TextFormField(
                    controller: _updatedAtController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'UpdatedAt',
                    ),
                  ),
                  TextFormField(
                    controller: _archivedAtController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'ArchivedAt',
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('IsDeleted'),
                    value: _isDeletedValue,
                    onChanged: (value) => setState(() {
                      _isDeletedValue = value ?? false;
                      _onChanged();
                    }),
                  ),
                  CheckboxListTile(
                    title: Text('IsManual'),
                    value: _isManualValue,
                    onChanged: (value) => setState(() {
                      _isManualValue = value ?? false;
                      _onChanged();
                    }),
                  ),
                  TextFormField(
                    controller: _paymentablesController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Paymentables',
                    ),
                  ),
                  TextFormField(
                    controller: _invoicesController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Invoices',
                    ),
                  ),
                  TextFormField(
                    controller: _assignedUserIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'AssignedUserId',
                    ),
                  ),
                  TextFormField(
                    controller: _createdAtController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CreatedAt',
                    ),
                  ),
                  TextFormField(
                    controller: _createdUserIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'CreatedUserId',
                    ),
                  ),
                  TextFormField(
                    controller: _numberController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Number',
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('SendEmail'),
                    value: _sendEmailValue,
                    onChanged: (value) => setState(() {
                      _sendEmailValue = value ?? false;
                      _onChanged();
                    }),
                  ),
                  TextFormField(
                    controller: _companyGatewayIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'CompanyGatewayId',
                    ),
                  ),
                  TextFormField(
                    controller: _clientContactIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'ClientContactId',
                    ),
                  ),
                  TextFormField(
                    controller: _currencyIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'CurrencyId',
                    ),
                  ),
                  TextFormField(
                    controller: _transactionIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'TransactionId',
                    ),
                  ),
                  TextFormField(
                    controller: _invitationIdController,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'InvitationId',
                    ),
                  ),
                  CheckboxListTile(
                    title: Text('IsApplying'),
                    value: _isApplyingValue,
                    onChanged: (value) => setState(() {
                      _isApplyingValue = value ?? false;
                      _onChanged();
                    }),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
