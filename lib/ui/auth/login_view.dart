// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/app/app_specific/app_logo_widget.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_toggle_buttons.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/app/sms_verification.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Package imports:
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:flutter_boilerplate/.env.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/link_text.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/utils/colors.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:flutter_boilerplate/ui/app/forms/phone_input_field.dart';
import 'package:flutter_boilerplate/ui/auth/google_login_button.dart';
import 'package:flutter_boilerplate/ui/auth/shared_login_content.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final LoginVM viewModel;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_login');

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _secretController = TextEditingController();
  final _oneTimePasswordController = TextEditingController();
  final _tokenController = TextEditingController();
  final _hostOverrideController = TextEditingController();

  final _buttonController = RoundedLoadingButtonController();
  final _phoneController = TextEditingController();

  int _selectedTabIndex = 0;
  String _completePhoneNumber = '';

  static const String LOGIN_TYPE_EMAIL = 'email';
  static const String LOGIN_TYPE_GOOGLE = 'google';

  bool _isSelfHosted = false;
  bool _createAccount = false;
  bool _showInputFields = false; // New field for loopjam design

  bool _recoverPassword = false;
  bool _disable2FA = false;
  bool? _termsChecked = false;
  bool? _privacyChecked = false;
  bool _obscureText = true;
  bool _isLoading = false;

  bool get _isPhoneLogin => _selectedTabIndex == 1;

  @override
  void initState() {
    super.initState();

    // Set default tab to phone for LoopJam
    if (ProjectConfig.enablePhoneLogin()) {
      _selectedTabIndex = 1; // Phone tab
    }

    if (_urlController.text.isEmpty) {
      _urlController.text = widget.viewModel.authState.url;
    }

    SharedPreferences.getInstance().then((value) {
      _hostOverrideController.text =
          value.getString(kSharedPrefHostOverride) ?? '';

      final savedEmail = value.getString(kSharedPrefLastEmail);
      if (savedEmail != null && savedEmail.isNotEmpty) {
        _emailController.text = savedEmail;
      } else if (!kReleaseMode && Config.TEST_EMAIL.isNotEmpty) {
        _emailController.text = Config.TEST_EMAIL;
      }

      if (!kReleaseMode && Config.TEST_EMAIL.isNotEmpty) {
        _urlController.text = Config.TEST_URL;
        _secretController.text = Config.TEST_SECRET;
        _passwordController.text = Config.TEST_PASSWORD;
        _firstNameController.text = 'TEST';
        _lastNameController.text = 'TEST';
        _privacyChecked = true;
        _termsChecked = true;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _urlController.dispose();
    _secretController.dispose();
    _oneTimePasswordController.dispose();
    _tokenController.dispose();
    _hostOverrideController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitFormWithType(String type) {
    FocusScope.of(context).requestFocus(FocusNode());
    _buttonController.start();

    if (ProjectConfig.enablePhoneLogin() && _isPhoneLogin) {
      _submitPhoneForm();
    } else if (_createAccount) {
      _submitSignUpForm(type);
    } else {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        final message = _emailController.text.isEmpty
            ? 'Please enter your email'
            : 'Please enter your password';
        showToast(message);
        _buttonController.stop();
        return;
      }
      _submitLoginForm(type);
    }
  }

  void _submitForm() {
    _submitFormWithType(LOGIN_TYPE_EMAIL);
  }

  void _submitSignUpForm(String type) {
    final isValid = _formKey.currentState!.validate();
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    if (!isValid && type != LOGIN_TYPE_GOOGLE) {
      _buttonController.reset();
      return;
    }

    if (_createAccount &&
        ((ProjectConfig.getPrivacyPolicyUrl().isNotEmpty && !_termsChecked!) ||
            (ProjectConfig.getTermsAndConditionsUrl().isNotEmpty &&
                !_privacyChecked!))) {
      _buttonController.reset();

      final errorData = getErrorMessageAndTitle(
          _termsChecked!, _privacyChecked!, localization!);
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(errorData['title']!),
              content: Text(errorData['message']!),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    child: Text(AppLocalization.of(context)!.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            );
          });
      return;
    }

    final Completer<Null> completer = Completer<Null>();
    completer.future.then<Null>((_) {}).catchError((Object error) {
      setState(() {
        _buttonController.reset();
      });
    });

    if (type == LOGIN_TYPE_EMAIL) {
      _saveEmailForNextLogin();

      viewModel.onSignUpPressed(
        context,
        completer,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _submitLoginForm(String type) {
    final isValid = _formKey.currentState!.validate();
    final viewModel = widget.viewModel;

    if (!isValid) {
      _buttonController.reset();
      return;
    }

    final Completer<Null> completer = Completer<Null>();
    completer.future.then<Null>((_) {
      setState(() {
        if (_recoverPassword) {
          _recoverPassword = false;
          _disable2FA = false;
          _buttonController.reset();

          showDialog<AlertDialog>(
            context: context,
            builder: (BuildContext context) {
              final localization = AppLocalization.of(context);
              final title = localization!.emailSent;
              final content = localization.recoverPasswordEmailSent;
              return PointerInterceptor(
                child: AlertDialog(
                  semanticLabel: localization.recoverPasswordEmailSent,
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                    TextButton(
                        child: Text(localization.ok),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ),
              );
            },
          );
        }
      });
    }).catchError((Object error) {
      setState(() {
        _buttonController.reset();
      });
    });

    final url = _getUrl();

    if (type == LOGIN_TYPE_EMAIL) {
      if (_recoverPassword) {
        if (_disable2FA) {
          _buttonController.reset();
          _disable2FA = false;
          _recoverPassword = false;
          showDialog<void>(
            context: context,
            builder: (BuildContext context) => UserSmsVerification(
              email: _emailController.text.trim(),
            ),
          );
        } else {
          viewModel.onRecoverPressed(
            context,
            completer,
            email: _emailController.text.trim(),
            url: url,
            secret: _isSelfHosted ? _secretController.text : '',
          );
        }
      } else {
        _saveEmailForNextLogin();

        viewModel.onLoginPressed(
          context,
          completer,
          email: _emailController.text.trim(),
          password: _passwordController.text,
          url: url,
          secret: _isSelfHosted ? _secretController.text : '',
          oneTimePassword: _oneTimePasswordController.text,
        );
      }
    }
  }

  void _loginWithGoogle(String type) {
    setState(() {
      _isLoading = true;
    });

    final Completer<Null> completer = Completer<Null>();
    completer.future.then<Null>((_) {
      setState(() {
        _isLoading = false;
      });
    }).catchError((Object error) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalization.of(context)!.error),
            content: Text(error.toString()),
            actions: [
              TextButton(
                child: Text(AppLocalization.of(context)!.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });

    final url = _getUrl();
    widget.viewModel.onGoogleLoginPressed(context, completer,
        url: url,
        secret: _isSelfHosted ? _secretController.text : '',
        oneTimePassword: _oneTimePasswordController.text);
  }

  String _getUrl() {
    if (_isSelfHosted) {
      return _urlController.text;
    }

    final state = widget.viewModel.state;
    final authState = state.authState;

    if (authState.isLargeTest) {
      return kAppLargeTestUrl;
    } else if (authState.isStaging) {
      return kAppStagingUrl;
    } else if (authState.isStagingNet) {
      return kAppStagingNetUrl;
    } else {
      return kAppProductionUrl;
    }
  }

  void _saveEmailForNextLogin() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(kSharedPrefLastEmail, email);
      });
    }
  }

  void _submitPhoneForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    _buttonController.start();

    final phoneNumber = _completePhoneNumber.trim();
    final url = _getUrl();
    final secret = _isSelfHosted ? _secretController.text : '';

    if (phoneNumber.isEmpty) {
      _buttonController.reset();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalization.of(context)!.error),
          content: Text('Please enter a valid phone number'),
          actions: [
            TextButton(
              child: Text(AppLocalization.of(context)!.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    try {
      widget.viewModel
          .onPhoneAuthPressed(
        context,
        phoneNumber: phoneNumber,
        url: url,
        secret: secret,
      )
          .catchError((error) {
        // Reset button state on error
        _buttonController.reset();
        printL(' Phone auth error in view: $error');
      });
    } catch (error) {
      _buttonController.reset();
      printL(' Phone auth error in view: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final isDarkMode = state.prefState.enableDarkMode;
    final themeColors = AppTheme.getThemeColors(isDarkMode);

    final ThemeData themeData = Theme.of(context);
    final TextStyle? aboutTextStyle = themeData.textTheme.bodyMedium;
    final TextStyle linkStyle = themeData.textTheme.bodyMedium!
        .copyWith(color: convertHexStringToColor(kDefaultAccentColor));

    if (ProjectConfig.loginViewType() == LoginViewType.improved) {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SharedLoginContent(
                    viewModel: viewModel,
                    isDialogLogin: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLogoWidget(
                    textColor: state.authHeadingTextColor!,
                  ),
                  // const SizedBox(height: 40),
                  // Sign Up Card
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 380,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recoverPassword
                                  ? localization!.recoverPassword
                                  : _createAccount
                                      ? localization!.getStarted
                                      : localization!.welcomeBack,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: state.authHeadingTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (_createAccount || _recoverPassword)
                              Text(
                                _createAccount
                                    ? localization.signUpAccountLabel
                                    : localization.recoverPasswordLabel,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeColors.defaultColor,
                                ),
                              ),
                            const SizedBox(height: 16),

                            if (ProjectConfig.enablePhoneLogin() &&
                                !_recoverPassword &&
                                ProjectConfig.showSelectLoginMethodTabs()) ...[
                              RuledText(localization!.selectMethod),
                              Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 260),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: AppToggleButtons(
                                      tabLabels: [
                                        'Email',
                                        'Phone',
                                      ],
                                      selectedIndex: _selectedTabIndex,
                                      onTabChanged: (index) {
                                        setState(() {
                                          _selectedTabIndex = index;
                                          _createAccount = false;
                                          _recoverPassword = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            _isPhoneLogin
                                ? Column(
                                    children: [
                                      PhoneInputField(
                                        autofocus: true,
                                        onChanged: (phone) {
                                          _completePhoneNumber =
                                              phone.completeNumber;
                                        },
                                        validator: (value) => value == null ||
                                                value.number.isEmpty
                                            ? localization.pleaseEnterAValue
                                            : null,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: localization.email,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (!_recoverPassword)
                                        TextField(
                                          obscureText: _obscureText,
                                          controller: _passwordController,
                                          decoration: InputDecoration(
                                            labelText: localization.password,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureText
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });
                                              },
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                            const SizedBox(height: 16),

                            const SizedBox(height: 16),
                            if (_createAccount && !_recoverPassword)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 8),
                                child: Column(
                                  children: <Widget>[
                                    if (ProjectConfig
                                            .getTermsAndConditionsUrl() !=
                                        '')
                                      CheckboxListTile(
                                        onChanged: (value) => setState(
                                            () => _termsChecked = value),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: convertHexStringToColor(
                                            kDefaultAccentColor),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        value: _termsChecked,
                                        title: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                style: aboutTextStyle,
                                                text: localization.iAgreeToThe +
                                                    ' ',
                                              ),
                                              LinkTextSpan(
                                                style: linkStyle,
                                                url: ProjectConfig
                                                    .getTermsAndConditionsUrl(),
                                                text:
                                                    localization.termsOfService,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (ProjectConfig.getPrivacyPolicyUrl() !=
                                        '')
                                      CheckboxListTile(
                                        onChanged: (value) => setState(
                                            () => _privacyChecked = value),
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        activeColor: convertHexStringToColor(
                                            kDefaultAccentColor),
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: const VisualDensity(
                                            horizontal: -4, vertical: -4),
                                        value: _privacyChecked,
                                        title: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                style: aboutTextStyle,
                                                text: localization.iAgreeToThe +
                                                    ' ',
                                              ),
                                              LinkTextSpan(
                                                style: linkStyle,
                                                url: ProjectConfig
                                                    .getPrivacyPolicyUrl(),
                                                text:
                                                    localization.privacyPolicy,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            RoundedLoadingButton(
                              height: 40,
                              borderRadius: 10,
                              controller: _buttonController,
                              color: themeColors.primary,
                              onPressed: () {
                                if (ProjectConfig.enablePhoneLogin() &&
                                    _selectedTabIndex == 1) {
                                  _submitPhoneForm();
                                } else {
                                  _submitFormWithType(LOGIN_TYPE_EMAIL);
                                }
                              },
                              child: Center(
                                child: Text(
                                  (ProjectConfig.enablePhoneLogin() &&
                                          _selectedTabIndex == 1)
                                      ? _createAccount
                                          ? 'Signup With Phone'
                                          : 'Login With Phone'
                                      : _recoverPassword
                                          ? localization.sendLink
                                          : _createAccount
                                              ? localization.emailSignUp
                                              : localization.emailSignIn,
                                  style:  TextStyle(color: AppTheme.dark.text,)
                                ),
                              ),
                            ),
                            if (!_recoverPassword &&
                                ProjectConfig.allowLoginTypes
                                    .contains(LoginType.google))
                              const SizedBox(height: 16),
                            if (!_recoverPassword &&
                                ProjectConfig.allowLoginTypes
                                    .contains(LoginType.google))
                              Center(
                                child: Text(
                                  localization.or,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeColors.defaultColor,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            // Google login buttons
                            if (!_recoverPassword &&
                                ProjectConfig.allowLoginTypes
                                    .contains(LoginType.google))
                              GoogleLoginButton(
                                parentContext: context,
                                viewModel: viewModel,
                              ),
                            const SizedBox(height: 16),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _createAccount || _recoverPassword
                                        ? localization.alreadyHaveAccount
                                        : localization.notHaveAccount,
                                    style: TextStyle(
                                      color: themeColors.text,
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                          left:
                                              4), // Removes padding around the button
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _createAccount = _recoverPassword
                                            ? false
                                            : !_createAccount;
                                        _recoverPassword = false;
                                      });
                                    },
                                    child: Text(
                                      _createAccount || _recoverPassword
                                          ? localization.loginLabel
                                          : localization.registerLabel,
                                      style: TextStyle(
                                        color: state.linkColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Recover password
                            if (!_createAccount && !_recoverPassword)
                              Center(
                                child: SizedBox(
                                  width: KButtonWidth,
                                  height: KButtonHeight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _recoverPassword = true;
                                        _createAccount = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          Theme.of(context).hoverColor,
                                      foregroundColor:
                                          state.authHeadingTextColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    label: Text(localization.recoverPassword),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}

class RuledText extends StatelessWidget {
  const RuledText(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding =
        calculateLayout(context) == AppLayout.desktop ? 40 : 16;

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 4,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.dark.defaultColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text!,
              style: TextStyle(
                color: AppTheme.dark.defaultColor,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.dark.defaultColor,
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, String> getErrorMessageAndTitle(
    bool termsChecked, bool privacyChecked, AppLocalization localization) {
  if (!termsChecked && !privacyChecked) {
    return {
      'title': localization.bothTermsAndPrivacy,
      'message': localization.pleaseAgreeToTermsAndPrivacy,
    };
  } else if (!termsChecked) {
    return {
      'title': localization.termsOfService,
      'message': localization.pleaseAgreeToTerms,
    };
  } else if (!privacyChecked) {
    return {
      'title': localization.privacyPolicy,
      'message': localization.pleaseAgreeToPrivacy,
    };
  } else {
    return {
      'title': '',
      'message': '',
    };
  }
}
