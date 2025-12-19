import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/life_progress/edit_goal.dart';

// void main() {
//   runApp(GoalTrackerApp());
// }

class GoalTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Goal Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GoalTrackerHome(),
    );
  }
}

class Goal {
  String name;
  Color color;
  List<bool> repeatDays; // length 7 (Mon-Sun)
  TimeOfDay time;
  bool reminderOn;

  Goal({
    required this.name,
    required this.color,
    required this.repeatDays,
    required this.time,
    required this.reminderOn,
  });
}

class UserData {
  DateTime dateOfBirth;
  List<Goal> goals;

  // Progress tracking: Map<goalIndex, Map<dateKey, progress>>
  Map<int, Map<String, int>> weeklyProgress = {};
  Map<int, Map<String, int>> monthlyProgress = {};
  Map<int, Map<String, int>> yearlyProgress = {};
  Map<int, Map<String, int>> lifeProgress = {};

  UserData({
    required this.dateOfBirth,
    required this.goals,
  });

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _getWeekKey(DateTime date) {
    int weekOfYear =
        ((date.difference(DateTime(date.year, 1, 1)).inDays) / 7).floor() + 1;
    return '${date.year}-W${weekOfYear.toString().padLeft(2, '0')}';
  }

  String _getYearKey(DateTime date) {
    return date.year.toString();
  }

  void toggleWeeklyProgress(int goalIndex, DateTime date) {
    String key = _getDateKey(date);
    weeklyProgress[goalIndex] ??= {};
    weeklyProgress[goalIndex]![key] =
        (weeklyProgress[goalIndex]![key] ?? 0) == 0 ? 1 : 0;
  }

  void toggleMonthlyProgress(int goalIndex, DateTime date) {
    String key = _getDateKey(date);
    monthlyProgress[goalIndex] ??= {};
    monthlyProgress[goalIndex]![key] =
        (monthlyProgress[goalIndex]![key] ?? 0) == 0 ? 1 : 0;
  }

  void toggleYearlyProgress(int goalIndex, DateTime date) {
    String key = _getWeekKey(date);
    yearlyProgress[goalIndex] ??= {};
    yearlyProgress[goalIndex]![key] =
        (yearlyProgress[goalIndex]![key] ?? 0) == 0 ? 1 : 0;
  }

  void toggleLifeProgress(int goalIndex, int year) {
    String key = year.toString();
    lifeProgress[goalIndex] ??= {};
    lifeProgress[goalIndex]![key] =
        (lifeProgress[goalIndex]![key] ?? 0) == 0 ? 1 : 0;
  }

  int getWeeklyProgress(int goalIndex, DateTime date) {
    String key = _getDateKey(date);
    return weeklyProgress[goalIndex]?[key] ?? 0;
  }

  int getMonthlyProgress(int goalIndex, DateTime date) {
    String key = _getDateKey(date);
    return monthlyProgress[goalIndex]?[key] ?? 0;
  }

  int getYearlyProgress(int goalIndex, DateTime date) {
    String key = _getWeekKey(date);
    return yearlyProgress[goalIndex]?[key] ?? 0;
  }

  int getLifeProgress(int goalIndex, int year) {
    String key = year.toString();
    return lifeProgress[goalIndex]?[key] ?? 0;
  }

  // Helper methods to calculate progress percentages for other tabs
  double getMonthlyProgressPercentage(int goalIndex, DateTime month) {
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int completedDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      DateTime currentDay = DateTime(month.year, month.month, day);
      if (getMonthlyProgress(goalIndex, currentDay) == 1) {
        completedDays++;
      }
    }

    return daysInMonth > 0 ? completedDays / daysInMonth : 0.0;
  }

  double getYearlyProgressPercentage(int goalIndex, int year) {
    int completedWeeks = 0;
    DateTime firstMonday = _getFirstMondayOfYear(year);

    for (int week = 0; week < 52; week++) {
      DateTime weekStart = firstMonday.add(Duration(days: week * 7));
      if (getYearlyProgress(goalIndex, weekStart) == 1) {
        completedWeeks++;
      }
    }

    return completedWeeks / 52.0;
  }

  double getLifeProgressPercentage(int goalIndex) {
    int birthYear = dateOfBirth.year;
    int totalYears = 62;
    int completedYears = 0;

    for (int yearOffset = 0; yearOffset < totalYears; yearOffset++) {
      int year = birthYear + yearOffset;
      if (getLifeProgress(goalIndex, year) == 1) {
        completedYears++;
      }
    }

    return completedYears / totalYears;
  }

  DateTime _getFirstMondayOfYear(int year) {
    DateTime firstDay = DateTime(year, 1, 1);
    int daysToAdd = (8 - firstDay.weekday) % 7;
    return firstDay.add(Duration(days: daysToAdd));
  }
}

