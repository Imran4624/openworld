import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/condition_evaluator.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProfileProgressBar extends StatelessWidget {
  final List<QuestionGroupModel> groups;
  final int currentGroupIndex;
  final int currentQuestionIndex;
  final Map<String, Map<String, dynamic>> answers;
  final bool considerAnswers;
  const ProfileProgressBar(
      {super.key,
      required this.groups,
      required this.currentGroupIndex,
      required this.currentQuestionIndex,
      required this.answers,
      this.considerAnswers = false});

  double _calculateGroupProgress(QuestionGroupModel group, int groupIndex) {
    if (considerAnswers) {
      return _calculateGroupProgressBasedOnAnswers(group);
    }
    return _calculateGroupProgressBasedOnQuestionsProgress(group, groupIndex);
  }

  double _calculateGroupProgressBasedOnQuestionsProgress(
      QuestionGroupModel group, int groupIndex) {
    // If we've moved past this group, it's 100% complete
    if (groupIndex < currentGroupIndex) return 1.0;

    // If it's a future group, it's 0% complete
    if (groupIndex > currentGroupIndex) return 0.0;

    // For current group, calculate based on current question index
    final allQuestions = group.getQuestionsForEdit();
    
    final builtAnswers = _convertToBuiltMap(answers);
    
    final visibleQuestions = allQuestions.where((question) {
      return ConditionEvaluator.evaluateCondition(question.condition, builtAnswers);
    }).toList();

    if (visibleQuestions.isEmpty) return 0.0;

    // Include intro screen in progress calculation
    final totalSteps = group.showIntroScreen || group.showSlider
        ? visibleQuestions.length + 1
        : visibleQuestions.length;
    
    int currentStep = 0; 
    if (currentQuestionIndex == -1) {
      currentStep = group.showIntroScreen || group.showSlider ? 1 : 0;
    } else {
      final currentQuestion = allQuestions.length > currentQuestionIndex 
          ? allQuestions[currentQuestionIndex] 
          : null;
      
      if (currentQuestion == null) {
        currentStep = totalSteps;
      } else {
        final visibleIndex = visibleQuestions.indexWhere((q) => q.id == currentQuestion.id);
        if (visibleIndex >= 0) {
          currentStep = visibleIndex + (group.showIntroScreen || group.showSlider ? 2 : 1);
        } else {
          bool found = false;
          for (int i = currentQuestionIndex + 1; i < allQuestions.length; i++) {
            final nextQuestion = allQuestions[i];
            final nextVisibleIdx = visibleQuestions.indexWhere((q) => q.id == nextQuestion.id);
            if (nextVisibleIdx >= 0) {
              currentStep = nextVisibleIdx + (group.showIntroScreen || group.showSlider ? 2 : 1);
              found = true;
              break;
            }
          }
          if (!found) {
            currentStep = totalSteps;
          }
        }
      }
    }
    
    return (currentStep / totalSteps).clamp(0.0, 1.0);
  }

  double _calculateGroupProgressBasedOnAnswers(QuestionGroupModel group) {
    final allQuestions = group.getQuestionsForEdit();
    
    final builtAnswers = _convertToBuiltMap(answers);
    
    final visibleQuestions = allQuestions.where((question) {
      return ConditionEvaluator.evaluateCondition(question.condition, builtAnswers);
    }).toList();

    if (visibleQuestions.isEmpty) return 0.0;

    int answeredCount = 0;
    for (var question in visibleQuestions) {
      if (answers[group.id]?[question.id] != null) {
        answeredCount++;
      }
    }

    return answeredCount / visibleQuestions.length;
  }

  BuiltMap<String, BuiltMap<String, dynamic>> _convertToBuiltMap(Map<String, Map<String, dynamic>> answers) {
    final builder = MapBuilder<String, BuiltMap<String, dynamic>>();
    
    answers.forEach((groupId, groupAnswers) {
      final groupBuilder = MapBuilder<String, dynamic>();
      groupAnswers.forEach((questionId, answer) {
        groupBuilder[questionId] = answer;
      });
      builder[groupId] = groupBuilder.build();
    });
    
    return builder.build();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final store = StoreProvider.of<AppState>(context);

    final isDarkMode = store.state.prefState.enableDarkMode;
    final themeColors = isDarkMode ? AppTheme.dark : AppTheme.light;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(groups.length * 2 - 1, (index) {
              if (index.isOdd) {
                return const SizedBox(width: 4);
              }

              final groupIndex = index ~/ 2;
              final group = groups[groupIndex];
              final progress = _calculateGroupProgress(group, groupIndex);
              final isActive = groupIndex <= currentGroupIndex;

              return Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: themeColors.defaultColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.centerLeft,
                      widthFactor: isActive
                          ? (groupIndex < currentGroupIndex ? 1.0 : progress)
                          : 0.0,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: themeColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          if (isLargeScreen) ...[
            const SizedBox(height: 8),
            Row(
              children: List.generate(groups.length * 2 - 1, (index) {
                if (index.isOdd) {
                  return const SizedBox(width: 4);
                }

                final groupIndex = index ~/ 2;
                final group = groups[groupIndex];

                return Expanded(
                  child: Text(
                    group.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: groupIndex <= currentGroupIndex
                          ? themeColors.primary
                          : themeColors.text,
                      fontWeight: groupIndex == currentGroupIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}
