// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/utils/colors.dart';

class AppBorder extends StatelessWidget {
  const AppBorder({
    required this.child,
    this.isTop,
    this.isBottom,
    this.isLeft,
    this.hideBorder = false,
  });

  final Widget? child;
  final bool? isTop;
  final bool? isBottom;
  final bool? isLeft;
  final bool hideBorder;

  @override
  Widget build(BuildContext context) {
    if (hideBorder) {
      return child!;
    }

    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final enableDarkMode = state.prefState.enableDarkMode;
    final isAllSides = isTop == null && isLeft == null;
    final borderWidth = isWeb() ? 2 : 1.5;

    final color = enableDarkMode
        ? convertHexStringToColor(kDefaultDarkBorderColor)
        : convertHexStringToColor(kDefaultLightBorderColor);

    return Container(
        decoration: BoxDecoration(
          borderRadius:
              isAllSides ? BorderRadius.circular(kBorderRadius) : null,
          border: isAllSides
              ? Border.all(
                  width: borderWidth as double,
                  color: color!,
                )
              : Border(
                  top: isTop == true
                      ? BorderSide(
                          width: borderWidth as double,
                          color: color!,
                        )
                      : BorderSide.none,
                  bottom: isBottom == true
                      ? BorderSide(
                          width: borderWidth as double,
                          color: color!,
                        )
                      : BorderSide.none,
                  left: isLeft == true
                      ? BorderSide(
                          width: borderWidth as double,
                          color: color!,
                        )
                      : BorderSide.none,
                ),
        ),
        child: child);
  }
}
