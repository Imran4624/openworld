import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/workout_model.dart';
import 'package:flutter_boilerplate/data/models/entities.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/workout/workout_actions.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/active_run_screen.dart';
import 'package:flutter_boilerplate/ui/workout/view/workout_view_vm.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

enum SegmentType {
  warmup('warmup'),
  run('run'),
  walk('walk'),
  cooldown('cooldown');

  const SegmentType(this.value);
  final String value;

  static SegmentType fromString(String value) {
    return SegmentType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => SegmentType.walk,
    );
  }
}

class WorkoutView extends StatefulWidget {
  const WorkoutView({
    Key? key,
    required this.viewModel,
    required this.isFilter,
  }) : super(key: key);

  final WorkoutViewVM viewModel;
  final bool isFilter;

  @override
  _WorkoutViewState createState() => new _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? runData;
  int? weekNumber;
  int? planId;

  List<ProgressSegment> segments = [];
  int totalSeconds = 0;
  int currentSeconds = 0;
  int timeLeftSeconds = 0;
  String currentActivity = 'Intro';
  String currentType = '';
  int currentSegmentIndex = 0;
  bool isLastSegment = false;
  bool runCompleted = false;
  bool initialSetupDone = false;

  bool isPaused = false;
  bool isAudioMuted = false;
  Timer? _timer;

  FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  Map<int, bool> playedAudioCues = {};

