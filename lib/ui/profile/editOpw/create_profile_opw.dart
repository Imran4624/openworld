import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/constants.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/condition_evaluator.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';

import 'package:flutter_boilerplate/project_config.dart';
import 'package:flutter_boilerplate/redux/app/app_state.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_actions.dart';
import 'package:flutter_boilerplate/redux/dynamicField/dynamic_field_selector.dart';
import 'package:flutter_boilerplate/redux/profile/profile_actions.dart';
import 'package:flutter_boilerplate/redux/ui/ui_actions.dart';
import 'package:flutter_boilerplate/ui/dashboard/dashboard_screen_vm.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_builder.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_submit.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_fields_view_images.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/progress_bar.dart';
import 'package:flutter_boilerplate/ui/profile/editOpw/profile_setup_form.dart';
import 'package:flutter_boilerplate/ui/profile/editOpw/onboarding_questionnaire.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:flutter_boilerplate/ui/dynamic_fields/dynamic_field_load_questions.dart';
import 'package:flutter_boilerplate/main_app.dart';
import 'package:flutter_boilerplate/ui/app/main_screen.dart';

class CreateProfileOpw extends StatefulWidget {
  const CreateProfileOpw({super.key});

  static const String route = '/CreateProfileOpw';

  @override
  _CreateProfileOpwState createState() => _CreateProfileOpwState();
}

