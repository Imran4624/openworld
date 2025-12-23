import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/redux/auth/auth_actions.dart';
import 'package:flutter_boilerplate/ui/app/forms/phone_input_field.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/settings/settings_actions.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_form.dart';
import 'package:flutter_boilerplate/ui/app/loading_indicator.dart';
import 'package:flutter_boilerplate/ui/app/pinput.dart';
import 'package:flutter_boilerplate/utils/dialogs.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSmsVerification extends StatefulWidget {
  const AccountSmsVerification();

  @override
  State<AccountSmsVerification> createState() => _AccountSmsVerificationState();
}

class _AccountSmsVerificationState extends State<AccountSmsVerification> {
  bool _showCode = false;
  bool _isLoading = false;
  String _code = '';
  String _phone = '';
  String _verificationId = '';

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_accountSmsVerification');
  final FocusScopeNode _focusNode = FocusScopeNode();

  void _sendCode() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final store = StoreProvider.of<AppState>(context);
    final completer = Completer<String>();

    setState(() {
      _isLoading = true;
    });

    store.dispatch(SendPhoneVerificationCodeRequest(
      completer: completer,
      phoneNumber: _phone,
    ));

    completer.future.then((verificationId) {
      setState(() {
        _isLoading = false;
        _showCode = true;
        _verificationId = verificationId;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(message: error.toString());
    });
  }

  void _verifyCode() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context);
    final navigator = Navigator.of(context);
    final completer = Completer<void>();

    setState(() {
      _isLoading = true;
    });

    store.dispatch(VerifyPhoneCodeRequest(
      completer: completer,
      verificationId: _verificationId,
      smsCode: _code,
    ));

    completer.future.then((_) {
      setState(() {
        _isLoading = false;
      });

      if (navigator.canPop()) {
        navigator.pop();
      }

      showToast(localization!.verifiedPhoneNumber);
      store.dispatch(RefreshData());
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(message: error.toString());
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    var countryId = state.company.settings.countryId;
    if ((countryId ?? '').isEmpty) {
      countryId = kCountryUnitedStates;
    }

    return AlertDialog(
      title: Text(localization.verifyPhoneNumber),
      content: _isLoading
          ? LoadingIndicator(height: 80)
          : AppForm(
              focusNode: _focusNode,
              formKey: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showCode) ...[
                    Text(localization.codeWasSent),
                    SizedBox(height: 20),
                    AppPinput(
                      onCompleted: (code) => _code = code,
                    ),
                  ] else
                    PhoneInputField(
                      autofocus: true,
                      onChanged: (phone) => _phone = phone.completeNumber,
                      validator: (value) =>
                          value == null || value.number.isEmpty
                              ? localization.pleaseEnterAValue
                              : null,
                    ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            localization.cancel.toUpperCase(),
          ),
        ),
        if (_showCode) ...[
          TextButton(
            onPressed: () => _sendCode(),
            child: Text(
              localization.resend.toUpperCase(),
            ),
          ),
          TextButton(
            onPressed: () => _verifyCode(),
            child: Text(
              localization.verify.toUpperCase(),
            ),
          ),
        ] else ...[
          TextButton(
            onPressed: () => _sendCode(),
            child: Text(
              localization.sendCode.toUpperCase(),
            ),
          ),
        ]
      ],
    );
  }
}

class UserSmsVerification extends StatefulWidget {
  const UserSmsVerification({
    Key? key,
    this.email,
    this.showChangeNumber = false,
  }) : super(key: key);

  final bool showChangeNumber;
  final String? email;

  @override
  State<UserSmsVerification> createState() => _UserSmsVerificationState();
}

