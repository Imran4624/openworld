import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/auth/login_vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/ui/auth/shared_login_content.dart';

class LoginDialogView extends StatefulWidget {
  final VoidCallback? onClose;
  final Function()? onLoginSuccess;
  final bool isDialogLogin;

  const LoginDialogView({
    Key? key, 
    this.onClose, 
    this.onLoginSuccess,
    this.isDialogLogin = true,
  }) : super(key: key);

  @override
  State<LoginDialogView> createState() => _LoginDialogViewState();
}

class _LoginDialogViewState extends State<LoginDialogView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    return StoreConnector<AppState, LoginVM>(
      converter: LoginVM.fromStore,
      builder: (context, viewModel) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Center(
            child: Stack(
              children: [
                SharedLoginContent(
                  viewModel: viewModel,
                  onLoginSuccess: widget.onLoginSuccess,
                  onClose: widget.onClose,
                  isDialogLogin: widget.isDialogLogin,
                ),
                // Close button
                if (!store.state.isLoading)
                Positioned(
                  top: 18,
                  right: 18,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onClose != null) widget.onClose!();
                      // Remove automatic dialog closing - let parent component control this
                      // Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 