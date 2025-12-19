// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/form_card.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_tab_bar.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class VariablesHelp extends StatefulWidget {
  const VariablesHelp({
    this.showInvoiceAsQuote = false,
    this.showInvoiceAsInvoices = false,
  });

  final bool showInvoiceAsQuote;
  final bool showInvoiceAsInvoices;

  @override
  _VariablesHelpState createState() => _VariablesHelpState();
}

class _VariablesHelpState extends State<VariablesHelp>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 1);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    return FormCard(
      children: [
        AppTabBar(
          controller: _controller,
          isScrollable: true,
          tabs: [
            Tab(child: Text(localization.company)),
          ],
        ),
        SizedBox(
          height: 540,
          child: TabBarView(
            controller: _controller,
            children: [
              _VariableGrid(fields: ['this is an example field']),
            ],
          ),
        ),
      ],
    );
  }
}

class _VariableGrid extends StatelessWidget {
  const _VariableGrid({this.fields});

  final List<String>? fields;

  @override
  Widget build(BuildContext context) {
    fields!.sort((a, b) => a.compareTo(b));

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: LayoutBuilder(builder: (context, constraints) {
        return GridView.count(
          //physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(6),
          shrinkWrap: true,
          primary: true,
          crossAxisCount: 2,
          childAspectRatio: ((constraints.maxWidth / 2) - 8) / 50,
          children: fields!
              .map(
                (field) => TextButton(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '\$$field',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: '\$$field'));
                    showToast(AppLocalization.of(context)!
                        .copiedToClipboard
                        .replaceFirst(':value', '\$$field'));
                  },
                ),
              )
              .toList(),
        );
      }),
    );
  }
}
