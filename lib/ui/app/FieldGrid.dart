// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_boilerplate/ui/app/copy_to_clipboard.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/lists/list_divider.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class FieldGrid extends StatelessWidget {
  const FieldGrid(this.fields);

  final Map<String?, String?> fields;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    final List<Widget> fieldWidgets = fields.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .map((entry) {
      final key = entry.key!;
      final value = entry.value!;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CopyToClipboard(
          value: value,
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${localization!.lookup(key)}: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor!.withOpacity(.75),
                  ),
                ),
                const TextSpan(
                  text: '  ',
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    if (fieldWidgets.isEmpty) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: fieldWidgets,
            ),
          ),
        ),
        ListDivider(),
      ],
    );
  }
}
