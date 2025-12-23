// Flutter imports:

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';

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
import 'package:redux/src/store.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final DashboardVM viewModel;

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
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
    //final entityType = state.dashboardUIState.selectedEntityType;

    [
      EntityType.user,
    ].forEach((entityType) {
      if (company.isModuleEnabled(entityType)) {
        _tabs.add(entityType);
      }
    });

    //final index = _tabs.contains(entityType) ? _tabs.indexOf(entityType) : 0;
    int mainTabCount = 2;

    if (state.prefState.isMobile) {
      mainTabCount += _tabs.length;
    }

    _mainTabController = TabController(vsync: this, length: mainTabCount);
    _sideTabController =
        TabController(vsync: this, length: _tabs.length, initialIndex: 0)
          ..addListener(onTabListener);
    _scrollController = ScrollController(
        // initialScrollOffset: (index > 0 ? index + 1 : 0) *
        // (kIsWeb ? kDashboardPanelHeightWeb : kDashboardPanelHeight)
        )
      ..addListener(onScrollListener);

    // final companyName = state.company.settings.name ?? '';
    // if (!state.isDemo &&
    //     state.userCompany.isAdmin &&
    //     (companyName.isEmpty || companyName == 'Untitled Company') &&
    //     state.company.isOld) {
    //   WidgetsBinding.instance.addPostFrameCallback((duration) {
    //     showDialog<void>(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           return SettingsWizard(
    //             user: state.user,
    //             company: state.company,
    //           );
    //         });
    //   });
    // }
  }

  void onScrollListener() {
    if (isMobile(context)) {
      return;
    }

    /*
    final offset = _scrollController.position.pixels;
    int offsetIndex = ((offset + 120) /
            (kIsWeb ? kDashboardPanelHeightWeb : kDashboardPanelHeight))
        .floor();

    if (offsetIndex > 0) {
      offsetIndex--;
    }

    if (_sideTabController.index != offsetIndex && offsetIndex < _tabs.length) {
      _sideTabController.removeListener(onTabListener);
      _sideTabController.index = offsetIndex;
      _sideTabController.addListener(onTabListener);

      widget.viewModel.onEntityTypeChanged(_tabs[offsetIndex]);
    }
    */
  }

  void onTabListener() {
    /*
    if (isMobile(context) || _mainTabController.index != 0) {
      return;
    }

    final index = _sideTabController.index;
    final offset = _scrollController.position.pixels;
    final offsetIndex = ((offset + 120) /
            (kIsWeb ? kDashboardPanelHeightWeb : kDashboardPanelHeight))
        .floor();

    if (index != offsetIndex) {
      _scrollController.jumpTo((index.toDouble() *
              (kIsWeb ? kDashboardPanelHeightWeb : kDashboardPanelHeight)) +
          1);
      widget.viewModel.onEntityTypeChanged(_tabs[index]);
    }
    */
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _sideTabController
      ..removeListener(onTabListener)
      ..dispose();
    _scrollController
      ..removeListener(onScrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;

    final List<DemoTab> demos = [
      DemoTab(
        icon: Icons.description,
        title: 'Dynamic Fields',
        description: 'Demo the OPW dynamic fields configuration',
        type: QuestionType.opw,
      ),
    ];

    return DefaultTabController(
      length: demos.length,
      initialIndex: state.dynamicFieldState.selectedTabIndex,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: _buildLeading(context, state, localization),
          title: const Text('Dynamic Fields Demo'),
          bottom: TabBar(
            isScrollable: true,
            onTap: (index) {
              store.dispatch(UpdateSelectedTab(index));
            },
            tabs: demos
                .map((demo) => Tab(
                      icon: Icon(demo.icon),
                      text: demo.title,
                    ))
                .toList(),
          ),
          actions: _buildActions(context, state, localization),
        ),
        drawer: _buildDrawer(context, state),
        endDrawer: _buildEndDrawer(context, state),
        body: TabBarView(
          children:
              demos.map((demo) => _buildDemoContent(demo, store)).toList(),
        ),
      ),
    );
  }

  Widget _buildDemoContent(DemoTab demo, Store<AppState> store) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            demo.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(demo.description),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () =>
                    store.dispatch(ViewDynamicFields(demo.type, isEdit: false)),
                icon: const Icon(Icons.add),
                label: const Text('Create New'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () =>
                    store.dispatch(ViewDynamicFields(demo.type, isEdit: true)),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Existing'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLeading(
      BuildContext context, AppState state, AppLocalization? localization) {
    if (isMobile(context) || state.prefState.isMenuFloated) {
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

class DemoTab {
  final IconData icon;
  final String title;
  final String description;
  final QuestionType type;

  DemoTab({
    required this.icon,
    required this.title,
    required this.description,
    required this.type,
  });

  bool get showCreateEditButtons => true;
}
