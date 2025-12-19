// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return StoreBuilder(
        onInit: (Store<AppState> store) {
          if (!store.state.isLoaded && store.state.companies.isEmpty) {
            store.dispatch(LoadStateRequest(context));
          }
        },
        builder: (BuildContext context, Store<AppState> store) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Center(
                      child: Image.asset(ProjectConfig.logoPath(
                          store.state.prefState.enableDarkMode))),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 100,
                        child: Material(
                          child: ElevatedButton(
                            child: Text(
                              localization.logout.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              store.dispatch(UserLogout());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                  child: LinearProgressIndicator(),
                )
              ],
            ),
          );
        });
  }
}