class GoalTrackerHome extends StatefulWidget {
  @override
  _GoalTrackerHomeState createState() => _GoalTrackerHomeState();
}

class _GoalTrackerHomeState extends State<GoalTrackerHome>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late UserData userData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize user data with goals having colors
    userData = UserData(
      dateOfBirth: DateTime(1990, 1, 1),
      goals: [
        Goal(
          name: 'Run Marathon',
          color: Colors.orange,
          repeatDays: [true, true, true, true, true, false, false],
          time: TimeOfDay(hour: 6, minute: 0),
          reminderOn: true,
          // expectedCompletionDate: DateTime(2025, 12, 31),
        ),
        // Goal(
        //   name: 'Start a Business',
        //   color: Colors.green,
        //   expectedCompletionDate: DateTime(2025, 12, 31),
        // ),
        // Goal(
        //   name: 'Eat Healthy',
        //   color: Colors.amber,
        //   expectedCompletionDate: DateTime(2025, 12, 31),
        // ),
        // Goal(
        //   name: 'Eat Healthy1',
        //   color: Colors.amber,
        //   expectedCompletionDate: DateTime(2025, 12, 31),
        // ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        title: Text('Goal Tracker', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final newGoal = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGoalScreen(),
                ),
              );

              if (newGoal != null && newGoal is Goal) {
                setState(() {
                  userData.goals.add(newGoal);
                });
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: 'Week'),
            Tab(text: 'Month'),
            Tab(text: 'Year'),
            Tab(text: 'Life'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          WeekTab(userData: userData),
          MonthTab(userData: userData),
          YearTab(userData: userData),
          LifeTab(userData: userData),
        ],
      ),
    );
  }
}

class GoalSelector extends StatelessWidget {
  final UserData userData;
  final int selectedIndex;
  final Function(int) onSelect;

