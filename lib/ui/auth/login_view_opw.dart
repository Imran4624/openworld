import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class LoginViewOpw extends StatefulWidget {
  final LoginVM viewModel;
  const LoginViewOpw({super.key, required this.viewModel});

  @override
  State<LoginViewOpw> createState() => _LoginViewOpwState();
}

class _LoginViewOpwState extends State<LoginViewOpw> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_login');
  bool _obscureText = true;
  bool _createAccount = false;

  @override
  void initState() {
    super.initState();
    final emailLinkAuthEmail = widget.viewModel.authState.emailLinkAuthEmail;
    if (emailLinkAuthEmail.isNotEmpty) {
      _emailController.text = emailLinkAuthEmail;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onGoogleLogin() {
    final Completer<Null> completer = Completer<Null>();
    completer.future.then<Null>((_) {}).catchError((Object error) {
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

    widget.viewModel.onGoogleLoginPressed(
      context,
      completer,
      url: '',
      secret: '',
      oneTimePassword: '',
    );
  }

  void _submitForm() {
    FocusScope.of(context).requestFocus(FocusNode());

    final isEmailLinkFromUrl = widget.viewModel.authState.isEmailLinkAuth;
    final isLinkInEmailAllowed = ProjectConfig.allowLoginTypes.contains(LoginType.linkInEmail);
    final isEmailLinkAuth = isEmailLinkFromUrl || (isLinkInEmailAllowed && !_createAccount);
    
    if (_emailController.text.isEmpty) {
      showToast('Please enter your email');
      return;
    }
    
    if (!isEmailLinkAuth && _passwordController.text.isEmpty) {
      showToast('Please enter your password');
      return;
    }

    final Completer<Null> completer = Completer<Null>();
    completer.future.then<Null>((_) {}).catchError((Object error) {
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

    if (_createAccount) {
      widget.viewModel.onSignUpPressed(
        context,
        completer,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } else {
      if (isEmailLinkAuth) {
        widget.viewModel.onSendEmailLinkPressed(
          context,
          completer,
          email: _emailController.text.trim(),
        );
      } else {
        widget.viewModel.onLoginPressed(
          context,
          completer,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          url: '',
          secret: '',
          oneTimePassword: '',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmailLinkFromUrl = widget.viewModel.authState.isEmailLinkAuth;
    final isLinkInEmailAllowed = ProjectConfig.allowLoginTypes.contains(LoginType.linkInEmail);
    final isEmailLinkAuth = isEmailLinkFromUrl || (isLinkInEmailAllowed && !_createAccount);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            const SizedBox(height: 30.0,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                const Text(
                  'Hey!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Start by sharing your email',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Email', style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'SF Pro Text')),
                const SizedBox(height: 6),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.07),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (!isEmailLinkAuth) ...[
                  const SizedBox(height: 16),
                  const Text('Password', style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'SF Pro Text')),
                  const SizedBox(height: 6),
                  TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.07),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                      onPressed: () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: Text(
                      _createAccount 
                        ? 'GET STARTED' 
                        : isEmailLinkAuth 
                          ? 'SEND LINK'
                          : 'LOGIN', 
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text')
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(color: Colors.white54)),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: _onGoogleLogin,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/opw/google.png',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if(!isEmailLinkAuth )
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _createAccount
                            ? 'Already have an account?'
                            : "Don't have an account?",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.only(left: 4),
                        ),
                        onPressed: () {
                          setState(() {
                            _createAccount = !_createAccount;
                          });
                        },
                        child: Text(
                          _createAccount ? 'Login' : 'Create',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}
