import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:widget_kit_plugin/widget_kit_plugin.dart';

class WidgetUtils {
  static const DATA_KEY = 'widget_data';
  static const APP_GROUP = 'group.com.example.boilerplate';

  static void updateData() {
    return; //todo need to use to save user preferences
    // if (!isApple()) {
    //   return;
    // }

    // WidgetsBinding.instance.addPostFrameCallback((duration) async {
    //   final context = navigatorKey.currentContext!;
    //   final localization = AppLocalization.of(context);
    //   final store = StoreProvider.of<AppState>(context);
    //   final state = store.state;

    //   final json = jsonEncode(WidgetData.fromState(state, localization));

    //   await UserDefaults.setString(DATA_KEY, json, APP_GROUP);
    //   await WidgetKit.reloadAllTimelines();
    // });
  }

  static void clearData() {
    // TODO: Implement functionality to clear user preferences
    if (!isApple()) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      UserDefaults.remove(DATA_KEY, APP_GROUP);
    });
  }
}
