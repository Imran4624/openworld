import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_shared_view.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_opw.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_view_vm.dart';

// Import the profile operation actions

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final ProfileViewVM viewModel;
  final bool isFilter;

  @override
  _ProfileViewState createState() => new _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    if (ProjectConfig.appType == AppType.opw) {
      return ProfileViewOpw(context, widget.viewModel, null, widget.isFilter);
    }
    return ProfileSharedView(context, widget.viewModel, null, widget.isFilter);
  }
}
