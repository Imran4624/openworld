import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/profile_operation/profile_operation_state.dart';

class ProfileOperationTabs extends StatefulWidget {
  const ProfileOperationTabs({
    Key? key,
    required this.activeTab,
    required this.onTabChanged,
  }) : super(key: key);

  final String activeTab;
  final Function(String) onTabChanged;

  @override
  _ProfileOperationTabsState createState() => _ProfileOperationTabsState();
}

class _ProfileOperationTabsState extends State<ProfileOperationTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final tabs =
        ProfileOperationTab.getValues(ProjectConfig.canUserPassProfiles);
    final initialIndex = tabs.indexOf(widget.activeTab);
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: initialIndex >= 0 ? initialIndex : 0,
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void didUpdateWidget(ProfileOperationTabs oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.activeTab != widget.activeTab) {
      final tabs =
          ProfileOperationTab.getValues(ProjectConfig.canUserPassProfiles);
      final index = tabs.indexOf(widget.activeTab);
      if (index >= 0 && index != _tabController.index) {
        _tabController.animateTo(index);
      }
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      return;
    }

    final tabs =
        ProfileOperationTab.getValues(ProjectConfig.canUserPassProfiles);
    if (_tabController.index >= 0 && _tabController.index < tabs.length) {
      widget.onTabChanged(tabs[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs =
        ProfileOperationTab.getValues(ProjectConfig.canUserPassProfiles);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: tabs
            .map((tabName) => _buildTab(tabName, tabName == widget.activeTab))
            .toList(),
      ),
    );
  }

  Widget _buildTab(String tabName, bool isActive) {
    IconData icon;

    switch (tabName) {
      case ProfileOperationTab.likes:
        icon = isActive ? Icons.favorite : Icons.favorite_border;
        break;
      case ProfileOperationTab.likedMe:
        icon = isActive ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined;
        break;
      case ProfileOperationTab.matches:
        icon = isActive ? Icons.check_circle : Icons.check_circle_outline;
        break;
      case ProfileOperationTab.passes:
        icon = isActive ? Icons.close : Icons.close_outlined;
        break;
      // case ProfileOperationTab.comments:
      //   icon = isActive ? Icons.chat_bubble : Icons.chat_bubble_outline;
      //   break;
      default:
        icon = Icons.list;
    }

    return Tab(
      icon: Icon(icon),
      text: ProjectConfig.profileOperationTabName(tabName),
    );
  }
}
