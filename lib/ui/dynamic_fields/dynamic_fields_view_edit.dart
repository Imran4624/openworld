import 'dart:async';
import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/condition_evaluator.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/data/models/profile_model.dart';
import 'package:flutter_boilerplate/data/models/static/app_theme.dart';
import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/services/session_managment_service.dart';
import 'package:flutter_boilerplate/ui/app/copy_to_clipboard.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_builder.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_submit.dart';
import 'package:flutter_boilerplate/ui/profile/edit/profile_edit_vm.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_field_drived_values.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_fields_display_value_for_edit.dart';
import 'package:flutter_boilerplate/utils/dynamic_fields/dynamic_fields_validator.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';

class EditOverviewScreen extends StatefulWidget {
  const EditOverviewScreen({super.key});

  static const String route = '/editDynamicFieldScreenScreen';

  @override
  State<EditOverviewScreen> createState() => _EditOverviewScreenState();
}

class _EditOverviewScreenState extends State<EditOverviewScreen> {
  Map<String, dynamic> _currentAnswers = {};

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        final state = store.state.dynamicFieldState;
        return _ViewModel(
          questionGroups: state.questionGroups.toList(),
          questionGroupType: state.questionGroupType,
          answers: state.savedAnswers,
          onSave: (data) {
            printL('update profile data ==> $data');
            final updatedProfile =
                store.state.profileUIState.editing?.rebuild((b) {
              final dynamicFields = <String, dynamic>{};
              data.forEach((key, value) {
                if (value is List) {
                  dynamicFields[key] = value.map((e) => e.toString()).toList();
                } else if (value is Map) {
                  dynamicFields[key] = Map<String, dynamic>.from(value);
                } else {
                  dynamicFields[key] = value;
                }
              });

              return b
                ..email = store.state.authState.email
                ..dynamicFields.clear()
                ..dynamicFields.addAll(dynamicFields);
            });

            final completer = Completer();
            store.dispatch(SaveProfileRequest(
              profile: updatedProfile,
              completer: completer,
            ));
          },
          updateAnswer: (groupId, questionId, value) =>
              store.dispatch(UpdateAnswerAction(groupId, questionId, value)),
        );
      },
      builder: (context, vm) {
        if (vm.questionGroups.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Initialize current answers if empty
        if (_currentAnswers.isEmpty) {
          _currentAnswers = Map<String, dynamic>.from(vm.answers);
        }

        final sortedGroups = List<QuestionGroupModel>.from(vm.questionGroups);
        sortedGroups.sort((a, b) => a.viewOrder.compareTo(b.viewOrder));

        final name = vm.questionGroupType.getName();
        
        // Convert current answers (including edited ones) to BuiltMap format for condition evaluation
        final builtAnswers = _convertToBuiltMap(_currentAnswers, vm.questionGroups);
        
        Future<void> editQuestion(BuildContext context,
            QuestionGroupModel group, QuestionModel question) async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditQuestionScreen(
                group: group,
                question: question,
                initialValue: _currentAnswers[question.id] ?? vm.answers[question.id],
              ),
            ),
          );

          if (result != null) {
            setState(() {
              _currentAnswers[question.id] = result;
            });
          }
        }

        final store = StoreProvider.of<AppState>(context);
        final profileBeingEdited = store.state.uiState.currentRoute.contains(ProfileEditScreen.route) ;
        
        final bool isProfileEdit = ProjectConfig.appType == AppType.boilerplate ? false :
          vm.questionGroupType == ProjectConfig.onBoardingQuestionType;
        
       

        return Scaffold(
          appBar: isProfileEdit || profileBeingEdited ? null : AppBar(title: Text(name)),
          body: Stack(
            children: [
              Form(
                key: ValueKey('edit_form_${vm.questionGroupType}'),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sortedGroups.length,
                        itemBuilder: (context, index) {
                          final group = sortedGroups[index];
                          if (group.viewOrder == -1) {
                            return const SizedBox.shrink();
                          }

                          final allQuestions = group.getQuestionsForEdit().toList();
                          allQuestions.sort((a, b) => a.editOrder.compareTo(b.editOrder));

                          // Filter questions based on conditions using current answers
                          final visibleQuestions = allQuestions.where((question) {
                            return ConditionEvaluator.evaluateCondition(
                              question.condition, 
                              builtAnswers
                            );
                          }).toList();

                          if (visibleQuestions.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Use visibleQuestions instead of allQuestions
                              ...visibleQuestions.map((question) {
                                final answer = _currentAnswers[question.id] ?? vm.answers[question.id];
                                return Card(
                                  child: ListTile(
                                    title: Text(question.label),
                                    subtitle: Text(
                                        getDisplayValueForEditOverviewScreen(
                                            question, answer)),
                                    trailing: const Icon(Icons.edit),
                                    onTap: () {
                                      editQuestion(context, group, question);
                                    },
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                            colors: [Colors.transparent, Colors.white],
                            stops: [0.0, 0.3],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      FormSubmissionHandler.handleSubmit(
                        questionGroups: vm.questionGroups,
                        type: DynamicFieldSubmissionType.edit,
                        answers: _currentAnswers, // Use current answers instead of vm.answers
                        context: context,
                      ).then((result) {
                        printL('result data=> $result');
                        vm.onSave(result.flatData);
                      }).catchError((error) {
                        printL(error);
                      });
                    },
                    child: const Text(
                      'Submit',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static BuiltMap<String, BuiltMap<String, dynamic>> _convertToBuiltMap(
      Map<String, dynamic> answers, List<QuestionGroupModel> questionGroups) {
    final builder = MapBuilder<String, BuiltMap<String, dynamic>>();
    
    final Map<String, String> questionToGroupMap = {};
    for (var group in questionGroups) {
      for (var question in group.questions) {
        questionToGroupMap[question.id] = group.id;
      }
    }
    
    final Map<String, Map<String, dynamic>> groupedAnswers = {};
    answers.forEach((questionId, answer) {
      final groupId = questionToGroupMap[questionId] ?? 'default';
      groupedAnswers.putIfAbsent(groupId, () => {});
      groupedAnswers[groupId]![questionId] = answer;
    });
    
    groupedAnswers.forEach((groupId, groupAnswers) {
      final groupBuilder = MapBuilder<String, dynamic>();
      groupAnswers.forEach((questionId, answer) {
        groupBuilder[questionId] = answer;
      });
      builder[groupId] = groupBuilder.build();
    });
    
    return builder.build();
  }
}

class EditQuestionScreen extends StatefulWidget {
  const EditQuestionScreen({
    super.key,
    required this.group,
    required this.question,
    this.initialValue,
  });

  final QuestionGroupModel group;
  final QuestionModel question;
  final dynamic initialValue;

  @override
  _EditQuestionScreenState createState() => _EditQuestionScreenState();
}

class _EditQuestionScreenState extends State<EditQuestionScreen> {
  late TextEditingController _textController;
  dynamic _currentValue;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue is Map<String, dynamic>) {
      final initialValue = widget.initialValue as Map<String, dynamic>;
      _textController = TextEditingController(
        text: initialValue['email']?.toString() ??
            initialValue['name']?.toString() ??
            '',
      );
      _currentValue = initialValue['name']?.toString() ?? initialValue;
    } else {
      _textController = TextEditingController(
        text: widget.initialValue?.toString() ?? '',
      );
      _currentValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Widget _buildInputField() {
    return buildInputField(
      context,
      widget.question,
      _currentValue,
      (value) => setState(() => _currentValue = value),
      controller: _textController,
    );
  }

  void _handleSave() {
    if (!validateInput(widget.question, _currentValue, context)) {
      return;
    }

    Navigator.pop(context, _currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.question.label}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final store = StoreProvider.of<AppState>(context);
            store.dispatch(UpdateCurrentRoute(DashboardScreenBuilder.route));
            if (store.state.prefState.isMobile) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Center(
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInputField(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppTheme.light.defaultColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppTheme.dark.text),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _handleSave,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  _ViewModel({
    required this.questionGroups,
    required this.answers,
    required this.onSave,
    required this.updateAnswer,
    required this.questionGroupType,
  });
  final List<QuestionGroupModel> questionGroups;
  final Map<String, dynamic> answers;
  final Function(Map<String, dynamic>) onSave;
  final Function(String, String, dynamic) updateAnswer;
  final QuestionType questionGroupType;
}

Widget buildFormattedDataView(dynamic profile, BuildContext context) {
  if (profile.dynamicFields.isEmpty) {
    return const SizedBox.shrink();
  }

  final store = StoreProvider.of<AppState>(context);
  final questionGroups = store.state.dynamicFieldState.questionGroups;

  final sortedGroups = questionGroups
      .toList()
      .where((group) => group.viewOrder != -1)
      .toList();
  sortedGroups.sort((a, b) => a.viewOrder.compareTo(b.viewOrder));

  final Map<String, QuestionModel> questionMap = {};
  final Map<String, String> groupMap = {};
  final Set<String> questionsWithDrivesViewFields = {};

  for (var group in sortedGroups) {
    final questions = group.questions
        .toList()
        .where(
            (q) => q.viewOrder != -1 || q.drivesViewFields?.isNotEmpty == true)
        .toList();
    questions.sort((a, b) => a.viewOrder.compareTo(b.viewOrder));

    for (var question in questions) {
      questionMap[question.id] = question;
      groupMap[question.id] = group.name;
      if (question.drivesViewFields != null &&
          question.drivesViewFields!.isNotEmpty) {
        questionsWithDrivesViewFields.add(question.id);
      }
    }
  }

  final Map<String, dynamic> derivedValues = {};
  for (var question in questionMap.values) {
    if (question.drivesViewFields != null &&
        question.drivesViewFields!.isNotEmpty) {
      final currentValue = profile.dynamicFields[question.id];

      for (var driveField in question.drivesViewFields!) {
        final targetQuestion = questionMap[driveField.id];
        if (targetQuestion == null) continue;

        final derivedValue = _calculateDerivedValue(
          logic: driveField.logic,
          currentValue: currentValue,
          profile: profile,
          context: context,
        );

        if (derivedValue != null) {
          derivedValues[driveField.id] = derivedValue;
        }
      }
    }
  }

  final Map<String, dynamic> allFields = {}
    ..addEntries(profile.dynamicFields.entries
        .where((entry) => !questionsWithDrivesViewFields.contains(entry.key)))
    ..addAll(derivedValues);

  final Map<String, List<MapEntry<String, dynamic>>> groupedFields = {};

  allFields.entries.forEach((entry) {
    final fieldId = entry.key;

    if (groupMap.containsKey(fieldId)) {
      final groupName = groupMap[fieldId];
      groupedFields.putIfAbsent(groupName!, () => []);
      groupedFields[groupName]!.add(entry);
    }
  });

  final List<String> orderedGroupNames = [];
  for (var group in sortedGroups) {
    if (groupedFields.containsKey(group.name)) {
      orderedGroupNames.add(group.name);
    }
  }

  if (orderedGroupNames.isEmpty) {
    return const SizedBox.shrink();
  }

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: orderedGroupNames.map((groupName) {
        final entries = groupedFields[groupName]!;

        entries.sort((a, b) {
          final questionA = questionMap[a.key];
          final questionB = questionMap[b.key];
          if (questionA == null || questionB == null) {
            return 0;
          }
          return questionA.viewOrder.compareTo(questionB.viewOrder);
        });

        final List<Widget> groupWidgets = [];

        if (orderedGroupNames.indexOf(groupName) == 0 &&
            isAdmin(store.state)) {
          if(profile.id.isNotEmpty) {
          groupWidgets.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Profile Id',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: CopyToClipboard(
                    value: profile.id.toString(),
                    child: Text(
                      profile.id.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ));}
          if(profile.email.isNotEmpty) {
          groupWidgets.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: CopyToClipboard(
                    value: profile.email.toString(),
                    child: Text(
                      profile.email.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ));
          }
        }

        groupWidgets.addAll(entries.map((entry) {
          final fieldId = entry.key;
          final value = entry.value;
          final question = questionMap[fieldId];

          if (question == null) {
            return SizedBox.shrink();
          }

          if (fieldId == DynamicFieldsConstants.socialLinks &&
              !isAdmin(store.state)) {
            return SizedBox.shrink();
          }

          if (question.isDocument()) {
            return SizedBox.shrink();
          }

          if (question.isAgeType()) {
            return _buildAgeField(question, profile, context);
          }

          if (question.isTagsType()) {
            return _buildTagsField(question, value, context);
          }

          if (question.isListType() ||
              question.isDropdown() ||
              question.isRadio()) {
            return _buildOptionField(question, value);
          }

          return _buildDefaultField(question.label, value);
        }).toList());

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      groupName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ...groupWidgets,
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildDefaultField(String label, dynamic value) {
  final bool isSocialLink = label == "Social Links";
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        isSocialLink
            ? Expanded(
                flex: 3,
                child: CopyToClipboard(
                  value: value.toString(),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            : Expanded(
                flex: 3,
                child: Text(
                  value.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
      ],
    ),
  );
}

dynamic _calculateDerivedValue({
  required String logic,
  required dynamic currentValue,
  required ProfileEntity profile,
  required BuildContext context,
}) {
  switch (logic) {
    case 'calculateAgeFromDob':
      if (currentValue is String) {
        try {
          final dob = DateTime.parse(currentValue);
          return DerivedFieldUtils.calculateAge(dob).toString();
        } catch (_) {
          return null;
        }
      }
      return null;
    default:
      return null;
  }
}

Widget _buildAgeField(
    QuestionModel question, ProfileEntity profile, BuildContext context) {
  try {
    DateTime? dob = profile.dynamicFields[DynamicFieldsConstants.dob] != null
        ? DateTime.parse(
            profile.dynamicFields[DynamicFieldsConstants.dob].toString())
        : null;

    if (dob != null) {
      int age = DerivedFieldUtils.calculateAge(dob);
      return _buildDefaultField(DynamicFieldsConstants.age, age.toString());
    }
  } catch (_) {}
  return _buildDefaultField(question.label, 'N/A');
}

Widget _buildTagsField(
    QuestionModel question, dynamic value, BuildContext context) {
  List<String> tags = [];
  if (value is List) {
    tags = value.map((v) => v.toString()).toList();
  } else if (value is String) {
    tags = value.split(', ');
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            Map<String, dynamic>? tagOption;
            try {
              tagOption = (question.options as List).firstWhere(
                (option) => option['label'] == tag,
              ) as Map<String, dynamic>;
            } catch (_) {
              tagOption = {'label': tag};
            }

            return Chip(
              avatar: tagOption.containsKey('icon') && tagOption['icon'] != null
                  ? Icon(
                      tagOption['icon'] as IconData,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              label: Text(tag),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              labelStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

Widget _buildOptionField(QuestionModel question, dynamic value) {
  List<String> displayValues = [];
  final valueList = value is String
      ? value.split(',').map((v) => v.trim()).toList()
      : (value is List ? value : [value]);

  for (var selectedValue in valueList) {
    try {
      final options = question.options as List;
      final option = options.firstWhere(
        (option) =>
            option[question.selectedField ?? 'value'].toString() ==
            selectedValue.toString(),
      );
      displayValues.add(option[question.showField ?? 'name'].toString());
    } catch (_) {
      displayValues.add(selectedValue.toString());
    }
  }

  return _buildDefaultField(question.label, displayValues.join(", "));
}
