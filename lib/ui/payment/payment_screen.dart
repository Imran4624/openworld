import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/data/models/models.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/payment/payment_actions.dart';
import 'package:flutter_boilerplate/services/stripe_service.dart';
import 'package:flutter_boilerplate/ui/app/app_bottom_bar.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/list_filter.dart';
import 'package:flutter_boilerplate/ui/payment/payment_list_vm.dart';
import 'package:flutter_boilerplate/ui/payment/payment_presenter.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_connect_screen.dart';
import 'package:flutter_boilerplate/ui/payment/stripe/stripe_payment_screen.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

import 'payment_screen_vm.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  static const String route = '/payment';

  final PaymentScreenVM viewModel;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _errorMessage;
  final StripeService _stripeService = StripeService();

  Future<void> _handleSubscribe() async {
    Navigator.of(context).pushNamed(
      StripePaymentScreen.route,
      arguments: {'mode': 'subscription'},
    );
  }

  Future<void> _handleUnsubscribe() async {
    final confirmed = await _showConfirmationDialog(
      'Unsubscribe',
      'Are you sure you want to cancel your subscription? This action cannot be undone.',
    );

    if (!confirmed) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Finding your subscriptions...'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 30),
        ),
      );

      final subscriptionsResult = await _stripeService.getUserSubscriptions();
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (subscriptionsResult['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${subscriptionsResult['error']}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final subscriptions = subscriptionsResult['subscriptions'] as List<Map<String, dynamic>>;
      
      if (subscriptions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No active subscriptions found.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      String selectedSubscriptionId;
      if (subscriptions.length == 1) {
        selectedSubscriptionId = subscriptions.first['subscriptionId'];
      } else {
        final selected = await _showSubscriptionSelectionDialog(subscriptions);
        if (selected == null) return; 
        selectedSubscriptionId = selected;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Cancelling subscription...'),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 30),
        ),
      );

      final cancelResult = await _stripeService.cancelSubscription(selectedSubscriptionId);
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (cancelResult['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Subscription cancelled successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel subscription: ${cancelResult['error']}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<String?> _showSubscriptionSelectionDialog(List<Map<String, dynamic>> subscriptions) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Subscription to Cancel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('You have multiple active subscriptions. Please select which one to cancel:'),
            const SizedBox(height: 16),
            ...subscriptions.map((subscription) {
              final data = subscription['data'] as Map<String, dynamic>;
              final productName = data['productName'] ?? 'Unknown Product';
              final amount = data['amount'] ?? 0;
              final currency = (data['currency'] ?? 'usd').toString().toUpperCase();
              final interval = data['interval'] ?? 'month';
              final intervalCount = data['intervalCount'] ?? 1;
              
              return Card(
                child: ListTile(
                  title: Text(productName),
                  subtitle: Text('${(amount / 100).toStringAsFixed(2)} $currency every $intervalCount $interval${intervalCount > 1 ? 's' : ''}'),
                  onTap: () => Navigator.of(context).pop(subscription['subscriptionId']),
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final userCompany = state.userCompany;
    final localization = AppLocalization.of(context)!;
    ;

    return ListScaffold(
      entityType: EntityType.payment,
      onHamburgerLongPress: () => store.dispatch(StartPaymentMultiselect()),
      appBarTitle: ListFilter(
        key: ValueKey('__filter_${state.paymentListState.filterClearedAt}__'),
        entityType: EntityType.payment,
        entityIds: widget.viewModel.paymentList,
        filter: state.paymentState.filter.searchTerm,
        onFilterChanged: (value) {
          store.dispatch(FilterPayments(value!));
          store.dispatch(UpdatePaymentFilter(
            state.paymentState.filter.rebuild((b) => b..searchTerm = value),
          ));
        },
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterPaymentsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdatePaymentFilter(
              state.paymentState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
        },
        selectedStateFilter: state.paymentState.filter.stateFilter,
      ),
      onCheckboxPressed: () {
        if (store.state.paymentListState.isInMultiselect()) {
          store.dispatch(ClearPaymentMultiselect());
        } else {
          store.dispatch(StartPaymentMultiselect());
        }
      },
      body: Column(
        children: [
          if (_errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              ),
            ),
          // Stripe action buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(StripeConnectScreen.route);
                        },
                        icon: const Icon(Icons.account_balance,
                            color: Colors.white),
                        label: const Text('Configure Stripe Connect'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(StripePaymentScreen.route);
                        },
                        icon: const Icon(Icons.payment, color: Colors.white),
                        label: const Text('Take Payment'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleSubscribe(),
                        icon: const Icon(Icons.subscriptions,
                            color: Colors.white),
                        label: const Text('Subscribe'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleUnsubscribe(),
                        icon:
                            const Icon(Icons.unsubscribe, color: Colors.white),
                        label: const Text('Unsubscribe'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Payment list
          const Expanded(child: PaymentListBuilder()),
        ],
      ),
      bottomNavigationBar: AppBottomBar(
        entityType: EntityType.payment,
        tableColumns: PaymentPresenter.getAllTableFields(userCompany),
        defaultTableColumns:
            PaymentPresenter.getDefaultTableFields(userCompany),
        onSelectedSortField: (field) {
          final ascending = state.paymentState.filter.sortField == field
              ? !state.paymentState.filter.sortAscending
              : true;
          store.dispatch(UpdatePaymentFilter(
            state.paymentState.filter.rebuild((b) => b
              ..sortField = field
              ..sortAscending = ascending),
          ));
        },
        sortFields: [
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
        ],
        onSelectedState: (EntityState filterState, bool? value) {
          store.dispatch(FilterPaymentsByState(filterState));
          if (value ?? false) {
            store.dispatch(UpdatePaymentFilter(
              state.paymentState.filter
                  .rebuild((b) => b..stateFilter = filterState),
            ));
          }
        },
        onCheckboxPressed: () {
          if (store.state.paymentListState.isInMultiselect()) {
            store.dispatch(ClearPaymentMultiselect());
          } else {
            store.dispatch(StartPaymentMultiselect());
          }
        },
        // // customValues1: userCompany.getCustomFieldValues(CustomFieldType.payment1,
        // //     excludeBlank: true),
        // // customValues2: userCompany.getCustomFieldValues(CustomFieldType.payment2,
        // //     excludeBlank: true),
        // // customValues3: userCompany.getCustomFieldValues(CustomFieldType.payment3,
        // //     excludeBlank: true),
        // // customValues4: userCompany.getCustomFieldValues(CustomFieldType.payment4,
        //     excludeBlank: true),
        // onSelectedCustom1: (value) =>
        //     store.dispatch(FilterPaymentsByCustom1(value)),
        // onSelectedCustom2: (value) =>
        //     store.dispatch(FilterPaymentsByCustom2(value)),
        // onSelectedCustom3: (value) =>
        //     store.dispatch(FilterPaymentsByCustom3(value)),
        // onSelectedCustom4: (value) =>
        //     store.dispatch(FilterPaymentsByCustom4(value)),
      ),
      floatingActionButton: state.prefState.isMenuFloated &&
              userCompany.canCreate(EntityType.payment)
          ? FloatingActionButton(
              heroTag: 'payment_fab',
              backgroundColor: Theme.of(context).primaryColorDark,
              onPressed: () {
                createEntityByType(
                    context: context, entityType: EntityType.payment);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              tooltip: localization.newPayment,
            )
          : null,
    );
  }
}