class _UserSmsVerificationState extends State<UserSmsVerification> {
  bool _isLoading = false;
  String _code = '';
  String _verificationId = '';

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_userSmsVerification');
  final FocusScopeNode _focusNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _sendCode();
    });
  }

  void _sendCode() {
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final user = state.user;
    final completer = Completer<String>();

    if (user.phone.isEmpty) {
      showErrorDialog(message: 'Phone number is not added');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    store.dispatch(SendPhoneVerificationCodeRequest(
      completer: completer,
      phoneNumber: user.phone,
    ));

    completer.future.then((verificationId) {
      setState(() {
        _isLoading = false;
        _verificationId = verificationId;
      });
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(message: error.toString());
    });
  }

  void _verifyCode() {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context);
    final navigator = Navigator.of(context);
    final completer = Completer<void>();

    setState(() {
      _isLoading = true;
    });

    store.dispatch(VerifyPhoneCodeRequest(
      completer: completer,
      verificationId: _verificationId,
      smsCode: _code,
    ));

    completer.future.then((_) {
      setState(() {
        _isLoading = false;
      });

      if (navigator.canPop()) {
        navigator.pop();
      }

      if (widget.email == null) {
        showToast(localization!.verifiedPhoneNumber);
      } else {
        showToast(localization!.disabledTwoFactor);
      }

      store.dispatch(RefreshData());
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      showErrorDialog(message: error.toString());
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return AlertDialog(
      title: Text(widget.email == null
          ? localization.verifyPhoneNumber
          : localization.disableTwoFactor),
      content: _isLoading
          ? LoadingIndicator(height: 80)
          : AppForm(
              focusNode: _focusNode,
              formKey: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(localization.codeWasSentTo
                      .replaceFirst(':number', state.user.phone)),
                  SizedBox(height: 20),
                  AppPinput(
                    onCompleted: (code) => _code = code,
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            localization.cancel.toUpperCase(),
          ),
        ),
        if (!_isLoading) ...[
          if (widget.showChangeNumber)
            TextButton(
              onPressed: () {
                store.dispatch(ViewSettings(section: kSettingsUserDetails));
                Navigator.of(context).pop();
              },
              child: Text(
                localization.changeNumber.toUpperCase(),
              ),
            ),
          TextButton(
            onPressed: () => _sendCode(),
            child: Text(
              localization.resendCode.toUpperCase(),
            ),
          ),
          TextButton(
            onPressed: () => _verifyCode(),
            child: Text(
              localization.verify.toUpperCase(),
            ),
          ),
        ],
      ],
    );
  }
}

class PhoneVerificationDialog extends StatefulWidget {
  const PhoneVerificationDialog({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
    required this.isSignUp,
    required this.onVerificationComplete,
  }) : super(key: key);

  final String phoneNumber;
  final String verificationId;
  final bool isSignUp;
  final Future<String> Function(String smsCode) onVerificationComplete;

  @override
  State<PhoneVerificationDialog> createState() =>
      _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<PhoneVerificationDialog> {
  bool _isLoading = false;
  String _code = '';
  String _errorMessage = '';

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_phoneVerificationDialog');
  final FocusScopeNode _focusNode = FocusScopeNode();

  void _verifyCode() async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await widget.onVerificationComplete(_code);
      Navigator.of(context).pop(result);
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = _mapPhoneErrorToMessage(error);
      });
    }
  }

  void _resendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final store = StoreProvider.of<AppState>(context);
      final completer = Completer<String>();

      store.dispatch(SendPhoneVerificationCodeRequest(
        completer: completer,
        phoneNumber: widget.phoneNumber,
      ));

      await completer.future;
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = _mapPhoneErrorToMessage(error);
      });
    }
  }

  String _mapPhoneErrorToMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'The phone number is not valid.';
        case 'missing-phone-number':
          return 'The phone number is missing.';
        case 'quota-exceeded':
          return 'The phone verification quota has been exceeded.';
        case 'too-many-requests':
          return 'Too many verification attempts. Please try again later.';
        case 'invalid-app-credential':
          return 'Verification failed. Please try again.';
        case 'invalid-verification-code':
          return 'The verification code is incorrect.';
        case 'invalid-verification-id':
          return 'Verification session expired. Please try again.';
        default:
          return 'An error occurred during phone verification. Please try again.';
      }
    }
    return 'Error: $error';
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context)!;

    return AlertDialog(
      title: Text(widget.isSignUp
          ? localization.verifyPhoneNumber
          : localization.verifyPhoneNumber),
      content: _isLoading
          ? LoadingIndicator(height: 80)
          : AppForm(
              focusNode: _focusNode,
              formKey: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(localization.codeWasSentTo
                      .replaceFirst(':number', widget.phoneNumber)),
                  SizedBox(height: 20),
                  AppPinput(
                    onCompleted: (code) => _code = code,
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            localization.cancel.toUpperCase(),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _resendCode,
          child: Text(
            localization.resendCode.toUpperCase(),
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _verifyCode,
          child: Text(
            localization.verify.toUpperCase(),
          ),
        ),
      ],
    );
  }
}
