// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_actions.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/ui/pref_state.dart';
import 'package:flutter_boilerplate/ui/app/history_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/app/menu_drawer_vm.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';

class DashboardScreenLM extends StatefulWidget {
  const DashboardScreenLM({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DashboardVM viewModel;

  @override
  _DashboardScreenLMState createState() => _DashboardScreenLMState();
}

class _DashboardScreenLMState extends State<DashboardScreenLM>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _sideTabController;
  late ScrollController _scrollController;
  final List<EntityType> _tabs = [];

  @override
  void initState() {
    super.initState();

    final state = widget.viewModel.state;
    final company = state.company;

    [
      EntityType.user,
    ].forEach((entityType) {
      if (company.isModuleEnabled(entityType)) {
        _tabs.add(entityType);
      }
    });

    int mainTabCount = 2;

    if (state.prefState.isMobile) {
      mainTabCount += _tabs.length;
    }

    _mainTabController = TabController(vsync: this, length: mainTabCount);
    _sideTabController =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _sideTabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: _buildLeading(context, state, localization),
        title: const Text('Dashboard'),
        actions: _buildActions(context, state, localization),
      ),
      drawer: _buildDrawer(context, state),
      endDrawer: _buildEndDrawer(context, state),
      body: Container(), 
    );
  }

  Widget _buildLeading(
      BuildContext context, AppState state, AppLocalization? localization) {
    if ((isMobile(context) || state.prefState.isMenuFloated) && ProjectConfig.showMenuDrawer) {
      return Builder(
        builder: (context) => IconButton(
          tooltip: localization!.menuSidebar,
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  List<Widget> _buildActions(
      BuildContext context, AppState state, AppLocalization? localization) {
    return [
      if ((isMobile(context) || !state.prefState.isHistoryVisible) &&
          ProjectConfig.showActivityLog)
        Builder(
          builder: (context) => IconButton(
            tooltip:
                state.prefState.enableTooltips ? localization!.history : null,
            icon: const Icon(Icons.history),
            onPressed: () => _handleHistoryPress(context, state),
          ),
        ),
    ];
  }

  Widget? _buildDrawer(BuildContext context, AppState state) {
    return (isMobile(context) || state.prefState.isMenuFloated)
        ? MenuDrawerBuilder()
        : null;
  }

  Widget? _buildEndDrawer(BuildContext context, AppState state) {
    return (isMobile(context) || state.prefState.isHistoryFloated) &&
            ProjectConfig.showActivityLog
        ? HistoryDrawerBuilder()
        : null;
  }

  void _handleHistoryPress(BuildContext context, AppState state) {
    if (isMobile(context) || state.prefState.isHistoryFloated) {
      Scaffold.of(context).openEndDrawer();
    } else {
      StoreProvider.of<AppState>(context)
          .dispatch(UpdateUserPreferences(sidebar: AppSidebar.history));
    }
  }
}