class _CreateProfileOpwState extends State<CreateProfileOpw> {
  late Store<AppState> _store;
  int _currentSliderIndex = 0;
  bool _hasViewedSlider = false;
  bool _hasNavigatedAway = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        loadDynamicFieldQuestions(ProjectConfig.onBoardingQuestionType);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store = StoreProvider.of<AppState>(context);
  }

  @override
  void dispose() {
    _store.dispatch(DisposeControllersAction());
    super.dispose();
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  bool _isDataReady(_ViewModel vm) {
    if (vm.questionGroups.isEmpty ||
        vm.currentGroupIndex < 0 ||
        vm.currentGroupIndex >= vm.questionGroups.length) {
      return false;
    }

    final currentGroup = vm.questionGroups[vm.currentGroupIndex];
    final editQuestions = currentGroup.getQuestionsForEdit();

    for (var question in editQuestions) {
      if ((question.isTextType() ||
              question.isCustomWali() ||
              question.isTextAreaType()) &&
          vm.inputFieldControllers[question.id] == null) {
        logError(' Controller not ready for question ${question.id}');
        return false;
      }
    }

    return true;
  }

  Widget _buildCurrentView(List<QuestionModel> visibleQuestions) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) {
        if (vm.isLoading || vm.isSaving) {
          return _buildLoadingWidget();
        }

        if (!_isDataReady(vm)) {
          return _buildLoadingWidget();
        }

        final currentGroup = vm.questionGroups[vm.currentGroupIndex];

        if (currentGroup.id == 'personal_details' && currentGroup.showAllQuestions) {
          return CustomProfileSetupForm(
            currentGroup: currentGroup,
            vm: vm,
            onComplete: () {
              // Move to next group
              vm.moveNext(context);
            },
          );
        }

        if (currentGroup.id == 'personal_preferences') {
          return CustomOnboardingQuestionnaire(
            currentGroup: currentGroup,
            vm: vm,
            onComplete: () {
              _handleSubmit(vm);
            },
            onBack: () {
              vm.movePrevious();
            },
          );
        }

        if (vm.currentQuestionIndex == -1) {
          if (currentGroup.showSlider && !_hasViewedSlider) {
            List<String> sliderImages = [];
            List<String?> sliderTitles = [];
            List<String?> sliderDescriptions = [];

            if (currentGroup.slider != null &&
                currentGroup.slider!['content'] != null &&
                currentGroup.slider!['content'] is List) {
              final contentList = currentGroup.slider!['content'] as List;

              for (var slide in contentList) {
                if (slide is Map && slide.containsKey('image')) {
                  sliderImages.add(slide['image'].toString());
                  sliderTitles.add(slide['title']?.toString());
                  sliderDescriptions.add(slide['description']?.toString());
                }
              }
            }

            if (sliderImages.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _hasViewedSlider = true;
                  });
                }
              });
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: DynamicFieldsViewImages(
                  viewType: ImageViewType.detail,
                  images: sliderImages,
                  titles: sliderTitles,
                  descriptions: sliderDescriptions,
                  showNextImageButton: true,
                  onPageChanged: (index) {
                    setState(() {
                      _currentSliderIndex = index;
                    });
                  },
                  currentIndex: _currentSliderIndex,
                ),
              );
            }
          }

          if (currentGroup.showIntroScreen) {
            return _buildIntroScreen(currentGroup);
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && vm.currentQuestionIndex == -1) {
              vm.moveNext(context);
            }
          });
          return _buildLoadingWidget();
        }
        
        return _buildQuestionView(vm, currentGroup, visibleQuestions);
      },
    );
  }

  Widget _buildIntroScreen(QuestionGroupModel currentGroup) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currentGroup.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          currentGroup.description,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuestionView(_ViewModel vm, QuestionGroupModel currentGroup,
      List<QuestionModel> editQuestions) {
    if (currentGroup.showAllQuestions) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentGroup.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...editQuestions.asMap().entries.map((entry) {
              final question = entry.value;
              final answer = vm.answers[currentGroup.id]?[question.id];
              return Column(
                key: ValueKey('${currentGroup.id}_${question.id}'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        question.label,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 4),
                      if (question.required)
                        const Text(
                          '* Required',
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInputField(
                    question,
                    answer,
                    (value) => vm.updateAnswer(
                      currentGroup.id,
                      question.id,
                      value,
                    ),
                    controller: vm.inputFieldControllers[question.id],
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      );
    } else if (vm.currentQuestionIndex >= 0) {
      if (editQuestions.isEmpty ||
          vm.currentQuestionIndex >= editQuestions.length) {
        return _buildLoadingWidget();
      }

      final currentQuestion = editQuestions[vm.currentQuestionIndex];
      final answer = vm.answers[currentGroup.id]?[currentQuestion.id];

      final controller = vm.inputFieldControllers[currentQuestion.id];
      if (controller == null) {
        logError(
            ' Warning: Controller is null for question ${currentQuestion.id}');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentGroup.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            currentQuestion.label,
            style: const TextStyle(fontSize: 18),
          ),
          if (currentQuestion.required)
            const Text(
              '* Required',
              style: TextStyle(color: Colors.red, fontSize: 11),
            ),
          const SizedBox(height: 8),
          _buildInputField(
            currentQuestion,
            answer,
            (value) => vm.updateAnswer(
              currentGroup.id,
              currentQuestion.id,
              value,
            ),
            controller: controller,
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildInputField(
    QuestionModel question,
    dynamic initialValue,
    void Function(dynamic) onUpdate, {
    TextEditingController? controller,
  }) {
    return buildInputField(
      context,
      question,
      initialValue,
      onUpdate,
      controller: controller,
    );
  }

  void _handleSubmit(_ViewModel vm) async {
    try {
      final result = await FormSubmissionHandler.handleSubmit(
        questionGroups: vm.questionGroups,
        type: DynamicFieldSubmissionType.create,
        answers: vm.answers,
        context: context,
      );
      vm.handleSubmit(result.flatData);
    } catch (e) {
      logError('Error submitting form: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, vm) {
        if (vm.isProfileCompleted && !_hasNavigatedAway) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasNavigatedAway) {
              _hasNavigatedAway = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                MainScreen.route,
                (route) => false,
              );
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.isLoading || vm.isSaving) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_isDataReady(vm)) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentGroup = vm.questionGroups[vm.currentGroupIndex];
        final editQuestions = currentGroup.getQuestionsForEdit();
        List<QuestionModel> visibleQuestions = editQuestions.where((question) {
          final answersMap = vm.answers.map((key, value) => MapEntry(
              key,
              value is BuiltMap<String, dynamic>
                  ? value
                  : BuiltMap<String, dynamic>(value)));

          final builtAnswers = BuiltMap<String, BuiltMap<String, dynamic>>(answersMap);

          return ConditionEvaluator.evaluateCondition(
              question.condition, builtAnswers);
        }).toList();

        if (currentGroup.id == 'personal_details' || currentGroup.id == 'personal_preferences') {
          return Scaffold(
            body: _buildCurrentView(visibleQuestions),
          );
        }

        final isShowingSlider = vm.currentQuestionIndex == -1 &&
            currentGroup.showSlider &&
            !_hasViewedSlider;

        final bool isProfileCreate =
            vm.questionGroupType == ProjectConfig.onBoardingQuestionType;
        final name = vm.questionGroupType.getName();

        return Scaffold(
          appBar: isProfileCreate
              ? null
              : AppBar(
                  title: Text(name),
                  leading: isProfileCreate
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            final store = StoreProvider.of<AppState>(context);
                            store.dispatch(UpdateCurrentRoute(
                                DashboardScreenBuilder.route));
                            if (store.state.prefState.isMobile) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isShowingSlider)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ProfileProgressBar(
                    groups: vm.questionGroups,
                    currentGroupIndex: vm.currentGroupIndex,
                    currentQuestionIndex: vm.currentQuestionIndex,
                    answers: vm.answers,
                    considerAnswers: false,
                  ),
                ),
              Expanded(child: _buildCurrentView(visibleQuestions)),
            ],
          ),
        );
      },
    );
  }
}

