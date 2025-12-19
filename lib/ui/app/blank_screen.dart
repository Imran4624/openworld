// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/ui/app/help_text.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen([this.message]);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: isMobile(context),
      ),
      body: Container(
        color: Theme.of(context).cardColor,
        child: HelpText(message ?? ''),
      ),
    );
  }
}
