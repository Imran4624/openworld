import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plan_model.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/week_card.dart';

class PlanDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Plan plan = ModalRoute.of(context)!.settings.arguments as Plan;

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
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
              Text(
                plan.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    context,
                    '${plan.totalSessions}',
                    'Total Sessions',
                    Icons.fitness_center,
                  ),
                  _buildStatCard(
                    context,
                    plan.duration,
                    'Duration',
                    Icons.access_time,
                  ),
                  _buildStatCard(
                    context,
                    plan.goalDistance,
                    'Goal',
                    Icons.flag,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Weekly Schedule',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: plan.weeks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: WeekCard(
                        week: plan.weeks[index],
                        onTap: (run) {
                          Navigator.pushNamed(
                            context,
                            '/run_detail',
                            arguments: {
                              'plan': plan,
                              'week': plan.weeks[index],
                              'run': run,
                            },
                          );
                        },
                      ),
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

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
