import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/profile/view/profile_shared_view.dart';
import 'package:flutter_boilerplate/ui/profile_operation/view/profile_operation_view_vm.dart';
// STARTER: import - do not remove comment

class ProfileOperationView extends StatefulWidget {
  const ProfileOperationView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final ProfileOperationViewVM viewModel;
  final bool isFilter;

  @override
  _ProfileOperationViewState createState() => new _ProfileOperationViewState();
}

class _ProfileOperationViewState extends State<ProfileOperationView> {
  @override
  Widget build(BuildContext context) {
    return ProfileSharedView(context, null, widget.viewModel, widget.isFilter);
  }
}
