class Plan {
  final String planId;
  final String name;
  final String description;
  final String difficulty;
  final String duration;
  final int sessionsPerWeek;
  final int totalSessions;
  final String goalDistance;
  final List<Week> weeks;

  Plan({
    required this.planId,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.duration,
    required this.sessionsPerWeek,
    required this.totalSessions,
    required this.goalDistance,
    required this.weeks,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planId: json['planId'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'],
      duration: json['duration'],
      sessionsPerWeek: json['sessionsPerWeek'],
      totalSessions: json['totalSessions'],
      goalDistance: json['goalDistance'],
      weeks: (json['weeks'] as List).map((w) => Week.fromJson(w)).toList(),
    );
  }
}

class Week {
  final int weekNumber;
  final String focus;
  final String description;
  final List<Run> runs;
  final List<String> weeklyTips;
  final List<Achievement> achievements;

  Week({
    required this.weekNumber,
    required this.focus,
    required this.description,
    required this.runs,
    required this.weeklyTips,
    required this.achievements,
  });

  factory Week.fromJson(Map<String, dynamic> json) {
    return Week(
      weekNumber: json['weekNumber'],
      focus: json['focus'],
      description: json['description'],
      runs: (json['runs'] as List).map((r) => Run.fromJson(r)).toList(),
      weeklyTips: List<String>.from(json['weeklyTips'] ?? []),
      achievements: (json['achievements'] as List? ?? [])
          .map((a) => Achievement.fromJson(a))
          .toList(),
    );
  }
}

class Run {
  final int runNumber;
  final String title;
  final String description;
  final double totalDurationMinutes;
  final double estimatedDistanceKm;
  final List<Segment> segments;
  final List<String> tips;

  Run({
    required this.runNumber,
    required this.title,
    required this.description,
    required this.totalDurationMinutes,
    required this.estimatedDistanceKm,
    required this.segments,
    required this.tips,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      runNumber: json['runNumber'],
      title: json['title'],
      description: json['description'],
      totalDurationMinutes: json['totalDurationMinutes'],
      estimatedDistanceKm: json['estimatedDistanceKm'],
      segments:
          (json['segments'] as List).map((s) => Segment.fromJson(s)).toList(),
      tips: List<String>.from(json['tips'] ?? []),
    );
  }
}

class Segment {
  final String type;
  final String? activity;
  final int? duration;
  final double? distanceKm;
  final List<AudioCue>? audio;
  final int? repeatCount;
  final List<Segment>? segments;

  Segment({
    required this.type,
    this.activity,
    this.duration,
    this.distanceKm,
    this.audio,
    this.repeatCount,
    this.segments,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      type: json['type'],
      activity: json['activity'],
      duration: json['duration'],
      distanceKm: json['distanceKm'],
      audio: json['audio'] != null
          ? (json['audio'] as List).map((a) => AudioCue.fromJson(a)).toList()
          : null,
      repeatCount: json['repeatCount'],
      segments: json['segments'] != null
          ? (json['segments'] as List).map((s) => Segment.fromJson(s)).toList()
          : null,
    );
  }
}

class AudioCue {
  final int timeOffset;
  final String message;

  AudioCue({
    required this.timeOffset,
    required this.message,
  });

  factory AudioCue.fromJson(Map<String, dynamic> json) {
    return AudioCue(
      timeOffset: json['timeOffset'],
      message: json['message'],
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String unlockCriteria;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockCriteria,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      unlockCriteria: json['unlockCriteria'],
    );
  }
}
