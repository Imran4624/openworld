import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ApprovalPendingScreen extends StatelessWidget {
  const ApprovalPendingScreen({Key? key}) : super(key: key);

  static const String route = '/approval_pending';

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.accountPending),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              store.dispatch(UserLogout());
            },
            tooltip: localization.logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.hourglass_top,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 24),
              Text(
                localization.accountPending,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                localization.accountPendingMessage,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextButton.icon(
                icon: Icon(Icons.logout),
                label: Text(localization.logout),
                onPressed: () {
                  store.dispatch(UserLogout());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
