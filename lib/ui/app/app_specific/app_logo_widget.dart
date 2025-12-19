import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AppLogoWidget extends StatelessWidget {
  final Color textColor;

  const AppLogoWidget({
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    if (ProjectConfig.showAppLogoOnAuthScreens) {
      return Image.asset(
        ProjectConfig.logoPath(store.state.prefState.enableDarkMode),
        height: 100,
        width: 300,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  ProjectConfig.logoPath(store.state.prefState.enableDarkMode),
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                Config.APP_NAME,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
