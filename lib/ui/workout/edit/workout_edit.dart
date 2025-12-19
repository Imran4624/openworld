import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/workout/edit/workout_edit_vm.dart';
import 'package:flutter_boilerplate/utils/localization.dart';
import 'package:flutter_boilerplate/utils/completers.dart';

class WorkoutEdit extends StatefulWidget {
  const WorkoutEdit({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final WorkoutEditVM viewModel;

  @override
  _WorkoutEditState createState() => _WorkoutEditState();
}

class _WorkoutEditState extends State<WorkoutEdit> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_workoutEdit');
  final _debouncer = Debouncer();

  // STARTER: controllers - do not remove comment
  final _typeController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _durationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _averagePaceController = TextEditingController();
  final _caloriesBurnedController = TextEditingController();
  final _elevationGainController = TextEditingController();
  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      // STARTER: array - do not remove comment
      _typeController,
      _startTimeController,
      _endTimeController,
      _durationController,
      _distanceController,
      _averagePaceController,
      _caloriesBurnedController,
      _elevationGainController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final workout = widget.viewModel.workout;
    // STARTER: read value - do not remove comment
    _typeController.text = workout.type.toString();
    _startTimeController.text = workout.startTime.toString();
    _endTimeController.text = workout.endTime.toString();
    _durationController.text = workout.duration.toString();
    _distanceController.text = workout.distance.toString();
    _averagePaceController.text = workout.averagePace.toString();
    _caloriesBurnedController.text = workout.caloriesBurned.toString();
    _elevationGainController.text = workout.elevationGain.toString();

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final workout = widget.viewModel.workout.rebuild((b) => b
        // STARTER: set value - do not remove comment
        ..type = _typeController.text.trim()
        ..startTime = int.tryParse(_startTimeController.text.trim()) ?? 0
        ..endTime = int.tryParse(_endTimeController.text.trim()) ?? 0
        ..duration = int.tryParse(_durationController.text.trim()) ?? 0
        ..distance = int.tryParse(_distanceController.text.trim()) ?? 0
        ..averagePace = int.tryParse(_averagePaceController.text.trim()) ?? 0
        ..caloriesBurned = int.tryParse(_caloriesBurnedController.text.trim()) ?? 0
        ..elevationGain = int.tryParse(_elevationGainController.text.trim()) ?? 0);
      if (workout != widget.viewModel.workout) {
        widget.viewModel.onChanged(workout);
      }
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${remainingSeconds}s';
    } else {
      return '${minutes}m ${remainingSeconds}s';
    }
  }

  String _formatDistance(int meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters} m';
  }

  String _formatPace(int secondsPerKm) {
    if (secondsPerKm == 0) return '0:00 /km';
    int minutes = secondsPerKm ~/ 60;
    int seconds = secondsPerKm % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')} /km';
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context)!;
    final workout = viewModel.workout;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => viewModel.onCancelPressed(context),
        ),
        title: Text(
          workout.isNew ? localization.newWorkout : localization.editWorkout,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Workout Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSummaryItem(
                        'Distance',
                        _formatDistance(workout.distance),
                        Icons.straighten,
                      ),
                      _buildSummaryItem(
                        'Time',
                        _formatTime(workout.duration),
                        Icons.timer,
                      ),
                      _buildSummaryItem(
                        'Pace',
                        _formatPace(workout.averagePace),
                        Icons.speed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Workout Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _typeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter workout name...',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: viewModel.isSaving ? null : () {
                  if (_typeController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a workout name')),
                    );
                    return;
                  }
                  viewModel.onSavePressed(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: viewModel.isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        workout.isNew ? 'SAVE WORKOUT' : 'UPDATE WORKOUT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}