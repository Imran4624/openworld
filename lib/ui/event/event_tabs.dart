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
  final bool _isLoopjam = ProjectConfig.currentAppType == AppType.loopjam;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  @override
  void didUpdateWidget(EventTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isLoopjam) {
       _tabController.index = widget.showMyEventsOnly ? 1 : 0;
    }
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
        if (_isLoopjam) {
          widget.onTabChanged(_tabController.index == 1);
        } else {
          widget.onTabChanged(_tabController.index == 1);
        }
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
    if (_isLoopjam) {
      return _buildLoopjamUI();
    } else {
      return _buildOriginalUI();
    }
  }

  Widget _buildLoopjamUI() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Events',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16.0,
            ),
          ),
          const Spacer(),
          Container(
            child: Row(
              children: [
                _buildCustomTab('Own', 0),
                const SizedBox(width: 24.0),
                _buildCustomTab('Shared', 1),
                const SizedBox(width: 24.0),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildCustomTab(String text, int index) {
    final isSelected = _tabController.index == index;
    
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 1.0,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
