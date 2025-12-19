import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/mock/workout_plans.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/data/models/workout_model.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/ui/app/list_scaffold.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'workout_screen_vm.dart';
import 'calendar_view.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({
    super.key,
    required this.viewModel,
  });

  static const String route = '/workout';

  final WorkoutScreenVM viewModel;

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> with SingleTickerProviderStateMixin {
  int? selectedPlanId;
  bool _isCalendarView = false;
  late TabController _tabController;
  bool _historyLoaded = false; 
  LatLng? currentPosition;
  LatLng? startPosition;
  List<LatLng> trackPoints = [];
  Timer? _locationTimer;
  bool locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.index == 1 && !_historyLoaded) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadWorkouts(isRefresh: true));
      setState(() {
        _historyLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final localization = AppLocalization.of(context)!;
    final workoutMap = widget.viewModel.workoutMap.toMap();

    return ListScaffold(
      entityType: EntityType.workout,
      appBarTitle: Row(
        children: [
          if (selectedPlanId != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  selectedPlanId = null;
                });
              },
            ),
          Text(
            selectedPlanId == null ? 'Training Plans' : 'Plan Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
      appBarActions: [
        if (selectedPlanId != null)
          IconButton(
            icon: Icon(_isCalendarView ? Icons.list : Icons.calendar_today),
            onPressed: () {
              setState(() {
                _isCalendarView = !_isCalendarView;
              });
            },
          ),
      ],
      body: selectedPlanId == null
          ? Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Plans'),
                    Tab(text: 'History'),
                  ],
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Theme.of(context).primaryColor,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      WorkoutPlanScreen(
                        workoutState: workoutMap,
                        selectedPlanId: selectedPlanId,
                        onPlanSelected: (planId) {
                          setState(() {
                            selectedPlanId = planId;
                          });
                        },
                        isCalendarView: _isCalendarView,
                      ),
                      _buildHistoryTab(),
                    ],
                  ),
                ),
              ],
            )
          : WorkoutPlanScreen(
              workoutState: workoutMap,
              selectedPlanId: selectedPlanId,
              onPlanSelected: (planId) {
                setState(() {
                  selectedPlanId = planId;
                });
              },
              isCalendarView: _isCalendarView,
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'workout_fab',
        backgroundColor: Theme.of(context).primaryColorDark,
        onPressed: () {
          store.dispatch(ViewWorkout());
        },
        tooltip: localization.newWorkout,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    final store = StoreProvider.of<AppState>(context);
    final allWorkouts = store.state.workoutState.map.values.toList();
    
    if (allWorkouts.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No workout history yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some workouts to see them here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  allWorkouts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  return RefreshIndicator(
    onRefresh: () async {
      await store.dispatch(LoadWorkout());
    },
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allWorkouts.length,
      itemBuilder: (context, index) {
        final workout = allWorkouts[index];
        return _buildWorkoutHistoryCard(workout);
      },
    ),
  );
}

 String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.day}/${date.month}/${date.year}';
}

  Widget _buildWorkoutHistoryCard(WorkoutEntity workout) {
    final store = StoreProvider.of<AppState>(context);
    final isPlanWorkout = workout.planInfo != null;
    final date = formatTimestamp(workout.createdAt);
    final duration = workout.duration;
    final calories = workout.caloriesBurned;

    return GestureDetector(
      onTap: () {
        store.dispatch(EditWorkout(workout: workout));
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isPlanWorkout 
                      ? 'Plan: ${workout.type}'
                      : workout.type,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                workout.listDisplayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildHistoryInfoChip(
                    Icons.calendar_today,
                    date,
                  ),
                  const SizedBox(width: 8),
                  _buildHistoryInfoChip(
                    Icons.timer,
                    '$duration min',
                  ),
                  const SizedBox(width: 8),
                  _buildHistoryInfoChip(
                    Icons.local_fire_department,
                    '$calories kcal',
                  ),
                ],
              ),
              if (isPlanWorkout) ...[
                const SizedBox(height: 8),
                Text(
                  'Week ${workout.planInfo?.weekNumber}, Run ${workout.planInfo?.runNumber}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutPlanScreen extends StatefulWidget {
  const WorkoutPlanScreen({
    super.key,
    required this.workoutState,
    this.selectedPlanId,
    required this.onPlanSelected,
    required this.isCalendarView,
  });

  final Map<String, WorkoutEntity> workoutState;
  final int? selectedPlanId;
  final Function(int) onPlanSelected;
  final bool isCalendarView;

  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  int? selectedWeekNumber;
  late Map<String, dynamic> plansData;

  @override
  void initState() {
    super.initState();
    plansData = json.decode(staticWorkoutPlanData);
  }

  bool isRunCompleted(int planId, int weekNumber, int runNumber) {
    if (widget.workoutState.isEmpty) {
      return false;
    }

    final currentUserId = _getCurrentUserId();
    
    String runKey = 'run_${planId}_${weekNumber}_$runNumber';
    bool locallyCompleted = _isRunLocallyCompleted(runKey);
    
    bool completedInState = widget.workoutState.values.any((workout) {
      if (workout.planInfo == null) {
        return false;
      }

      final bool isMatch = workout.planInfo!.planId == planId &&
          workout.planInfo!.weekNumber == weekNumber &&
          workout.planInfo!.runNumber == runNumber &&
          workout.planInfo!.isCompleted &&
          workout.createdUserId == currentUserId; 

      return isMatch;
    });
    
    return completedInState || locallyCompleted;
  }

  bool _isRunLocallyCompleted(String runKey) {
    final currentUserId = _getCurrentUserId();
    final userSpecificKey = '${currentUserId}_$runKey';
    
    return _completedRuns.contains(userSpecificKey);
  }
  
  void _markRunAsLocallyCompleted(String runKey) {
    final currentUserId = _getCurrentUserId();
    final userSpecificKey = '${currentUserId}_$runKey';
    
    _completedRuns.add(userSpecificKey);
    setState(() {}); 
  }
  
  String _getCurrentUserId() {
    final store = StoreProvider.of<AppState>(context, listen: false);
    return store.state.userCompany.user.id;
  }
  
  static Set<String> _completedRuns = <String>{};

  double getWeekProgress(int planId, int weekNumber) {
    final plan =
        plansData['plans'].firstWhere((plan) => plan['planId'] == planId);
    final week =
        plan['weeks'].firstWhere((week) => week['weekNumber'] == weekNumber);

    final totalRuns = week['runs'].length;
    int completedRunsCount = 0;

    for (var run in week['runs']) {
      final runNumber = run['runNumber'];
      if (isRunCompleted(planId, weekNumber, runNumber)) {
        completedRunsCount++;
      }
    }

    return totalRuns > 0 ? completedRunsCount / totalRuns : 0.0;
  }

  double getPlanProgress(int planId) {
    final plan =
        plansData['plans'].firstWhere((plan) => plan['planId'] == planId);
    final weeks = plan['weeks'];
    int totalRuns = 0;
    int completedRunsCount = 0;

    for (final week in weeks) {
      final weekNumber = week['weekNumber'];
      final runs = week['runs'];
      totalRuns += runs.length as int;

      for (var run in runs) {
        final runNumber = run['runNumber'];
        if (isRunCompleted(planId, weekNumber, runNumber)) {
          completedRunsCount++;
        }
      }
    }

    return totalRuns > 0 ? completedRunsCount / totalRuns : 0.0;
  }

  bool isAchievementUnlocked(
      Map<String, dynamic> achievement, int planId, int weekNumber) {
    final String criteria = achievement['unlockCriteria'];

    if (criteria.contains('Complete Run')) {
      final runNumber = int.tryParse(criteria.split(' ').last) ?? 0;
      return isRunCompleted(planId, weekNumber, runNumber);
    } else if (criteria.contains('Complete all runs')) {
      final week = plansData['plans']
          .firstWhere((plan) => plan['planId'] == planId)['weeks']
          .firstWhere((week) => week['weekNumber'] == weekNumber);

      final runs = week['runs'];

      for (var run in runs) {
        final runNumber = run['runNumber'];
        if (!isRunCompleted(planId, weekNumber, runNumber)) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  int getRunCurrentWeekNumber(int planId, int runNumber) {
    try {
      final plan = plansData['plans'].firstWhere((p) => p['planId'] == planId);
      for (var week in plan['weeks']) {
        if (week['runs'].any((r) => r['runNumber'] == runNumber)) {
          return week['weekNumber'] as int;
        }
      }
      return -1;
    } catch (e) {
      logError('Error finding current week number: $e');
      return -1;
    }
  }

  int getRunCurrentDayIndex(int planId, int weekNumber, int runNumber) {
    try {
      final plan = plansData['plans'].firstWhere((p) => p['planId'] == planId);
      final week =
          plan['weeks'].firstWhere((w) => w['weekNumber'] == weekNumber);
      final run = week['runs'].firstWhere((r) => r['runNumber'] == runNumber);

      if (run.containsKey('scheduledFor') && run['scheduledFor'] != null) {
        final timestamp = run['scheduledFor'] as int;
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        return dateTime.weekday - 1;
      }

      final runIndex =
          week['runs'].indexWhere((r) => r['runNumber'] == runNumber);
      if (runIndex >= 0) {
        return runIndex * 2;
      }

      return 0;
    } catch (e) {
      logError('Error finding current day index: $e');
      return 0;
    }
  }

  bool checkDragRules(Map<String, dynamic> runData, int weekNumber,
      int currentDayIndex, int targetDayIndex, int targetWeekNumber) {
    final planId = widget.selectedPlanId;
    if (planId == null) return false;

    final runNumber = runData['runNumber'] as int;
    final isCompleted = isRunCompleted(planId, weekNumber, runNumber);
    if (isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completed workouts cannot be rescheduled'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    final today = DateTime.now();
    final currentWeekNumber = getWeekNumber();

    final isPastWorkout = (weekNumber < currentWeekNumber) ||
        (weekNumber == currentWeekNumber &&
            currentDayIndex < today.weekday - 1);

    if (isPastWorkout) {
      int daysInPast = 0;
      if (weekNumber == currentWeekNumber) {
        daysInPast = today.weekday - 1 - currentDayIndex;
      } else {
        daysInPast = (today.weekday - 1) +
            (7 - currentDayIndex) +
            ((currentWeekNumber - weekNumber - 1) * 7);
      }

      if (daysInPast > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Cannot reschedule workouts more than 3 days in the past'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    }

    final plan = plansData['plans'].firstWhere((p) => p['planId'] == planId);
    final weeks = plan['weeks'];
    final targetWeek =
        weeks.firstWhere((w) => w['weekNumber'] == targetWeekNumber);
    final runs = targetWeek['runs'];

    bool dayHasWorkout = runs.any((r) =>
        r['dayOfWeek'] == targetDayIndex &&
        !(weekNumber == targetWeekNumber && r['runNumber'] == runNumber));

    if (dayHasWorkout) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This day already has a scheduled workout'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    return true;
  }

  void updateRunDayOfWeek(
      int planId, int targetWeekNumber, int runNumber, int newDayOfWeek) {
    try {
      final planIndex =
          plansData['plans'].indexWhere((p) => p['planId'] == planId);
      if (planIndex == -1) return;

      int currentWeekIndex = -1;
      int runIndex = -1;

      for (int i = 0; i < plansData['plans'][planIndex]['weeks'].length; i++) {
        final week = plansData['plans'][planIndex]['weeks'][i];
        for (int j = 0; j < week['runs'].length; j++) {
          if (week['runs'][j]['runNumber'] == runNumber) {
            currentWeekIndex = i;
            runIndex = j;
            break;
          }
        }
        if (currentWeekIndex != -1) break;
      }

      if (currentWeekIndex == -1 || runIndex == -1) return;

      final currentWeekNumber = plansData['plans'][planIndex]['weeks']
          [currentWeekIndex]['weekNumber'];

      if (targetWeekNumber != currentWeekNumber) {
        final targetWeekIndex = plansData['plans'][planIndex]['weeks']
            .indexWhere((w) => w['weekNumber'] == targetWeekNumber);
        if (targetWeekIndex == -1) return;

        final removedRun = plansData['plans'][planIndex]['weeks']
                [currentWeekIndex]['runs']
            .removeAt(runIndex);

        final newTimestamp =
            calculateTimestampForWeekAndDay(targetWeekNumber, newDayOfWeek);

        removedRun['scheduledFor'] = newTimestamp;

        plansData['plans'][planIndex]['weeks'][targetWeekIndex]['runs']
            .add(removedRun);
      } else {
        final newTimestamp =
            calculateTimestampForWeekAndDay(currentWeekNumber, newDayOfWeek);
        plansData['plans'][planIndex]['weeks'][currentWeekIndex]['runs']
            [runIndex]['scheduledFor'] = newTimestamp;
      }

      setState(() {});

    } catch (e) {
      logError('Error updating run: $e');
    }
  }

  int calculateTimestampForWeekAndDay(int weekNumber, int dayOfWeek) {
    final firstMondayOfMay2025 = DateTime(2025, 5, 5);

    final targetDate = firstMondayOfMay2025
        .add(Duration(days: (weekNumber - 1) * 7))
        .add(Duration(days: dayOfWeek));

    return targetDate.millisecondsSinceEpoch ~/ 1000;
  }

  int getWeekNumber() {
    final DateTime now = DateTime.now();
    final DateTime firstDayOfYear = DateTime(now.year, 1, 1);
    final int dayOfYear = now.difference(firstDayOfYear).inDays;
    return (dayOfYear / 7).floor() + 1;
  }

  bool isSkipped(int planId, int weekNumber, int runNumber) {
    return false;
  }

  void showRunDetails(Map<String, dynamic> runData, int weekNumber) async {

    if (widget.selectedPlanId == null) return;

    final result = await Navigator.of(context).pushNamed(
      WorkoutViewScreen.route,
      arguments: {
        'runData': runData,
        'weekNumber': weekNumber,
        'planId': widget.selectedPlanId,
      },
    );

    if (result is Map<String, dynamic> && result.containsKey('workoutProgress')) {
      final progressData = result['workoutProgress'] as Map<String, dynamic>;

      _handleWorkoutCompletion(progressData, result);
      
      setState(() {});
    }
  }

  void _handleWorkoutCompletion(Map<String, dynamic> progressData, Map<String, dynamic> result) {
    final planId = result['planId'] as int?;
    final weekNumber = result['weekNumber'] as int?;
    final runData = result['runData'] as Map<String, dynamic>?;
    
    if (planId == null || weekNumber == null || runData == null) {
      return;
    }
    
    final runNumber = runData['runNumber'] as int? ?? 0;
    final runCompleted = progressData['runCompleted'] as bool? ?? false;

    if (runCompleted) {
      String runKey = 'run_${planId}_${weekNumber}_$runNumber';
      _markRunAsLocallyCompleted(runKey);

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.selectedPlanId == null
        ? _buildPlansList()
        : widget.isCalendarView
            ? WorkoutCalendarView(
                plansData: plansData,
                selectedPlanId: widget.selectedPlanId,
                workoutState: widget.workoutState,
                isRunCompleted: isRunCompleted,
                getWeekProgress: getWeekProgress,
                getRunCurrentWeekNumber: getRunCurrentWeekNumber,
                getRunCurrentDayIndex: getRunCurrentDayIndex,
                checkDragRules: checkDragRules,
                updateRunDayOfWeek: updateRunDayOfWeek,
                getWeekNumber: getWeekNumber,
                isSkipped: isSkipped,
                showRunDetails: showRunDetails,
              )
            : _buildWeeksList();
  }

  Widget _buildPlansList() {
    final List<dynamic> plans = plansData['plans'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return _buildPlanCard(plan);
      },
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    final planId = plan['planId'] as int;
    final progress = getPlanProgress(planId);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          widget.onPlanSelected(planId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: _getDifficultyColor(plan['difficulty'] as String),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plan['name'] as String,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildDifficultyChip(plan['difficulty'] as String),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan['description'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.calendar_today,
                        plan['duration'] as String,
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.repeat,
                        '${plan['sessionsPerWeek']} sessions/week',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          minHeight: 8,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getDifficultyColor(plan['difficulty'] as String),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeksList() {
    // Check if selectedPlanId is null
    if (widget.selectedPlanId == null) return Container();

    final plan = plansData['plans']
        .firstWhere((p) => p['planId'] == widget.selectedPlanId);
    final List<dynamic> weeks = plan['weeks'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: weeks.length,
      itemBuilder: (context, index) {
        final week = weeks[index];
        return _buildExpandableWeekCard(week);
      },
    );
  }

  Widget _buildExpandableWeekCard(Map<String, dynamic> week) {
    if (widget.selectedPlanId == null) return Container();

    final weekNumber = week['weekNumber'] as int;
    final progress = getWeekProgress(widget.selectedPlanId!, weekNumber);
    final List<dynamic> runs = week['runs'];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        childrenPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              'Week $weekNumber',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${runs.length} Runs',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  minHeight: 8,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ],
          ),
        ),
        children: [
          _buildRunsTimeline(runs, weekNumber),
        ],
      ),
    );
  }

  Widget _buildRunsTimeline(List<dynamic> runs, int weekNumber) {
    if (widget.selectedPlanId == null) return Container();

    final areAllRunsCompleted = runs.every((run) =>
        isRunCompleted(widget.selectedPlanId!, weekNumber, run['runNumber']));

    return SizedBox(
      height: (runs.length + 1) * 100.0,
      child: Stack(
        children: [
          Positioned(
            left: 24,
            top: 24,
            bottom: 24,
            width: 2,
            child: Container(color: Colors.grey[300]),
          ),
          Column(
            children: [
              ...List.generate(runs.length, (index) {
                final run = runs[index];
                final runNumber = run['runNumber'] as int;
                final isCompleted = isRunCompleted(
                    widget.selectedPlanId!, weekNumber, runNumber);

                return SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ? Colors.green : Colors.grey[300],
                          border: Border.all(
                            color:
                                isCompleted ? Colors.green : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 24,
                                color: Colors.white,
                              )
                            : Text(
                                '$runNumber',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          elevation: 1,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: isCompleted
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              showRunDetails(run, weekNumber);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Run ${run['runNumber']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (isCompleted)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: const Text(
                                            'Done',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    run['title'] as String,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: areAllRunsCompleted
                            ? Colors.amber.shade300
                            : Colors.grey[200],
                        border: Border.all(
                          color: areAllRunsCompleted
                              ? Colors.amber.shade500
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        areAllRunsCompleted ? Icons.emoji_events : Icons.lock,
                        size: 24,
                        color: areAllRunsCompleted
                            ? Colors.amber.shade800
                            : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 1,
                        margin: EdgeInsets.zero,
                        color: areAllRunsCompleted
                            ? Colors.amber.shade50
                            : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: areAllRunsCompleted
                                ? Colors.amber.withOpacity(0.5)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: areAllRunsCompleted
                              ? const Text(
                                  'Week Complete! Achievement Unlocked',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                )
                              : const Text(
                                  'Complete all runs to unlock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color chipColor;
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        chipColor = Colors.green;
        break;
      case 'intermediate':
        chipColor = Colors.orange;
        break;
      case 'advanced':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        difficulty.capitalize(),
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[700],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
