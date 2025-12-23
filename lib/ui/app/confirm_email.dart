// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/confirm_email_vm.dart';
import 'package:flutter_boilerplate/ui/app/help_text.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';
import 'package:flutter_boilerplate/utils/localization.dart';

class ConfirmEmail extends StatefulWidget {
  const ConfirmEmail({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final ConfirmEmailVM viewModel;

  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  bool _showNotVerifiedMessage = false;
  final String _notVerifiedMessage =
      "Your email address is not confirmed. Please click on the link sent to your email address";

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = widget.viewModel.state!;
    final initialMessage =
        'An email is sent to ${state.authState.email} please click on the link in email to verify your email address';

    return Material(
      color: Theme.of(context).cardColor,
      child: state.isLoading || state.isSaving
          ? LoadingIndicator()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    ProjectConfig.logoPath(state.prefState.enableDarkMode),
                    height: 80,
                  ),
                  SizedBox(height: 60),
                  Text(
                    localization!.confirmYourEmailAddress,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 80),
                    child: HelpText(_showNotVerifiedMessage
                        ? _notVerifiedMessage
                        : initialMessage),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: kTableColumnGap),
                      //   child: TextButton(
                      //     onPressed: widget.viewModel.onResendPressed as void Function()?,
                      //     child: Text(localization.resendEmail.toUpperCase()),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: kTableColumnGap),
                        child: TextButton(
                          onPressed: () async {
                            await widget.viewModel.isEmailConfirmed!();

                            if (!state.authState.isEmailVerified && mounted) {
                              Future.delayed(const Duration(milliseconds: 500),
                                  () {
                                if (mounted) {
                                  setState(() {
                                    _showNotVerifiedMessage = true;
                                  });
                                }
                              });
                            }
                          },
                          child: Text(
                              localization.iHaveConfirmedEmail.toUpperCase()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: kTableColumnGap),
                        child: TextButton(
                          onPressed: widget.viewModel.onLogoutPressed as void
                              Function()?,
                          child: Text(localization.logout.toUpperCase()),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
