// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'constants.dart';
import 'data/models/static/color_theme_model.dart';

class TaskStatusColors {
  TaskStatusColors(this._colorTheme);

  final ColorTheme? _colorTheme;

  Map<String, Color?> get colors {
    return {
      kTaskStatusLogged: _colorTheme!.colorLightGray,
      kTaskStatusRunning: _colorTheme.colorPrimary,
      kTaskStatusInvoiced: _colorTheme.colorSuccess,
    };
  }
}
