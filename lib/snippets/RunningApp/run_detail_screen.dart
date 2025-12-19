import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plan_model.dart';

class RunDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Plan plan = args['plan'];
    final Week week = args['week'];
    final Run run = args['run'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Run Details'),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${plan.name} - Week ${week.weekNumber}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Run ${run.runNumber}: ${run.title}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      run.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildRunStat(
                            context,
                            '${run.totalDurationMinutes.toInt()}',
                            'Minutes',
                            Icons.access_time),
                        _buildRunStat(
                            context,
                            '${run.estimatedDistanceKm.toStringAsFixed(1)}',
                            'Kilometers',
                            Icons.straighten),
                        _buildRunStat(context, '${_countIntervals(run)}',
                            'Intervals', Icons.repeat),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Workout Structure',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 12),
              Expanded(
                child: _buildWorkoutStructure(context, run),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.play_arrow),
                  label: Text('Start Run'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/active_run',
                      arguments: {
                        'plan': plan,
                        'week': week,
                        'run': run,
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRunStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  int _countIntervals(Run run) {
    int count = 0;
    for (var segment in run.segments) {
      if (segment.type == 'interval' && segment.repeatCount != null) {
        count += segment.repeatCount!;
      }
    }
    return count;
  }

  Widget _buildWorkoutStructure(BuildContext context, Run run) {
    List<Widget> segmentWidgets = [];

    for (var segment in run.segments) {
      if (segment.type == 'warmup' || segment.type == 'cooldown') {
        segmentWidgets.add(
          _buildSimpleSegment(
            context,
            segment.type == 'warmup' ? 'Warm Up' : 'Cool Down',
            segment.activity ?? '',
            '${segment.duration != null ? (segment.duration! / 60).toInt() : 0} min',
            segment.type == 'warmup' ? Colors.amber : Colors.blue,
          ),
        );
      } else if (segment.type == 'interval' &&
          segment.repeatCount != null &&
          segment.segments != null) {
        segmentWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Intervals (Repeat ${segment.repeatCount} times)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: Column(
                  children: segment.segments!.map((subSegment) {
                    if (subSegment.type == 'run') {
                      return _buildIntervalSegment(
                        context,
                        'Run',
                        '${subSegment.duration != null ? subSegment.duration! : 0} sec',
                        Colors.green,
                      );
                    } else if (subSegment.type == 'recovery') {
                      return _buildIntervalSegment(
                        context,
                        'Recovery',
                        '${subSegment.duration != null ? subSegment.duration! : 0} sec',
                        Colors.orange,
                      );
                    }
                    return Container();
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }

      if (segment != run.segments.last) {
        segmentWidgets.add(SizedBox(height: 12));
      }
    }

    return ListView(
      children: segmentWidgets,
    );
  }

  Widget _buildSimpleSegment(
    BuildContext context,
    String title,
    String activity,
    String duration,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '$activity for $duration',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(
            title == 'Warm Up' ? Icons.trending_up : Icons.trending_down,
            color: color,
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalSegment(
    BuildContext context,
    String title,
    String duration,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              title == 'Run' ? Icons.directions_run : Icons.directions_walk,
              color: color,
              size: 14,
            ),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Text(
            duration,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