class CustomProfileSetupForm extends StatelessWidget {
  final QuestionGroupModel currentGroup;
  final _ViewModel vm;
  final VoidCallback onComplete;

  const CustomProfileSetupForm({
    Key? key,
    required this.currentGroup,
    required this.vm,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileSetupForm(
      initialAnswers: vm.answers[currentGroup.id] ?? {},
      onAnswerUpdate: (questionId, value) {
        vm.updateAnswer(currentGroup.id, questionId, value);
      },
      onComplete: onComplete,
      questions: currentGroup.getQuestionsForEdit(),
    );
  }
}

class CustomOnboardingQuestionnaire extends StatelessWidget {
  final QuestionGroupModel currentGroup;
  final _ViewModel vm;
  final VoidCallback onComplete;
  final VoidCallback? onBack;

  const CustomOnboardingQuestionnaire({
    Key? key,
    required this.currentGroup,
    required this.vm,
    required this.onComplete,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingQuestionnaire(
      questions: currentGroup.getQuestionsForEdit(),
      initialAnswers: vm.answers[currentGroup.id] ?? {},
      onAnswerUpdate: (questionId, value) {
        vm.updateAnswer(currentGroup.id, questionId, value);
      },
      onComplete: onComplete,
      onBack: onBack,
    );
  }
}

class _ViewModel {
  _ViewModel({
    required this.questionGroups,
    required this.answers,
    required this.currentGroupIndex,
    required this.currentQuestionIndex,
    required this.isLoading,
    required this.isSaving,
    required this.canMoveNext,
    required this.moveNext,
    required this.movePrevious,
    required this.handleSubmit,
    required this.updateAnswer,
    required this.inputFieldControllers,
    required this.questionGroupType,
    required this.isProfileCompleted,
  });

  final List<QuestionGroupModel> questionGroups;
  final Map<String, Map<String, dynamic>> answers;
  final int currentGroupIndex;
  final int currentQuestionIndex;
  final bool isLoading;
  final bool isSaving;
  final bool canMoveNext;
  final Function(BuildContext context) moveNext;
  final Function() movePrevious;
  final Function(dynamic) handleSubmit;
  final Function(String, String, dynamic) updateAnswer;
  final Map<String, dynamic> inputFieldControllers;
  final QuestionType questionGroupType;
  final bool isProfileCompleted;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      questionGroups: store.state.dynamicFieldState.questionGroups.toList(),
      questionGroupType: store.state.dynamicFieldState.questionGroupType,
      answers:
          _convertBuiltMapToMap(store.state.dynamicFieldState.answers).toMap(),
      currentGroupIndex: store.state.dynamicFieldState.currentGroupIndex,
      currentQuestionIndex: store.state.dynamicFieldState.currentQuestionIndex,
      isLoading: store.state.isLoading,
      isSaving: store.state.isSaving,
      canMoveNext:
          DynamicFieldSelectors.canMoveNext(store.state.dynamicFieldState),
      moveNext: (context) {
        if (!DynamicFieldSelectors.canMoveNext(store.state.dynamicFieldState)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Please answer all questions')),
          );
          return;
        }

        store.dispatch(MoveNextAction());
      },
      movePrevious: () => store.dispatch(MovePreviousAction()),
      handleSubmit: (profileDetails) async {
        final updatedProfile = store.state.profileUIState.editing?.rebuild((b) {
          final dynamicFields = <String, dynamic>{};
          profileDetails.forEach((key, value) {
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
        
        try {
          await completer.future;
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (store.state.uiState.currentRoute == CreateProfileOpw.route) {
            store.dispatch(DisposeControllersAction());
            
            Navigator.of(navigatorKey.currentContext!).pushNamedAndRemoveUntil(
              MainScreen.route, 
              (route) => false,
            );
          }
        } catch (error) {
          logError('Error completing profile submission: $error');
        }
      },
      updateAnswer: (groupId, questionId, value) =>
          store.dispatch(UpdateAnswerAction(groupId, questionId, value)),
      inputFieldControllers:
          store.state.dynamicFieldState.inputFieldControllers,
      isProfileCompleted: store.state.authState.setProfileCompleted || 
          store.state.profileState.loggedInUserProfile.isProfileCompleted,
    );
  }

  static BuiltMap<String, Map<String, dynamic>> _convertBuiltMapToMap(
      BuiltMap<String, BuiltMap<String, dynamic>> builtMap) {
    return builtMap.map(
      (key, value) => MapEntry(key, value.toMap()),
    );
  }
}