  GoalSelector({
    required this.userData,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: userData.goals.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final goal = userData.goals[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? goal.color : Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  goal.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WeekTab extends StatefulWidget {
  final UserData userData;

  WeekTab({required this.userData});

  @override
  _WeekTabState createState() => _WeekTabState();
}

class _WeekTabState extends State<WeekTab> {
  DateTime currentWeekStart = DateTime.now();

  @override
  void initState() {
    super.initState();
    currentWeekStart = _getWeekStart(DateTime.now());
  }

  DateTime _getWeekStart(DateTime date) {
    int daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysFromMonday));
  }

  List<String> get weekDays =>
      ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  String _getFormattedDate() {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[currentWeekStart.month - 1]} ${currentWeekStart.day}';
  }

  String _getWeekday() {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[DateTime.now().weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1A1A1A),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.userData.goals.length,
                itemBuilder: (context, goalIndex) {
                  Goal goal = widget.userData.goals[goalIndex];

                  return Container(
                    margin: EdgeInsets.only(bottom: 30),
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final updatedGoal = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditGoalScreen(goal: goal), // pass goal
                                  ),
                                );

                                if (updatedGoal != null) {
                                  setState(() {
                                    widget.userData.goals[goalIndex] =
                                        updatedGoal;
                                  });
                                }
                              },
                              child: Text(
                                goal.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.local_fire_department,
                                color: Colors.orange, size: 20),
                            SizedBox(width: 4),
                            Text(
                              '${goalIndex + 1}',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // GoalSelector(
                        //   userData: widget.userData,
                        //   selectedIndex: selectedGoalIndex,
                        //   onSelect: (i) =>
                        //       setState(() => selectedGoalIndex = i),
                        // ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (dayIndex) {
                            DateTime currentDay =
                                currentWeekStart.add(Duration(days: dayIndex));
                            int progress = widget.userData
                                .getWeeklyProgress(goalIndex, currentDay);
                            bool isToday =
                                currentDay.day == DateTime.now().day &&
                                    currentDay.month == DateTime.now().month &&
                                    currentDay.year == DateTime.now().year;

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      widget.userData.toggleWeeklyProgress(
                                          goalIndex, currentDay);
                                    });
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: progress == 1
                                          ? goal.color
                                          : Color(0xFF4A4A4A),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  weekDays[dayIndex],
                                  style: TextStyle(
                                    color:
                                        isToday ? goal.color : Colors.grey[400],
                                    fontSize: 12,
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthTab extends StatefulWidget {
  final UserData userData;

  MonthTab({required this.userData});

  @override
  _MonthTabState createState() => _MonthTabState();
}

class _MonthTabState extends State<MonthTab> {
  DateTime currentMonth = DateTime.now();
  int selectedGoalIndex = 0;

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _getDaysInMonth(currentMonth);

    return Container(
      color: Color(0xFF1A1A1A),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 14),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                          currentMonth.year, currentMonth.month - 1, 1);
                    });
                  },
                ),
                Text(
                  '${_getMonthName(currentMonth.month)} ${currentMonth.year}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                  icon:
                      Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                  onPressed: () {
                    setState(() {
                      currentMonth = DateTime(
                          currentMonth.year, currentMonth.month + 1, 1);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Goal selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.userData.goals.asMap().entries.map((entry) {
                int goalIndex = entry.key;
                Goal goal = entry.value;
                bool isSelected = selectedGoalIndex == goalIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGoalIndex = goalIndex;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? goal.color : Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: daysInMonth,
                itemBuilder: (context, dayIndex) {
                  DateTime currentDay = DateTime(
                      currentMonth.year, currentMonth.month, dayIndex + 1);
                  Goal selectedGoal = widget.userData.goals[selectedGoalIndex];

                  // Check weekly progress instead of monthly
                  int progress = widget.userData
                      .getWeeklyProgress(selectedGoalIndex, currentDay);

                  return Container(
                    decoration: BoxDecoration(
                      color: progress == 1
                          ? selectedGoal.color
                          : Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${dayIndex + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

class YearTab extends StatefulWidget {
  final UserData userData;

  YearTab({required this.userData});

  @override
  _YearTabState createState() => _YearTabState();
}

class _YearTabState extends State<YearTab> {
  int currentYear = DateTime.now().year;
  int selectedGoalIndex = 0;

  DateTime _getFirstMondayOfYear(int year) {
    DateTime firstDay = DateTime(year, 1, 1);
    int daysToAdd = (8 - firstDay.weekday) % 7;
    return firstDay.add(Duration(days: daysToAdd));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF1A1A1A),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Year navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 14,
                  ),
                  onPressed: () {
                    setState(() {
                      currentYear--;
                    });
                  },
                ),
                Text(
                  currentYear.toString(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 14,
                  ),
                  onPressed: () {
                    setState(() {
                      currentYear++;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Goal selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.userData.goals.asMap().entries.map((entry) {
                int goalIndex = entry.key;
                Goal goal = entry.value;
                bool isSelected = selectedGoalIndex == goalIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGoalIndex = goalIndex;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? goal.color : Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 52,
                itemBuilder: (context, weekIndex) {
                  DateTime firstMonday = _getFirstMondayOfYear(currentYear);
                  DateTime weekStart =
                      firstMonday.add(Duration(days: weekIndex * 7));
                  Goal selectedGoal = widget.userData.goals[selectedGoalIndex];

                  // Check if any day in this week has progress
                  bool completed = false;
                  for (int d = 0; d < 7; d++) {
                    DateTime day = weekStart.add(Duration(days: d));
                    if (widget.userData
                            .getWeeklyProgress(selectedGoalIndex, day) ==
                        1) {
                      completed = true;
                      break;
                    }
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: completed ? selectedGoal.color : Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${weekIndex + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LifeTab extends StatefulWidget {
  final UserData userData;

  LifeTab({required this.userData});

  @override
  _LifeTabState createState() => _LifeTabState();
}

class _LifeTabState extends State<LifeTab> {
  int selectedGoalIndex = 0;

  @override
  Widget build(BuildContext context) {
    int birthYear = widget.userData.dateOfBirth.year;
    int deathYear = birthYear + 62;
    int totalYears = 62;

    return Container(
      color: Color(0xFF1A1A1A),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   'Life Progress (Born ${birthYear} - Death at ${deathYear})',
            //   style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white),
            // ),
            // SizedBox(height: 20),
            // Goal selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.userData.goals.asMap().entries.map((entry) {
                int goalIndex = entry.key;
                Goal goal = entry.value;
                bool isSelected = selectedGoalIndex == goalIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGoalIndex = goalIndex;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? goal.color : Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      goal.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: totalYears,
                itemBuilder: (context, yearIndex) {
                  int year = birthYear + yearIndex;
                  Goal selectedGoal = widget.userData.goals[selectedGoalIndex];

                  // Check if any day in this year is completed
                  bool completed = false;
                  for (int m = 1; m <= 12 && !completed; m++) {
                    int daysInMonth = DateTime(year, m + 1, 0).day;
                    for (int d = 1; d <= daysInMonth; d++) {
                      if (widget.userData.getWeeklyProgress(
                              selectedGoalIndex, DateTime(year, m, d)) ==
                          1) {
                        completed = true;
                        break;
                      }
                    }
                  }

                  bool isCurrentYear = year == DateTime.now().year;
                  bool isPastYear = year < DateTime.now().year;

                  return Container(
                    decoration: BoxDecoration(
                      color: completed
                          ? selectedGoal.color
                          : isPastYear
                              ? Color(0xFF4A4A4A) // Colors.red[900]
                              : Color(0xFF4A4A4A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrentYear ? Colors.blue : Colors.transparent,
                        width: isCurrentYear ? 2 : 0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        year.toString().substring(2),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
