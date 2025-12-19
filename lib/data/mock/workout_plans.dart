import 'dart:convert';

final startDate = DateTime(2025, 1, 6);
final staticWorkoutPlanData = jsonEncode({
  "plans": [
    {
      "planId": 1,
      "name": "Couch to 5K",
      "description": "A 9-week beginner-friendly program to help you run 5K",
      "difficulty": "beginner",
      "duration": "9 weeks",
      "sessionsPerWeek": 3,
      "totalSessions": 27,
      "weeks": [
        {
          "weekNumber": 1,
          "runs": [
            {
              "runNumber": 1,
              "title": "First Steps",
              "description":
                  "5 cycles of 1-min run and 4-min walk for a total of ~25 minutes, starting with a warm-up walk.",
              "totalDurationMinutes": 23,
              "estimatedDistanceKm": 2.5,
              "plannedDate": 1717267200,
              "segments": [
                {
                  "type": "warmup",
                  "duration": 300,
                  "distanceKm": 0.4,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message":
                          "Start with a warm-up walk to get your body ready."
                    }
                  ]
                },
                {
                  "type": "run",
                  "duration": 60,
                  "distanceKm": 0.15,
                  "audio": [
                    {"timeOffset": 0, "message": "Start running"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 240,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Recover with a walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 60,
                  "distanceKm": 0.15,
                  "audio": [
                    {"timeOffset": 0, "message": "Run again"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 240,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Slow down and walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 60,
                  "distanceKm": 0.15,
                  "audio": [
                    {"timeOffset": 0, "message": "Let's run"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 240,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Recover with a walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 60,
                  "distanceKm": 0.15,
                  "audio": [
                    {"timeOffset": 0, "message": "Keep going"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 240,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Slow down and walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 60,
                  "distanceKm": 0.15,
                  "audio": [
                    {"timeOffset": 0, "message": "Final push"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 240,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Great job! Cool down with a walk."
                    }
                  ]
                }
              ]
            },
            {
              "runNumber": 2,
              "title": "Building Momentum",
              "description":
                  "5 cycles of 1.5-min run and 3.5-min walk. Let’s gently push your endurance today!",
              "totalDurationMinutes": 25,
              "estimatedDistanceKm": 2.7,
              "plannedDate": 1717430000, // ~2 days after first run
              "segments": [
                {
                  "type": "warmup",
                  "duration": 300,
                  "distanceKm": 0.4,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Let’s start with a warm-up walk. Stay loose!"
                    }
                  ]
                },
                {
                  "type": "run",
                  "duration": 90,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Start running at a comfortable pace"
                    }
                  ]
                },
                {
                  "type": "walk",
                  "duration": 210,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Recover with a steady walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 90,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Ready? Run again!"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 210,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Great! Walk and breathe"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 90,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Let’s run"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 210,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Recover and slow down"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 90,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Almost there, let’s keep going!"
                    }
                  ]
                },
                {
                  "type": "walk",
                  "duration": 210,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Relax, walk it out"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 90,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Final push, let’s finish strong!"
                    }
                  ]
                },
                {
                  "type": "walk",
                  "duration": 210,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Nice work! Cool down with a walk."
                    }
                  ]
                }
              ]
            },
            {
              "runNumber": 3,
              "title": "Strong Finish",
              "description":
                  "5 cycles of 2-min run and 3-min walk. Time to feel your progress and finish the week strong!",
              "totalDurationMinutes": 25,
              "estimatedDistanceKm": 2.8,
              "plannedDate": 1717602800, // ~2 days after second run
              "segments": [
                {
                  "type": "warmup",
                  "duration": 300,
                  "distanceKm": 0.4,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Warm-up walk. Breathe deeply and relax."
                    }
                  ]
                },
                {
                  "type": "run",
                  "duration": 120,
                  "distanceKm": 0.25,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Start running – find a steady rhythm!"
                    }
                  ]
                },
                {
                  "type": "walk",
                  "duration": 180,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Recover and control your breathing"
                    }
                  ]
                },
                {
                  "type": "run",
                  "duration": 120,
                  "distanceKm": 0.25,
                  "audio": [
                    {"timeOffset": 0, "message": "Let’s run again!"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 180,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Steady walk to recover"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 120,
                  "distanceKm": 0.25,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "You’re getting stronger – keep going!"
                    }
                  ]
                },
                {
                  "type": "walk",
                  "duration": 180,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Ease up and walk"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 120,
                  "distanceKm": 0.25,
                  "audio": [
                    {"timeOffset": 0, "message": "Almost there – stay focused!"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 180,
                  "distanceKm": 0.2,
                  "audio": [
                    {"timeOffset": 0, "message": "Walk it out – final recovery"}
                  ]
                },
                {
                  "type": "run",
                  "duration": 120,
                  "distanceKm": 0.25,
                  "audio": [
                    {"timeOffset": 0, "message": "Final push – finish strong!"}
                  ]
                },
                {
                  "type": "walk",
                  "duration": 180,
                  "distanceKm": 0.2,
                  "audio": [
                    {
                      "timeOffset": 0,
                      "message": "Awesome job! Cool down with a walk."
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    // {
    //   "planId": 2,
    //   "name": "10K",
    //   "description":
    //       "A 12-week intermediate program designed to get you race-ready for a 10K.",
    //   "difficulty": "intermediate",
    //   "duration": "12 weeks",
    //   "sessionsPerWeek": 3,
    //   "totalSessions": 48,
    //   "weeks": []
    // },
    {
      "planId": 3,
      "name": "Half Marathon",
      "description":
          "A 14-week intermediate-to-advanced program for building endurance to conquer 21.1K.",
      "difficulty": "intermediate",
      "duration": "14 weeks",
      "sessionsPerWeek": 3,
      "totalSessions": 56,
      "weeks": []
    },
    {
      "planId": 4,
      "name": "Marathon",
      "description":
          "A 16-week advanced training plan to prepare you for the full marathon distance.",
      "difficulty": "advanced",
      "duration": "16 weeks",
      "sessionsPerWeek": 5,
      "totalSessions": 80,
      "weeks": []
    }
  ]
});
