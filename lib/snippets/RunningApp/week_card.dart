import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plan_model.dart';

class WeekCard extends StatelessWidget {
  final Week week;
  final Function(Run) onTap;

  const WeekCard({
    Key? key,
    required this.week,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Week ${week.weekNumber}',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${week.runs.length} Runs',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              week.focus,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              week.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: week.runs.length,
              itemBuilder: (context, index) {
                final run = week.runs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Run ${run.runNumber}: ${run.title}'),
                  subtitle: Text(
                    '${run.totalDurationMinutes.toInt()} min • ${run.estimatedDistanceKm.toStringAsFixed(1)} km',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => onTap(run),
                    child: Text('Start'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
