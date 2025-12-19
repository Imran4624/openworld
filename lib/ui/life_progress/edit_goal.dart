import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/ui/life_progress/life_goal_main.dart';

class EditGoalScreen extends StatefulWidget {
  final Goal? goal;
  EditGoalScreen({this.goal});
  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  late TextEditingController _nameController;
  late Color selectedColor;
  late List<bool> selectedDays;
  bool reminderOn = false;
  List<int> repeatDays = []; // 1=Mon ... 7=Sun
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  bool reminderEnabled = true;

  final List<Color> availableColors = [
    Colors.red,
    Colors.pink,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.teal,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();

    if (widget.goal != null) {
      // Editing existing goal
      _nameController = TextEditingController(text: widget.goal!.name);
      selectedColor = widget.goal!.color;
      selectedDays = List.from(widget.goal!.repeatDays); // assuming bool[7]
      selectedTime = widget.goal!.time;
      reminderOn = widget.goal!.reminderOn;
    } else {
      // Creating new goal
      _nameController = TextEditingController();
      selectedColor = Colors.blue;
      selectedDays = List.filled(7, false);
      selectedTime = TimeOfDay(hour: 9, minute: 0);
      reminderOn = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(widget.goal != null ? "Update Goal" : "Create Goal",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: selectedColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Icon(Icons.local_fire_department,
                    color: selectedColor, size: 40),
              ),
            ),
            SizedBox(height: 20),

            // Name field
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter Goal Name",
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF2D2D2D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Color picker
            Row(
              children: availableColors.map((c) {
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedColor = c);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selectedColor == c
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text("Repeat", style: TextStyle(color: Colors.white)),

            // Repeat Days
            Wrap(
              spacing: 8,
              children: List.generate(7, (index) {
                final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                final dayNum = index + 1;
                final isSelected = repeatDays.contains(dayNum);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        repeatDays.remove(dayNum);
                      } else {
                        repeatDays.add(dayNum);
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? selectedColor : Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(days[index],
                        style: TextStyle(color: Colors.white)),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),

            // Time picker
            Row(
              children: [
                Text("Time: ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (picked != null) {
                      setState(() => selectedTime = picked);
                    }
                  },
                  child: Text(
                    "${selectedTime.format(context)}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            // Reminder toggle
            SwitchListTile(
              title: Text("Reminder", style: TextStyle(color: Colors.white)),
              value: reminderEnabled,
              onChanged: (val) => setState(() => reminderEnabled = val),
            ),

            Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedColor,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_nameController.text.isEmpty) return;

                Goal updatedGoal = Goal(
                  name: _nameController.text,
                  color: selectedColor,
                  repeatDays: selectedDays,
                  time: selectedTime,
                  reminderOn: reminderOn,
                );

                Navigator.pop(context, updatedGoal);
              },
              child: Text(widget.goal != null ? "Update" : "Create",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),

            // Create button
            // ElevatedButton(
            //   onPressed: () {
            //     Goal updatedGoal = Goal(
            //       name: _nameController.text,
            //       color: selectedColor,
            //       repeatDays: selectedDays,
            //       time: selectedTime,
            //       reminderOn: reminderOn,
            //     );

            //     Navigator.pop(context, updatedGoal);
            //   },
            //   child: Text(widget.goal != null ? "Update" : "Create",
            //       style: TextStyle(color: Colors.white, fontSize: 16)), // ✅
            // ),
          ],
        ),
      ),
    );
  }
}
