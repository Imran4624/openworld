import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/ui/app/forms/app_toggle_buttons.dart';
import 'package:flutter_boilerplate/ui/app/forms/phone_input_field.dart';
import 'package:flutter_boilerplate/ui/auth/google_login_button.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SharedLoginContent extends StatefulWidget {
  final LoginVM viewModel;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onClose;
  final bool isDialogLogin;

  const SharedLoginContent({
    Key? key,
    required this.viewModel,
    this.onLoginSuccess,
    this.onClose,
    this.isDialogLogin = false,
  }) : super(key: key);

  @override
  State<SharedLoginContent> createState() => _SharedLoginContentState();
}

class _SharedLoginContentState extends State<SharedLoginContent> {
  bool showInputFields = false;
  int _selectedTabIndex = 0; // 0 for email, 1 for phone
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _buttonController = RoundedLoadingButtonController();
  bool _obscureText = true;
  String _completePhoneNumber = '';
  bool _createAccount = false;

  bool get _isPhoneLogin => _selectedTabIndex == 1;

  @override
  void initState() {
    super.initState();
    
    // Set default tab to phone for LoopJam if phone login is enabled
    if (ProjectConfig.enablePhoneLogin()) {
      _selectedTabIndex = 1; // Phone tab
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    _buttonController.start();

    if (ProjectConfig.enablePhoneLogin() && _isPhoneLogin) {
      _submitPhoneForm();
    } else {
      _submitEmailForm();
    }
  }

  void _submitPhoneForm() {
    final phoneNumber = _completePhoneNumber.trim();
    final localization = AppLocalization.of(context);

    if (phoneNumber.isEmpty) {
      _buttonController.reset();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(localization!.error),
          content: const Text('Please enter a valid phone number'),
          actions: [
            TextButton(
              child: Text(localization.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final completer = widget.viewModel.onPhoneAuthPressed(
      context, 
      phoneNumber: phoneNumber, 
      isDialogLogin: widget.isDialogLogin
    );
    
    completer.future.then((_) {
      // Remove automatic dialog closing - let parent component control this
      // if (widget.isDialogLogin) {
      //   Navigator.of(context).pop();
      // }
      if (widget.onLoginSuccess != null) widget.onLoginSuccess!();
    }).catchError((error) {
      _buttonController.reset();
      printL('Phone login error: $error');
    });
  }

  void _submitEmailForm() {
    final localization = AppLocalization.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _buttonController.reset();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(localization!.error),
          content: const Text('Please enter both email and password'),
          actions: [
            TextButton(
              child: Text(localization.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final completer = Completer<Null>();
    completer.future.then((_) {
      // Remove automatic dialog closing - let parent component control this
      // if (widget.isDialogLogin) {
      //   Navigator.of(context).pop(); 
      // }
      if (widget.onLoginSuccess != null) widget.onLoginSuccess!();
    }).catchError((error) {
      _buttonController.reset();
      printL('Email login error: $error');
    });

    widget.viewModel.onLoginPressed(
      context,
      completer,
      email: email,
      password: password,
      url: '',
      secret: '',
      oneTimePassword: '',
      isDialogLogin: widget.isDialogLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final appTheme =
        AppTheme.getThemeColors(store.state.prefState.enableDarkMode);

    if (store.state.isLoading) {
      return Container(
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
          color: appTheme.transparent,
        ),
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ),
        ),
      );
    }

    return Container(
      width: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 32),
            decoration: BoxDecoration(
              color: appTheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save and manage your event.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: appTheme.iconLight,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to continue and access your dashboard.',
                  style: TextStyle(
                    fontSize: 16,
                    color:  appTheme.iconLight.withOpacity(0.85),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          // White content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
            decoration:  BoxDecoration(
              color:  appTheme.iconLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!showInputFields) ...[
                  // Google button
                  if (ProjectConfig.allowLoginTypes.contains(LoginType.google))
                    GoogleLoginButton(
                      parentContext: context,
                      viewModel: widget.viewModel,
                      onLoginSuccess: widget.onLoginSuccess,
                      borderColor: appTheme.defaultColor,
                      isDialogLogin: widget.isDialogLogin,
                    ),
                  if (ProjectConfig.allowLoginTypes.contains(LoginType.google))
                    const SizedBox(height: 16),
                  // Apple button
                  if (ProjectConfig.allowLoginTypes.contains(LoginType.apple))
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon:  Icon(Icons.apple, color:  appTheme.iconLight, size: 24),
                        label:  Text(
                          'Continue with Apple',
                          style: TextStyle(fontSize: 16, color:  appTheme.iconLight),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: appTheme.text,
                          side: BorderSide.none,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: appTheme.transparent,
                        ),
                        onPressed: () async {
                          final completer = Completer<Null>();
                          widget.viewModel.onAppleLoginPressed(
                            context, 
                            completer, 
                            isDialogLogin: widget.isDialogLogin
                          );
                          completer.future.then((_) {
                            // Remove automatic dialog closing - let parent component control this
                            // if (widget.isDialogLogin) {
                            //   Navigator.of(context).pop();
                            // }
                            if (widget.onLoginSuccess != null) widget.onLoginSuccess!();
                          }).catchError((error) {
                            printL('Apple login error: $error');
                          });
                        },
                      ),
                    ),
                  if (ProjectConfig.allowLoginTypes.contains(LoginType.apple))
                    const SizedBox(height: 24),
                  // Or divider
                  if ((ProjectConfig.allowLoginTypes.contains(LoginType.google) || 
                       ProjectConfig.allowLoginTypes.contains(LoginType.apple)) &&
                      ProjectConfig.allowLoginTypes.contains(LoginType.phone))
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: Text(
                          'Or',
                          style: TextStyle(color: appTheme.defaultColor, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  if ((ProjectConfig.allowLoginTypes.contains(LoginType.google) || 
                       ProjectConfig.allowLoginTypes.contains(LoginType.apple)) &&
                      ProjectConfig.allowLoginTypes.contains(LoginType.phone))
                    const SizedBox(height: 16),
                  // Continue with phone
                  if (ProjectConfig.allowLoginTypes.contains(LoginType.phone))
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showInputFields = true;
                        });
                      },
                      child: Text(
                        'Continue with phone',
                        style: TextStyle(
                          color: appTheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ] else ...[
                  // Show login method tabs if phone login is enabled and both email and phone are allowed
                  if (ProjectConfig.enablePhoneLogin() && 
                      ProjectConfig.showSelectLoginMethodTabs() &&
                      ProjectConfig.allowLoginTypes.contains(LoginType.email) &&
                      ProjectConfig.allowLoginTypes.contains(LoginType.phone)) ...[
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 260),
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
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  // Show input fields based on selected tab
                  if (_isPhoneLogin) ...[
                    if (ProjectConfig.allowLoginTypes.contains(LoginType.phone))
                      PhoneInputField(
                        autofocus: true,
                        onChanged: (phone) {
                          _completePhoneNumber = phone.completeNumber;
                        },
                        validator: (value) => value == null || value.number.isEmpty
                            ? localization!.pleaseEnterAValue
                            : null,
                      ),
                  ] else ...[
                    if (ProjectConfig.allowLoginTypes.contains(LoginType.email)) ...[
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: localization!.email,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: localization.password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  if ((_isPhoneLogin && ProjectConfig.allowLoginTypes.contains(LoginType.phone)) ||
                      (!_isPhoneLogin && ProjectConfig.allowLoginTypes.contains(LoginType.email)))
                    RoundedLoadingButton(
                      height: 40,
                      borderRadius: 10,
                      controller: _buttonController,
                      color: appTheme.primary,
                      onPressed: _submitForm,
                      child: Center(
                        child: Text(
                          (ProjectConfig.enablePhoneLogin() && _isPhoneLogin)
                              ? _createAccount 
                                  ? 'Signup With Phone'
                                  : 'Login With Phone'
                              : _createAccount
                                  ? localization!.emailSignUp
                                  : localization!.emailSignIn,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showInputFields = false;
                      });
                    },
                    child: Text('Back', style: TextStyle(color: appTheme.text)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
} 