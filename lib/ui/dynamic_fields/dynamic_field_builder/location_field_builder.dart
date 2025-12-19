import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_builder/location_field.dart';

Widget buildLocationTextField(
  BuildContext context,
  QuestionModel question,
  dynamic initialValue,
  void Function(dynamic) updateAnswer,
  TextEditingController? controller, {
  bool? showBorder = true,
  String? customHint,
  String? customLabel,
  TextStyle? textStyle,
}) {
  return LocationField(
    question: question,
    initialValue: initialValue,
    updateAnswer: updateAnswer,
    controller: controller,
    showBorder: showBorder,
    customHint: customHint,
    customLabel: customLabel,
    textStyle: textStyle,
  );
}
