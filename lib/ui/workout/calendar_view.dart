import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkoutCalendarView extends StatelessWidget {
  const WorkoutCalendarView({
    Key? key,
    required this.plansData,
    required this.selectedPlanId,
    required this.workoutState,
    required this.isRunCompleted,
    required this.getWeekProgress,
    required this.getRunCurrentWeekNumber,
    required this.getRunCurrentDayIndex,
    required this.checkDragRules,
    required this.updateRunDayOfWeek,
    required this.getWeekNumber,
    required this.isSkipped,
    required this.showRunDetails,
  }) : super(key: key);

  final Map<String, dynamic> plansData;
  final int? selectedPlanId;
  final Map<String, dynamic> workoutState;
  final Function(int, int, int) isRunCompleted;
  final Function(int, int) getWeekProgress;
  final Function(int, int) getRunCurrentWeekNumber;
  final Function(int, int, int) getRunCurrentDayIndex;
  final Function(Map<String, dynamic>, int, int, int, int) checkDragRules;
  final Function(int, int, int, int) updateRunDayOfWeek;
  final Function() getWeekNumber;
  final Function(int, int, int) isSkipped;
  final Function(Map<String, dynamic>, int) showRunDetails;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    return Container(
      color: isDarkMode ? Colors.black : Colors.grey[100],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Tip: Long-press and drag runs to reschedule them',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildCalendarHeader(isDarkMode, isSmallScreen, context),
          Expanded(
            child: _buildCalendarGrid(isDarkMode, isSmallScreen, size, context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(
      bool isDarkMode, bool isSmallScreen, BuildContext context) {
    final weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final borderColor = isDarkMode ? Colors.amber[700]! : Colors.blue[200]!;
    final textColor = isDarkMode ? Colors.amber : Colors.blue[800]!;
    final headerBgColor = isDarkMode ? Colors.black : Colors.blue[50]!;
    final size = MediaQuery.of(context).size;
    final fontSize = size.width < 320 ? 10.0 : (size.width < 400 ? 12.0 : 16.0);
    final columnWidth = size.width / 8;

    return Container(
      decoration: BoxDecoration(
        color: headerBgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        border: TableBorder(
          verticalInside:
              BorderSide(color: borderColor.withOpacity(0.5), width: 1),
          bottom: BorderSide(color: borderColor, width: 2),
        ),
        columnWidths: {
          for (int i = 0; i < 8; i++) i: FixedColumnWidth(columnWidth),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: headerBgColor,
            ),
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 16),
                alignment: Alignment.center,
                child: Text(
                  '',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize.toDouble(),
                    letterSpacing: isSmallScreen ? 0.5 : 1,
                  ),
                ),
              ),
              ...weekdays.map((day) => Container(
                    padding:
                        EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 16),
                    alignment: Alignment.center,
                    child: Text(
                      day,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                        letterSpacing: isSmallScreen ? 0.5 : 1,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDarkMode, bool isSmallScreen,
      Size screenSize, BuildContext context) {
    if (selectedPlanId == null) return Container();

    final plan =
        plansData['plans'].firstWhere((p) => p['planId'] == selectedPlanId);
    final List<dynamic> weeks = plan['weeks'];
    final borderColor = isDarkMode ? Colors.amber[700]! : Colors.blue[200]!;
    final textColor = isDarkMode ? Colors.amber : Colors.blue[800]!;
    final size = screenSize;
    final fontSize = size.width < 320 ? 10.0 : (size.width < 400 ? 12.0 : 16.0);
    final numColumns = 8;
    final availableWidth = size.width;
    final cellSize = availableWidth / numColumns;
    final cellHeight = isSmallScreen ? 50.0 : 60.0;

    List<TableRow> rows = [];

    for (int i = 0; i < weeks.length; i++) {
      final week = weeks[i];
      final weekNumber = week['weekNumber'] as int;
      rows.add(_buildWeekRow(weekNumber, week, isDarkMode, textColor,
          borderColor, fontSize, cellSize, context));
    }

    return SingleChildScrollView(
      child: Table(
        border: TableBorder(
          verticalInside:
              BorderSide(color: borderColor.withOpacity(0.5), width: 1),
          horizontalInside:
              BorderSide(color: borderColor.withOpacity(0.5), width: 1),
        ),
        columnWidths: {
          for (int i = 0; i < 8; i++) i: FixedColumnWidth(cellSize),
        },
        children: rows,
      ),
    );
  }

  // Get day of week (0-6) from plannedDate timestamp
  int _getDayOfWeekFromTimestamp(int? timestamp) {
    if (timestamp == null) return 0;
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    // Convert to 0-6 (Monday to Sunday)
    int dayOfWeek = date.weekday - 1;
    return dayOfWeek;
  }

  TableRow _buildWeekRow(
      int weekNumber,
      Map<String, dynamic> weekData,
      bool isDarkMode,
      Color textColor,
      Color borderColor,
      double fontSize,
      double cellSize,
      BuildContext context) {
    final List<dynamic> runs = weekData['runs'];
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final size = MediaQuery.of(context).size;

    List<Map<String, dynamic>?> runsByDay = List.filled(7, null);
    for (var run in runs) {
      // Use plannedDate if available, otherwise fall back to dayOfWeek if exists
      int dayIndex;
      if (run.containsKey('plannedDate') && run['plannedDate'] != null) {
        dayIndex = _getDayOfWeekFromTimestamp(run['plannedDate']);
      } else if (run.containsKey('dayOfWeek') && run['dayOfWeek'] != null) {
        dayIndex = run['dayOfWeek'] as int;
      } else {
        // Default to first day if no data available
        dayIndex = 0;
      }

      // Ensure dayIndex is within bounds
      if (dayIndex >= 0 && dayIndex < 7) {
        runsByDay[dayIndex] = run;
      }
    }

    return TableRow(
      decoration: BoxDecoration(
        color: weekNumber % 2 == 0
            ? bgColor
            : (isDarkMode ? Colors.grey[900] : Colors.grey[50]),
      ),
      children: [
        Container(
          height: cellSize,
          width: cellSize,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'WEEK $weekNumber',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize * 1.2,
              ),
            ),
          ),
        ),
        ...List.generate(7, (dayIndex) {
          return DragTarget<Map<String, dynamic>>(
            onWillAccept: (data) {
              if (data == null) return false;

              try {
                final currentWeekNumber =
                    getRunCurrentWeekNumber(selectedPlanId!, data['runNumber']);
                if (currentWeekNumber == -1) return false;

                final currentDayIndex = getRunCurrentDayIndex(
                    selectedPlanId!, currentWeekNumber, data['runNumber']);

                return checkDragRules(data, currentWeekNumber, currentDayIndex,
                    dayIndex, weekNumber);
              } catch (e) {
                print('Error in onWillAccept: $e');
                return false;
              }
            },
            onAccept: (runData) {
              updateRunDayOfWeek(
                  selectedPlanId!, weekNumber, runData['runNumber'], dayIndex);

              HapticFeedback.heavyImpact();
            },
            builder: (context, candidateData, rejectedData) {
              final runData = runsByDay[dayIndex];
              final bool isCurrentlyDragTarget = candidateData.isNotEmpty;

              if (runData == null) {
                return Container(
                  height: cellSize,
                  width: cellSize,
                  decoration: BoxDecoration(
                    border: isCurrentlyDragTarget
                        ? Border.all(
                            color: Colors.blue,
                            width: 2.0,
                            style: BorderStyle.solid)
                        : null,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }

              final runNumber = runData['runNumber'] as int;
              final distance = runData['estimatedDistanceKm'];
              final today = DateTime.now();
              final currentDayIndex =
                  getRunCurrentDayIndex(selectedPlanId!, weekNumber, runNumber);
              final currentWeekNumber = getWeekNumber();
              final isPastWorkout = (weekNumber < currentWeekNumber) ||
                  (weekNumber == currentWeekNumber &&
                      currentDayIndex < today.weekday - 1);
              final daysInPast = isPastWorkout
                  ? (weekNumber == currentWeekNumber
                      ? today.weekday - 1 - currentDayIndex
                      : (today.weekday - 1) +
                          (7 - currentDayIndex) +
                          ((currentWeekNumber - weekNumber - 1) * 7))
                  : 0;
              final isMoreThan3DaysInPast = daysInPast > 3;
              final isCompleted =
                  isRunCompleted(selectedPlanId!, weekNumber, runNumber);
              final isPast = weekNumber < currentWeekNumber ||
                  (weekNumber == currentWeekNumber &&
                      dayIndex < today.weekday - 1);
              final isToday = weekNumber == currentWeekNumber &&
                  dayIndex == today.weekday - 1;

              Color cellTextColor;

              if (isCompleted) {
                cellTextColor =
                    isDarkMode ? Color(0xFF4CAF50) : Color(0xFF2E7D32);
              } else if (isPast && !isCompleted) {
                cellTextColor =
                    isDarkMode ? Color(0xFFEF9A9A) : Color(0xFFB71C1C);
              } else if (isToday) {
                cellTextColor =
                    isDarkMode ? Color(0xFF2196F3) : Color(0xFF0D47A1);
              } else if (isSkipped(selectedPlanId!, weekNumber, runNumber)) {
                cellTextColor =
                    isDarkMode ? Color(0xFFFF9800) : Color(0xFFE65100);
              } else {
                cellTextColor =
                    isDarkMode ? Color(0xFFBBDEFB) : Color(0xFF1565C0);
              }

              return LongPressDraggable<Map<String, dynamic>>(
                data: runData,
                maxSimultaneousDrags:
                    (isCompleted || isMoreThan3DaysInPast) ? 0 : 1,
                onDragStarted: () {
                  HapticFeedback.mediumImpact();
                },
                feedback: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: cellSize,
                    width: cellSize,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: cellTextColor,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${distance?.toInt() ?? 0}',
                                style: TextStyle(
                                  fontSize: fontSize * 1.8,
                                  fontWeight: FontWeight.bold,
                                  color: cellTextColor,
                                ),
                              ),
                              TextSpan(
                                text: 'km',
                                style: TextStyle(
                                  fontSize: fontSize * 0.9,
                                  fontWeight: FontWeight.bold,
                                  color: cellTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(
                  height: cellSize,
                  width: cellSize,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[850]!.withOpacity(0.5)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: cellTextColor.withOpacity(0.5),
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: Container(
                  height: cellSize,
                  width: cellSize,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(6),
                    border: isCurrentlyDragTarget
                        ? Border.all(
                            color: Colors.blue,
                            width: 2.0,
                            style: BorderStyle.solid)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () {
                        showRunDetails(runData, weekNumber);
                      },
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${distance?.toInt() ?? 0}',
                                  style: TextStyle(
                                    fontSize: size.width < 320
                                        ? fontSize * 1.5
                                        : (size.width < 400
                                            ? fontSize * 1.8
                                            : fontSize * 2.2),
                                    fontWeight: FontWeight.bold,
                                    color: cellTextColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'km',
                                  style: TextStyle(
                                    fontSize: size.width < 320
                                        ? fontSize * 0.8
                                        : (size.width < 400
                                            ? fontSize * 0.9
                                            : fontSize * 1.1),
                                    fontWeight: FontWeight.bold,
                                    color: cellTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
