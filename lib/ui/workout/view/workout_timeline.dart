import 'package:flutter/material.dart';

class WorkoutTimeline extends StatelessWidget {
  final Map<String, dynamic> runData;
  final int weekNumber;
  final int? planId;

  const WorkoutTimeline({
    Key? key,
    required this.runData,
    required this.weekNumber,
    required this.planId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract segments from runData
    final segments = runData['segments'] is List
        ? List<dynamic>.from(runData['segments'])
        : <dynamic>[];

    if (segments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Run ${runData['runNumber'] ?? ''} details not available',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Run ${runData['runNumber'] ?? ''}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            runData['title'] ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildCleanTimelineView(context, segments),
        ],
      ),
    );
  }

  Widget _buildCleanTimelineView(BuildContext context, List<dynamic> segments) {
    List<Widget> timelineItems = [];
    double totalDuration = 0;

    // Calculate total duration for proportional heights
    for (final segment in segments) {
      if (segment is! Map) continue;

      if (segment['type'] == 'interval') {
        final repeatCount = segment['repeatCount'] as int? ?? 1;
        final intervalSegments = segment['segments'] is List
            ? List<dynamic>.from(segment['segments'])
            : <dynamic>[];

        for (final intervalSegment in intervalSegments) {
          if (intervalSegment is Map) {
            totalDuration +=
                (intervalSegment['duration'] as num? ?? 0) * repeatCount;
          }
        }
      } else {
        totalDuration += segment['duration'] as num? ?? 0;
      }
    }

    // If no duration found, set a minimum
    if (totalDuration <= 0) totalDuration = 600; // 10 minutes default

    // Constants for timeline visualization
    const double lineWidth = 4.0;
    const double timelineLeftPadding = 30.0;
    const double timelineRightPadding = 30.0;

    // Build the timeline items
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      if (segment is! Map) continue;

      // Convert to Map<String, dynamic>
      final Map<String, dynamic> segmentMap = Map<String, dynamic>.from(
          segment.map((key, value) => MapEntry(key.toString(), value)));

      if (segmentMap['type'] == 'warmup') {
        timelineItems.add(
          _buildCleanTimelineSegment(
            context,
            segmentMap,
            Colors.blue,
            isFirst: true,
            isLast: false,
            totalDuration: totalDuration,
            lineWidth: lineWidth,
            leftPadding: timelineLeftPadding,
            rightPadding: timelineRightPadding,
          ),
        );
      } else if (segmentMap['type'] == 'cooldown') {
        timelineItems.add(
          _buildCleanTimelineSegment(
            context,
            segmentMap,
            Colors.green,
            isFirst: false,
            isLast: true,
            totalDuration: totalDuration,
            lineWidth: lineWidth,
            leftPadding: timelineLeftPadding,
            rightPadding: timelineRightPadding,
          ),
        );
      } else if (segmentMap['type'] == 'interval') {
        final repeatCount = segmentMap['repeatCount'] as int? ?? 1;
        final intervalSegments = segmentMap['segments'] is List
            ? List<dynamic>.from(segmentMap['segments'])
            : <dynamic>[];

        for (int repeat = 0; repeat < repeatCount; repeat++) {
          for (int j = 0; j < intervalSegments.length; j++) {
            final intervalSegment = intervalSegments[j];
            if (intervalSegment is! Map) continue;

            // Convert to Map<String, dynamic>
            final Map<String, dynamic> intervalSegmentMap =
                Map<String, dynamic>.from(intervalSegment
                    .map((key, value) => MapEntry(key.toString(), value)));

            final isRunSegment = intervalSegmentMap['type'] == 'run';

            timelineItems.add(
              _buildCleanTimelineSegment(
                context,
                intervalSegmentMap,
                isRunSegment ? Colors.orange : Colors.purple,
                isFirst: false,
                isLast: false,
                totalDuration: totalDuration,
                lineWidth: lineWidth,
                leftPadding: timelineLeftPadding,
                rightPadding: timelineRightPadding,
                repeatIndex: repeat + 1,
                repeatCount: repeatCount,
              ),
            );
          }
        }
      }
    }

    if (timelineItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No timeline segments available'),
        ),
      );
    }

    return Stack(
      children: [
        // The connecting curve at the top
        Positioned(
          left: timelineLeftPadding - lineWidth / 2,
          top: 0,
          right: timelineRightPadding - lineWidth / 2,
          child: CustomPaint(
            size: const Size(double.infinity, 30),
            painter: ConnectingCurvePainter(
              lineWidth: lineWidth,
              color: Colors.blue,
              hasRightLine: true,
            ),
          ),
        ),
        Column(children: timelineItems),
      ],
    );
  }

  Widget _buildCleanTimelineSegment(
    BuildContext context,
    Map<String, dynamic> segment,
    Color color, {
    required bool isFirst,
    required bool isLast,
    required double totalDuration,
    required double lineWidth,
    required double leftPadding,
    required double rightPadding,
    int? repeatIndex,
    int? repeatCount,
  }) {
    final duration = segment['duration'] as num? ?? 0;
    final activity = segment['activity'] as String? ?? 'Activity';

    // Calculate height based on proportion of total duration
    final double segmentHeight = 70 + (duration / totalDuration) * 150;

    // Simplified activity label
    String activityLabel = activity;
    if (repeatIndex != null && repeatCount != null && repeatCount > 1) {
      activityLabel += ' (${repeatIndex}/${repeatCount})';
    }

    return SizedBox(
      height: segmentHeight,
      child: Stack(
        children: [
          // Left vertical line
          Positioned(
            left: leftPadding - lineWidth / 2,
            top: 0,
            bottom: 0,
            width: lineWidth,
            child: Container(color: color),
          ),

          // Right vertical line - only visible in the two-line mode
          Positioned(
            right: rightPadding - lineWidth / 2,
            top: 0,
            bottom: 0,
            width: lineWidth,
            child: Container(color: color),
          ),

          // Activity label
          Positioned(
            left: leftPadding + 16,
            right: rightPadding + 16,
            top: segmentHeight / 2 - 12,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color, width: 1),
              ),
              child: Text(
                activityLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Duration label (minimal information)
          Positioned(
            left: leftPadding + 16,
            right: rightPadding + 16,
            bottom: 8,
            child: Text(
              _formatDuration(duration.toInt()),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

// Custom painter for the connecting curve at the top
class ConnectingCurvePainter extends CustomPainter {
  final double lineWidth;
  final Color color;
  final bool hasRightLine;

  ConnectingCurvePainter({
    required this.lineWidth,
    required this.color,
    this.hasRightLine = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height); // Start at bottom left
    path.lineTo(0, size.height / 2); // Go up to middle left

    if (hasRightLine) {
      // Draw curve to the right line
      path.quadraticBezierTo(
        size.width / 2, 0, // Control point (middle top)
        size.width, size.height / 2, // End point (middle right)
      );
      path.lineTo(size.width, size.height); // Go down to bottom right
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