  TabController? _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _handleTabSelection() {
    if (_tabController?.indexIsChanging ?? false) {
      setState(() {
        _currentTabIndex = _tabController?.index ?? 0;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialSetupDone) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        runData = args['runData'] as Map<String, dynamic>?;
        weekNumber = args['weekNumber'] as int?;
        planId = args['planId'] as int?;
        _tabController = TabController(length: 2, vsync: this);
        _tabController?.addListener(_handleTabSelection);
        processSegmentsData();
        startTimer();
        _playCurrentSegmentAudio(0);
        initialSetupDone = true;
      }
    }
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty && !isSpeaking && !runCompleted && !isAudioMuted) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(text);
    }
  }

  void toggleAudio() {
    setState(() {
      isAudioMuted = !isAudioMuted;
    });
    if (isAudioMuted && isSpeaking) {
      flutterTts.stop();
      isSpeaking = false;
    }
  }

  void _playCurrentSegmentAudio(int timeOffset) {
    if (segments.isEmpty || currentSegmentIndex >= segments.length) return;

    final segment = segments[currentSegmentIndex];

    for (var audioCue in segment.audioCues) {
      if (audioCue.timeOffset == timeOffset) {
        int audioCueKey = currentSegmentIndex * 10000 + timeOffset;

        if (!playedAudioCues.containsKey(audioCueKey) ||
            !playedAudioCues[audioCueKey]!) {
          speak(audioCue.message);
          playedAudioCues[audioCueKey] = true;
        }
        break;
      }
    }
  }

  void processSegmentsData() {
    segments = [];
    totalSeconds = 0;

    if (runData == null || !runData!.containsKey('segments')) return;

    final segmentsData = runData!['segments'] as List<dynamic>?;
    if (segmentsData == null) return;

    for (var segment in segmentsData) {
      if (segment is! Map) continue;

      final duration = segment['duration'] as int? ?? 0;
      final audio = segment['audio'] as List<dynamic>? ?? [];
      final typeString = segment['type'] as String? ?? '';
      final segmentType = SegmentType.fromString(typeString);

      totalSeconds += duration;

      Color segmentColor;
      String displayType;
      String activity;

      switch (segmentType) {
        case SegmentType.warmup:
          segmentColor = Colors.blue;
          displayType = 'Warm Up';
          activity = 'Warm Up';
          break;
        case SegmentType.run:
          segmentColor = Colors.red;
          displayType = 'Run';
          activity = 'Run';
          break;
        case SegmentType.walk:
          segmentColor = Colors.purple;
          displayType = 'Walk';
          activity = 'Walk';
          break;
        case SegmentType.cooldown:
          segmentColor = Colors.green;
          displayType = 'Cool Down';
          activity = 'Cool Down';
          break;
      }

      segments.add(ProgressSegment(
        color: segmentColor,
        duration: duration,
        type: displayType,
        activity: activity,
        segmentType: segmentType,
        audioCues: _processAudioCues(audio),
      ));
    }

    if (totalSeconds > 0) {
      for (var segment in segments) {
        segment.percentage = segment.duration / totalSeconds;
      }
    }

    timeLeftSeconds = totalSeconds;

    if (segments.isNotEmpty) {
      currentActivity = segments[0].activity;
      currentType = segments[0].type;
    }
  }

  List<AudioCue> _processAudioCues(List<dynamic> audioCues) {
    List<AudioCue> result = [];

    for (var cue in audioCues) {
      if (cue is Map) {
        final timeOffset = cue['timeOffset'] as int? ?? 0;
        final message = cue['message'] as String? ?? '';

        if (message.isNotEmpty) {
          result.add(AudioCue(timeOffset: timeOffset, message: message));
        }
      }
    }

    return result;
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused && !runCompleted) {
        setState(() {
          currentSeconds++;
          timeLeftSeconds = totalSeconds - currentSeconds;

          updateCurrentSegment();

          int segmentStartTime = _getSegmentStartTime(currentSegmentIndex);
          int timeInSegment = currentSeconds - segmentStartTime;
          _playCurrentSegmentAudio(timeInSegment);

          if (currentSeconds >= totalSeconds) {
            runCompleted = true;
            _markWorkoutAsCompleted();
          }
        });
      }
    });
  }

  int _getSegmentStartTime(int segmentIndex) {
    int startTime = 0;
    for (int i = 0; i < segmentIndex; i++) {
      startTime += segments[i].duration;
    }
    return startTime;
  }

  void updateCurrentSegment() {
    int elapsedTime = 0;
    bool foundSegment = false;

    for (int i = 0; i < segments.length; i++) {
      elapsedTime += segments[i].duration;
      if (currentSeconds < elapsedTime) {
        if (currentSegmentIndex != i) {
          currentSegmentIndex = i;
          currentActivity = segments[i].activity;
          currentType = segments[i].type;

          _printVibrationCue(segments[i].segmentType);
          _playCurrentSegmentAudio(0);
        }
        foundSegment = true;
        isLastSegment = (i == segments.length - 1);
        break;
      }
    }

    if (!foundSegment && segments.isNotEmpty) {
      currentSegmentIndex = segments.length - 1;
      isLastSegment = true;
    }
  }

  void _printVibrationCue(SegmentType segmentType) {
    switch (segmentType) {
      case SegmentType.warmup:
      case SegmentType.walk:
      case SegmentType.cooldown:
        break;
      case SegmentType.run:
        break;
    }
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void skipToNextSegment() {
    if (segments.isEmpty) return;

    flutterTts.stop();
    isSpeaking = false;

    if (currentSegmentIndex < segments.length - 1) {
      int skipTo = 0;
      for (int i = 0; i <= currentSegmentIndex; i++) {
        skipTo += segments[i].duration;
      }

      setState(() {
        currentSeconds = skipTo;
        timeLeftSeconds = totalSeconds - currentSeconds;
        currentSegmentIndex++;
        currentActivity = segments[currentSegmentIndex].activity;
        currentType = segments[currentSegmentIndex].type;

        isLastSegment = (currentSegmentIndex == segments.length - 1);

        _playCurrentSegmentAudio(0);
      });
    } else if (currentSegmentIndex == segments.length - 1) {
      _markWorkoutAsCompleted();
    }
  }

  void goToPreviousSegment() {
    if (segments.isEmpty || currentSegmentIndex <= 0) return;

    flutterTts.stop();
    isSpeaking = false;

    int skipTo = 0;
    for (int i = 0; i < currentSegmentIndex - 1; i++) {
      skipTo += segments[i].duration;
    }

    setState(() {
      currentSeconds = skipTo;
      timeLeftSeconds = totalSeconds - currentSeconds;
      currentSegmentIndex--;
      currentActivity = segments[currentSegmentIndex].activity;
      currentType = segments[currentSegmentIndex].type;

      isLastSegment = (currentSegmentIndex == segments.length - 1);

      _playCurrentSegmentAudio(0);
    });
  }

  void _markWorkoutAsCompleted() {
    flutterTts.stop();
    isSpeaking = false;

    runCompleted = true;
    setState(() {});

    _saveWorkoutEntity();
    
    _navigateToPlanDetailWithProgress();
  }

  void _saveWorkoutEntity() {
    final store = StoreProvider.of<AppState>(context);
    final now = DateTime.now();
    final startTime = now.subtract(Duration(seconds: currentSeconds));
    final endTime = now;
    const distance = 0.0;
    const pace = 0.0;
    const calories = 0; 
    const elevationGain = 0;
    
    final currentUserId = store.state.userCompany.user.id;
    
    PlanInfo? planInfoEntity;
    if (planId != null && weekNumber != null && runData != null) {
      final runNumber = runData!['runNumber'] as int? ?? 0;
      planInfoEntity = PlanInfo((b) => b
        ..planId = planId!
        ..weekNumber = weekNumber!
        ..runNumber = runNumber
        ..isCompleted = runCompleted
      );
    }

    final workoutEntity = WorkoutEntity(id: BaseEntity.nextId).rebuild((b) => b
      ..type = 'Running'
      ..startTime = startTime.millisecondsSinceEpoch
      ..endTime = endTime.millisecondsSinceEpoch
      ..duration = currentSeconds
      ..distance = (distance * 1000).round()
      ..averagePace = pace.round()
      ..caloriesBurned = calories
      ..elevationGain = elevationGain
      ..planInfo = planInfoEntity?.toBuilder()
      ..createdAt = now.millisecondsSinceEpoch
      ..updatedAt = now.millisecondsSinceEpoch
      ..createdUserId = currentUserId
      ..assignedUserId = currentUserId
    );
    
    store.dispatch(SaveWorkoutRequest(workout: workoutEntity));
  }

  void _navigateToPlanDetailWithProgress() {
    final progressData = {
      'totalDuration': totalSeconds,
      'completedDuration': currentSeconds,
      'percentageCompleted': totalSeconds > 0
          ? (currentSeconds / totalSeconds * 100).toStringAsFixed(1)
          : '0.0',
      'segmentsCompleted': currentSegmentIndex + (runCompleted ? 1 : 0),
      'totalSegments': segments.length,
      'runCompleted': runCompleted,
    };
    
    Navigator.of(context).pop({
      'workoutProgress': progressData,
      'planId': planId,
      'weekNumber': weekNumber,
      'runData': runData,
    });
  }

  void showEndRunConfirmation() {
    flutterTts.stop();
    isSpeaking = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Run'),
        content: const Text('Are you sure you want to end this run?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              
              _navigateToPlanDetailWithProgress();
            },
            child: const Text('Yes, End Run'),
          ),
        ],
      ),
    );
  }

  void returnToPlanScreen() {
    widget.viewModel.onBackPressed();
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  String formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  Color getSegmentColor(int index) {
    if (index < segments.length) {
      return segments[index].color;
    }
    return Colors.grey;
  }

  Widget _buildWorkoutTab() {
    final runNumber = runData?['runNumber'] ?? '2';
    final week = weekNumber ?? 1;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Week $week',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Run $runNumber',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CustomPaint(
                      painter: ArcProgressPainter(
                        segments: segments,
                        currentPosition: totalSeconds > 0
                            ? currentSeconds / totalSeconds
                            : 0,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: getSegmentColor(currentSegmentIndex)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            currentActivity,
                            style: TextStyle(
                              color: getSegmentColor(currentSegmentIndex),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatTime(currentSeconds),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Time left',
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatTime(timeLeftSeconds),
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (segments.isNotEmpty && currentSegmentIndex < segments.length)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentType,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _calculateSegmentProgress(),
                    backgroundColor: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      getSegmentColor(currentSegmentIndex),
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: goToPreviousSegment,
                icon: Icon(
                  Icons.skip_previous_rounded,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 32,
                ),
              ),
              if (isLastSegment && !runCompleted)
                GestureDetector(
                  onTap: _markWorkoutAsCompleted,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                )
              else if (!runCompleted)
                GestureDetector(
                  onTap: togglePause,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPaused ? Colors.green : Colors.red.shade700,
                    ),
                    child: Center(
                      child: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: returnToPlanScreen,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              IconButton(
                onPressed: skipToNextSegment,
                icon: Icon(
                  Icons.skip_next_rounded,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (args == null || _tabController == null) {
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => widget.viewModel.onBackPressed(),
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: Text(
            'Active Run',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        body: const ActiveRunScreen(),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black87 : Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: showEndRunConfirmation,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          title: _currentTabIndex == 0
              ? Text(
                  currentType,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                )
              : Text(
                  'Workout History',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                  ),
                ),
          actions: [
            if (_currentTabIndex == 0)
              IconButton(
                icon: Icon(
                  isAudioMuted ? Icons.volume_off : Icons.volume_up,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: toggleAudio,
              ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Current Workout'),
              Tab(text: 'Map'),
            ],
            labelColor: isDarkMode ? Colors.white : Colors.black,
            unselectedLabelColor: isDarkMode ? Colors.white70 : Colors.black54,
            indicatorColor: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        body: TabBarView(
         controller: _tabController,
         physics: const NeverScrollableScrollPhysics(), 
         children: [
           _buildWorkoutTab(),
           ActiveRunScreen(
             totalSeconds: currentSeconds,
             distanceCovered: 0.0, 
             currentPace: 0.0, 
             currentSegmentIndex: currentSegmentIndex,
             currentActivity: currentActivity,
             isPaused: isPaused,
             isCompleted: runCompleted,
             onPause: togglePause,
             onResume: togglePause,
             onEnd: showEndRunConfirmation,
             showControls: false,
           ),
         ],
       ),
      ),
    );
  }

  double _calculateSegmentProgress() {
    if (segments.isEmpty || currentSegmentIndex >= segments.length) return 0.0;

    int segmentStartTime = _getSegmentStartTime(currentSegmentIndex);
    int segmentDuration = segments[currentSegmentIndex].duration;
    int timeInSegment = currentSeconds - segmentStartTime;

    return timeInSegment / segmentDuration;
  }
}

class AudioCue {
  final int timeOffset;
  final String message;

  AudioCue({required this.timeOffset, required this.message});
}

class ProgressSegment {
  final Color color;
  final int duration;
  final String type;
  final String activity;
  final SegmentType segmentType;
  final List<AudioCue> audioCues;
  double percentage = 0;

  ProgressSegment({
    required this.color,
    required this.duration,
    required this.type,
    required this.activity,
    required this.segmentType,
    this.audioCues = const [],
  });
}

class ArcProgressPainter extends CustomPainter {
  final List<ProgressSegment> segments;
  final double currentPosition;
  final bool isDarkMode;

  ArcProgressPainter({
    required this.segments,
    required this.currentPosition,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final trackPaint = Paint()
      ..color = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28.0;

    canvas.drawCircle(center, radius - trackPaint.strokeWidth / 2, trackPaint);

    double startAngle = -math.pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * math.pi * segment.percentage;

      final segmentPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 28.0
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: radius - segmentPaint.strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      startAngle += sweepAngle;
    }

    if (currentPosition > 0) {
      final currentAngle = -math.pi / 2 + (2 * math.pi * currentPosition);
      const markerRadius = 8.0;

      final outerX = center.dx +
          (radius - trackPaint.strokeWidth / 2) * math.cos(currentAngle);
      final outerY = center.dy +
          (radius - trackPaint.strokeWidth / 2) * math.sin(currentAngle);

      final markerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(outerX, outerY), markerRadius, markerPaint);

      if (!isDarkMode) {
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;

        canvas.drawCircle(
            Offset(outerX, outerY), markerRadius + 1, shadowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}