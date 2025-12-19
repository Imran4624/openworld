import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_search_detailed_screen.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_fields_display_value_for_edit.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/utils/platforms.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SearchOverviewScreen extends StatefulWidget {
  const SearchOverviewScreen({Key? key}) : super(key: key);

  static const String route = '/profile/search';

  @override
  _SearchOverviewScreenState createState() => _SearchOverviewScreenState();
}

class _SearchOverviewScreenState extends State<SearchOverviewScreen>
    with SingleTickerProviderStateMixin {
  late List<QuestionGroupModel> _questionGroups;
  Map<String, dynamic> _searchCriteria = {};
  bool _isLoading = true;
  bool _isInitialized = false;
  bool _isAdmin = false;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _loadDataFromStore();
      _isInitialized = true;
    }
  }

  void _loadDataFromStore() {
    final store = StoreProvider.of<AppState>(context);
    _questionGroups = store.state.dynamicFieldState.questionGroups.toList();
    final currentFilterAnswers =
        store.state.profileState.filter.dynamicFieldsFilters;
    Map<String, dynamic> filterMap = {};

    currentFilterAnswers.forEach((key, value) {
      filterMap[key] = value;
    });

    setState(() {
      _searchCriteria = filterMap;
      _isLoading = false;
      _isAdmin = store.state.profileState.loggedInUserProfile.isAdmin;
    });

    printL('Loaded search criteria from store: $_searchCriteria');
  }

  Future<void> _editSearchField(
      BuildContext context, QuestionModel question) async {
    dynamic result;
    if (!isMobile(context)) {
      result = await showDialog(
        context: context,
        builder: (context) => SearchDetailScreen(
          question: question,
          initialValue: _searchCriteria[question.id],
        ),
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchDetailScreen(
            question: question,
            initialValue: _searchCriteria[question.id],
          ),
        ),
      );
    }

    if (result != null) {
      setState(() {
        if (result == '') {
          _searchCriteria.remove(question.id);
        } else {
          _searchCriteria[question.id] = result;
        }
      });

      printL('Updated search criteria after edit: $_searchCriteria');
    }
  }

  void _performSearch() {
    final store = StoreProvider.of<AppState>(context);
    final currentFilter = store.state.profileState.filter;

    final dynamicFieldsFilters =
        BuiltMap<String, dynamic>.from(_searchCriteria);

    final updatedFilter = currentFilter.rebuild((b) {
      b.dynamicFieldsFilters.replace(dynamicFieldsFilters);
    });

    store.dispatch(UpdateProfileFilter(updatedFilter));

    store.dispatch(ViewProfileList());
  }

  void _clearAllFilters() {
    setState(() {
      _searchCriteria = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Filters'),
        leading: isMobile(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(ViewProfileList());
                },
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  final store = StoreProvider.of<AppState>(context);
                  store.dispatch(ViewProfileList());
                },
              ),
        actions: [
          if (_searchCriteria.isNotEmpty)
            if (_searchCriteria.isNotEmpty)
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: _clearAllFilters,
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).appBarTheme.backgroundColor,
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Basic Filters'),
                Tab(text: 'Advanced Filters'),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    // Basic Filters Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildSearchFieldsByGroup(
                              SearchableType.ShowInBasicSearch),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),

                    // Advanced Filters Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildSearchFieldsByGroup(
                              SearchableType.ShowInAdvanceSearch),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [Colors.transparent, Colors.white],
                              stops: const [0.0, 0.3],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: _performSearch,
                      child: const Text(
                        'Search',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSearchFieldsByGroup(SearchableType type) {
    List<Widget> widgets = [];

    for (var group in _questionGroups) {
      List<QuestionModel> groupQuestions = group.questions
          .where((question) =>
              question.searchable != SearchableType.None &&
              question.searchable == type &&
              (question.id != DynamicFieldsConstants.gender || _isAdmin))
          .toList();

      if (groupQuestions.isEmpty) {
        continue;
      }

      groupQuestions.sort((a, b) {
        if (a.inputOptions != null &&
            a.inputOptions['searchOrder'] != null &&
            (b.inputOptions == null || b.inputOptions['searchOrder'] == null)) {
          return -1;
        }
        if (b.inputOptions != null &&
            b.inputOptions['searchOrder'] != null &&
            (a.inputOptions == null || a.inputOptions['searchOrder'] == null)) {
          return 1;
        }
        if (a.inputOptions != null &&
            a.inputOptions['searchOrder'] != null &&
            b.inputOptions != null &&
            b.inputOptions['searchOrder'] != null) {
          return (a.inputOptions['searchOrder'] as int)
              .compareTo(b.inputOptions['searchOrder'] as int);
        }
        return 0;
      });

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Text(
            group.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );

      widgets.addAll(
        groupQuestions.map((question) {
          final displayValue = getDisplayValueForEditOverviewScreen(
            question,
            _searchCriteria[question.id],
          );

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Card(
              child: ListTile(
                title: Text(question.label),
                subtitle: Text(displayValue),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchCriteria.containsKey(question.id))
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchCriteria.remove(question.id);
                          });
                        },
                      ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => _editSearchField(context, question),
              ),
            ),
          );
        }).toList(),
      );
    }

    return widgets.isEmpty ? [const SizedBox.shrink()] : widgets;
  }
}
