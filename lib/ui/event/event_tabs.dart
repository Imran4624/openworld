import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/project_config.dart';

class EventTabs extends StatefulWidget {
  const EventTabs({
    Key? key,
    required this.showMyEventsOnly,
    required this.onTabChanged,
  }) : super(key: key);

  final bool showMyEventsOnly;
  final Function(bool) onTabChanged;

  @override
  _EventTabsState createState() => _EventTabsState();
}

class _EventTabsState extends State<EventTabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  @override
  void didUpdateWidget(EventTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showMyEventsOnly != widget.showMyEventsOnly) {
        _tabController.index = widget.showMyEventsOnly ? 1 : 0;
      
    }
  }

  void _initTabController() {
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index == 1);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   
      return _buildOriginalUI();
  }

  

  Widget _buildOriginalUI() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'All Events'),
          Tab(text: 'My Events'),
        ],
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }

}
