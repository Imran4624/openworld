import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/data/models/dynamic_fields/dynamic_fields_modal.dart';
import 'package:flutter_boilerplate/ui/app/shared.dart';
import 'package:hugeicons/hugeicons.dart';

class OnboardingQuestionnaire extends StatefulWidget {
  final List<QuestionModel> questions;
  final Map<String, dynamic> initialAnswers;
  final Function(String, dynamic) onAnswerUpdate;
  final VoidCallback onComplete;
  final VoidCallback? onBack;

  const OnboardingQuestionnaire({
    super.key,
    this.questions = const [],
    this.initialAnswers = const {},
    required this.onAnswerUpdate,
    required this.onComplete,
    this.onBack,
  });

  @override
  _OnboardingQuestionnaireState createState() =>
      _OnboardingQuestionnaireState();
}

class _OnboardingQuestionnaireState extends State<OnboardingQuestionnaire> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _totalQuestions = 6;

  final Map<int, Set<String>> _selectedAnswers = {};

  late List<QuestionData> _questions;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    for (int i = 0; i < _totalQuestions; i++) {
      _selectedAnswers[i] = <String>{};
    }
    _loadInitialAnswers();
  }

  void _initializeQuestions() {
    if (widget.questions.isEmpty) {
      _questions = [];
      _totalQuestions = 0;
      return;
    }

    _questions = widget.questions.asMap().entries.map((entry) {
      final index = entry.key;
      final question = entry.value;

      final Map<String, IconData> iconMap = {
        // Question 1 - Event Preference
        'Music': HugeIcons.strokeRoundedMusicNote01,
        'NightLife': HugeIcons.strokeRoundedDrink,
        'Art': HugeIcons.strokeRoundedBrush,
        'Food': HugeIcons.strokeRoundedRestaurant01,
        'Pop-ups': HugeIcons.strokeRoundedBriefcase01,
        'Gathering': HugeIcons.strokeRoundedUserGroup,
        'Meet new people': HugeIcons.strokeRoundedUserMultiple,
        'Learn something new': HugeIcons.strokeRoundedBook01,
        'Enjoy a Hobby': HugeIcons.strokeRoundedSmile,
        'Rolex with friends': HugeIcons.strokeRoundedCoffee01,
        'Career connections': HugeIcons.strokeRoundedBriefcase01,
        'Solo': HugeIcons.strokeRoundedUser,
        'Friends': HugeIcons.strokeRoundedUserGroup,
        'Crowds': HugeIcons.strokeRoundedUserMultiple,
        'Small groups': HugeIcons.strokeRoundedUserMultiple,
        'Morning': HugeIcons.strokeRoundedSun01,
        'Afternoon': HugeIcons.strokeRoundedSun01,
        'Evening': HugeIcons.strokeRoundedCoffee01,
        'Night': HugeIcons.strokeRoundedMoon02,
        'Discover': HugeIcons.strokeRoundedSearch01,
        'Meet people': HugeIcons.strokeRoundedUserMultiple,
        'Feel like a local': HugeIcons.strokeRoundedLocation01,
        'Be an urban explorer': HugeIcons.strokeRoundedCompass,
        'High-Energy': HugeIcons.strokeRoundedFlash,
        'Relaxed & Intimate': HugeIcons.strokeRoundedCoffee01,
        'Intellectual': HugeIcons.strokeRoundedBrain,
        'Creative': HugeIcons.strokeRoundedBrush,
        'Adventurous': HugeIcons.strokeRoundedMountain,
      };

      final gradients = [
        [
          const Color(0xFF1A1A2E),
          const Color(0xFF16213E),
          const Color(0xFFE94560),
          const Color(0xFFFF6B35)
        ],
        [
          const Color(0xFFBB377D),
          const Color(0xFFE91E63),
          const Color(0xFFFF5722),
          const Color(0xFFFF8A65)
        ],
        [
          const Color(0xFFFF5722),
          const Color(0xFFE91E63),
          const Color(0xFF673AB7),
          const Color(0xFF3F51B5)
        ],
        [
          const Color(0xFFFF6B35),
          const Color(0xFFE94560),
          const Color(0xFFBB377D),
          const Color(0xFF8E24AA)
        ],
        [
          const Color(0xFFE94560),
          const Color(0xFFBB377D),
          const Color(0xFF8E24AA),
          const Color(0xFF673AB7)
        ],
        [
          const Color(0xFFE91E63),
          const Color(0xFFE94560),
          const Color(0xFFFF5722),
          const Color(0xFFFF6B35)
        ],
      ];

      List<OptionData> options = [];

      try {
        if (question.options != null) {
          final optionsList = question.options as List<dynamic>;
          options = optionsList.map<OptionData>((option) {
            final optionMap = option as Map<String, dynamic>;
            final name = optionMap['name']?.toString() ?? '';
            return OptionData(
              icon: iconMap[name] ?? Icons.help_outline,
              label: name,
            );
          }).toList();
        }
      } catch (e) {
        logError('Error parsing options for question ${question.label}: $e');
        options = [];
      }

      return QuestionData(
        questionNumber: index + 1,
        title: question.label,
        options: options,
        gradientColors: gradients[index % gradients.length],
      );
    }).toList();
    
    _totalQuestions = _questions.length;
  }

  void _loadInitialAnswers() {
    widget.initialAnswers.forEach((key, value) {
      final questionIndex = widget.questions.indexWhere((q) => q.id == key);
      if (questionIndex >= 0 && value != null) {
        if (value is List) {
          _selectedAnswers[questionIndex] =
              Set<String>.from(value.map((e) => e.toString()));
        } else {
          _selectedAnswers[questionIndex] = {value.toString()};
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (!_isCurrentQuestionAnswered()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_currentPage < _totalQuestions - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      if (widget.onBack != null) {
        widget.onBack!();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _completeQuestionnaire() {
    _selectedAnswers.forEach((index, selectedValues) {
      if (index < widget.questions.length) {
        final question = widget.questions[index];
        if (selectedValues.isNotEmpty) {
          if (selectedValues.length == 1) {
            widget.onAnswerUpdate(question.id, selectedValues.first);
          } else {
            widget.onAnswerUpdate(question.id, selectedValues.toList());
          }
        }
      }
    });

    widget.onComplete();
  }

  void _toggleSelection(String option) {
    setState(() {
      if (_selectedAnswers[_currentPage]!.contains(option)) {
        _selectedAnswers[_currentPage]!.remove(option);
      } else {
        _selectedAnswers[_currentPage]!.add(option);
      }
    });

    if (_currentPage < widget.questions.length) {
      final question = widget.questions[_currentPage];
      final selectedValues = _selectedAnswers[_currentPage]!;
      if (selectedValues.isNotEmpty) {
        if (selectedValues.length == 1) {
          widget.onAnswerUpdate(question.id, selectedValues.first);
        } else {
          widget.onAnswerUpdate(question.id, selectedValues.toList());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
          ),
          child: const Center(
            child: Text(
              'No questions available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _totalQuestions,
        itemBuilder: (context, index) {
          if (index >= _questions.length) {
            return const SizedBox.shrink();
          }
          return _buildQuestionPage(_questions[index]);
        },
      ),
    );
  }

  Widget _buildQuestionPage(QuestionData question) {
    if (question.questionNumber == 7) {
      return _buildQuestion7Page();
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              'assets/opw/questionsBackgrounds/question${question.questionNumber}.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.25),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.black.withOpacity(0.15),
                                Colors.black.withOpacity(0.25),
                              ],
                              stops: const [0.3, 1.0],
                            ),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white
                                    .withOpacity(0.15), 
                                Colors.transparent,
                                Colors.transparent,
                                Colors.white.withOpacity(
                                    0.08), 
                              ],
                              stops: const [0.0, 0.4, 0.6, 1.0],
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(21.5),
                            onTap: _previousPage,
                            child: const SizedBox(
                              width: 43,
                              height: 43,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildStackedCards(question),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.25),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.25),
                            ],
                            stops: const [0.3, 1.0],
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white
                                  .withOpacity(0.15), 
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withOpacity(
                                  0.08), 
                            ],
                            stops: const [0.0, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(21.5),
                          onTap:
                              _isCurrentQuestionAnswered() ? _nextPage : null,
                          child: SizedBox(
                            width: 43,
                            height: 43,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: _isCurrentQuestionAnswered()
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackedCards(QuestionData question) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ...List.generate(
              (_totalQuestions - _currentPage - 1).clamp(0, 4),
              (index) {
                final cardIndex = index + 1;
                final offsetY = cardIndex == 1? -10.0 : -10 + (cardIndex - 1) * 15.0; // Connected positioning
                final offsetX = cardIndex * 7.0;

                return Positioned(
                  bottom: -offsetY,
                  left: offsetX,
                  right: offsetX,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardIndex==1? 24 : 30),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent, 
                          Colors.black.withOpacity(0.10), 
                        ],
                        stops: const [0.0, 0.5], 
                      ),
                     border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.08),
                          width: 1.0,
                        ),
                      ),
                  ),
                ),
                );
              },
            ).reversed,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: maxHeight - 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.08),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(_getCardPadding(maxWidth)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QUESTION: ${question.questionNumber}',
                          style: TextStyle(
                            fontSize: _getQuestionLabelSize(maxWidth),
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: _getQuestionLabelSpacing(maxWidth)),
                        Text(
                          question.title,
                          style: TextStyle(
                            fontSize: _getQuestionTitleSize(maxWidth),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: _getQuestionTitleSpacing(maxWidth)),
                        Expanded(
                          child: _buildOptionsGrid(question.options, maxWidth),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _totalQuestions,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: EdgeInsets.symmetric(
                                    horizontal: maxWidth > 800 ? 5.0 : 4.0),
                                height: _currentPage == dotIndex
                                    ? _getPageIndicatorSize(maxWidth)
                                    : _getPageIndicatorSize(maxWidth) - 2,
                                width: _currentPage == dotIndex
                                    ? _getPageIndicatorSize(maxWidth)
                                    : _getPageIndicatorSize(maxWidth) - 2,
                                decoration: BoxDecoration(
                                  color: _currentPage == dotIndex
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: SelectiveBorderPainter(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.0,
                        borderRadius: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionsGrid(List<OptionData> options, double maxWidth) {
    int crossAxisCount;
    double childAspectRatio;
    double spacing;

    if (maxWidth > 1200) {
      crossAxisCount = 3;
      childAspectRatio = 1.8;
      spacing = 16.0;
    } else if (maxWidth > 800) {
      crossAxisCount = 3;
      childAspectRatio = 1.6;
      spacing = 12.0;
    } else if (maxWidth > 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.7;
      spacing = 12.0;
    } else {
      crossAxisCount = 2;
      childAspectRatio = 1.5;
      spacing = 10.0;
    }

    bool hasOddCount = options.length % crossAxisCount != 0;
    List<OptionData> gridOptions =
        hasOddCount ? options.sublist(0, options.length - 1) : options;
    OptionData? lastOption = hasOddCount ? options.last : null;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          if (gridOptions.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: gridOptions.length,
              itemBuilder: (context, index) {
                return _buildOptionCard(gridOptions[index], maxWidth);
              },
            ),
          if (lastOption != null) ...[
            SizedBox(height: spacing),
            _buildFullWidthOption(lastOption, childAspectRatio, maxWidth),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionCard(OptionData option, double maxWidth) {
    final isSelected = _selectedAnswers[_currentPage]!.contains(option.label);

    return GestureDetector(
      onTap: () {
        _toggleSelection(option.label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(_getOptionPadding(maxWidth)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  option.icon,
                  size: _getIconSize(maxWidth),
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: _getFontSize(maxWidth),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthOption(
      OptionData option, double aspectRatio, double maxWidth) {
    final isSelected = _selectedAnswers[_currentPage]!.contains(option.label);

    return GestureDetector(
      onTap: () {
        _toggleSelection(option.label);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(
          minHeight: _getFullWidthOptionHeight(maxWidth, aspectRatio),
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Colors.white,
                  width: 2,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(_getOptionPadding(maxWidth)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(
                  option.icon,
                  size: _getIconSize(maxWidth),
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: _getFontSize(maxWidth),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getOptionPadding(double maxWidth) {
    if (maxWidth > 1200) return 18.0;
    if (maxWidth > 800) return 16.0;
    if (maxWidth > 600) return 12.0;
    return 12.0;
  }

  double _getIconSize(double maxWidth) {
    if (maxWidth > 1200) return 26.0;
    if (maxWidth > 800) return 24.0;
    if (maxWidth > 600) return 22.0;
    return 20.0;
  }

  double _getFontSize(double maxWidth) {
    if (maxWidth > 1200) return 16.0;
    if (maxWidth > 800) return 15.0;
    if (maxWidth > 600) return 14.0;
    return 13.0;
  }

  double _getFullWidthOptionHeight(double maxWidth, double aspectRatio) {
    if (maxWidth > 1200) return 120 / aspectRatio;
    if (maxWidth > 800) return 110 / aspectRatio;
    if (maxWidth > 600) return 100 / aspectRatio;
    return 90 / aspectRatio;
  }

  double _getQuestionLabelSize(double maxWidth) {
    if (maxWidth > 1200) return 16.0;
    if (maxWidth > 800) return 15.0;
    if (maxWidth > 600) return 14.0;
    return 12.0;
  }

  double _getQuestionLabelSpacing(double maxWidth) {
    if (maxWidth > 1200) return 16.0;
    if (maxWidth > 800) return 14.0;
    if (maxWidth > 600) return 12.0;
    return 10.0;
  }

  double _getQuestionTitleSize(double maxWidth) {
    if (maxWidth > 1200) return 36.0;
    if (maxWidth > 800) return 32.0;
    if (maxWidth > 600) return 30.0;
    return 26.0;
  }

  double _getQuestionTitleSpacing(double maxWidth) {
    if (maxWidth > 1200) return 32.0;
    if (maxWidth > 800) return 28.0;
    if (maxWidth > 600) return 24.0;
    return 20.0;
  }

  double _getCardPadding(double maxWidth) {
    if (maxWidth > 1200) return 32.0;
    if (maxWidth > 800) return 28.0;
    if (maxWidth > 600) return 24.0;
    return 20.0;
  }

  bool _isCurrentQuestionAnswered() {
    if (_currentPage >= widget.questions.length) return true;

    final currentQuestion = widget.questions[_currentPage];
    if (!currentQuestion.required) return true;

    final selectedAnswers = _selectedAnswers[_currentPage];
    return selectedAnswers != null && selectedAnswers.isNotEmpty;
  }

  Widget _buildQuestion7Page() {
    final question7Data = QuestionData(
      questionNumber: 7,
      title: 'Event Role?',
      options: [],
      gradientColors: [],
    );

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/opw/questionsBackgrounds/question7.webp'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.25),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.black.withOpacity(0.15),
                                Colors.black.withOpacity(0.25),
                              ],
                              stops: const [0.3, 1.0],
                            ),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Container(
                          width: 43,
                          height: 43,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.15),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.white.withOpacity(0.08),
                              ],
                              stops: const [0.0, 0.4, 0.6, 1.0],
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(21.5),
                            onTap: _previousPage,
                            child: const SizedBox(
                              width: 43,
                              height: 43,
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildStackedCardsForQuestion7(question7Data),
              ),
              const SizedBox(height: 32),
              const Text(
                'Unlock your city',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Container(
                  width: 43,
                  height: 43,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.25),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.25),
                            ],
                            stops: const [0.3, 1.0],
                          ),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Container(
                        width: 43,
                        height: 43,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white.withOpacity(0.08),
                            ],
                            stops: const [0.0, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(21.5),
                          onTap:
                              _isCurrentQuestionAnswered() ? _nextPage : null,
                          child: SizedBox(
                            width: 43,
                            height: 43,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: _isCurrentQuestionAnswered()
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.4),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackedCardsForQuestion7(QuestionData question) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final maxWidth = constraints.maxWidth;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            ...List.generate(
              (_totalQuestions - _currentPage - 1).clamp(0, 3),
              (index) {
                final cardIndex = index + 1;
                final offsetY = (cardIndex - 1) * 30.0; 
                final offsetX = cardIndex * 8.0;

                return Positioned(
                  bottom: offsetY,
                  left: offsetX,
                  right: offsetX,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(cardIndex==1? 24 : 30),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent, 
                          Colors.black.withOpacity(0.20 - (cardIndex * 0.03)),
                        ],
                        stops: const [0.0, 0.5], 
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.12 - (cardIndex * 0.02)),
                          offset: const Offset(1, 1), 
                          blurRadius: 0.5,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).reversed,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: maxHeight - 15,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.08),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(_getCardPadding(maxWidth)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QUESTION: ${question.questionNumber}',
                          style: TextStyle(
                            fontSize: _getQuestionLabelSize(maxWidth),
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: _getQuestionLabelSpacing(maxWidth)),
                        Text(
                          question.title,
                          style: TextStyle(
                            fontSize: _getQuestionTitleSize(maxWidth),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: _getQuestionTitleSpacing(maxWidth)),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildQuestion7Option('Find Events', maxWidth),
                              SizedBox(
                                  height: _getQuestion7OptionSpacing(maxWidth)),
                              _buildQuestion7Option('Host Events', maxWidth),
                              SizedBox(
                                  height: _getQuestion7OptionSpacing(maxWidth)),
                              _buildQuestion7Option('Both', maxWidth),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _totalQuestions,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                height: _currentPage == dotIndex ? 10 : 8,
                                width: _currentPage == dotIndex ? 10 : 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == dotIndex
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: SelectiveBorderPainter(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.0,
                        borderRadius: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestion7Option(String text, double maxWidth) {
    final isSelected = _selectedAnswers[_currentPage]!.contains(text);

    return GestureDetector(
      onTap: () {
        _toggleSelection(text);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: _getQuestion7OptionPadding(maxWidth),
          horizontal: _getQuestion7OptionPadding(maxWidth) * 1.5,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: _getQuestion7OptionFontSize(maxWidth),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  double _getQuestion7OptionSpacing(double maxWidth) {
    if (maxWidth > 1200) return 16.0;
    if (maxWidth > 800) return 14.0;
    if (maxWidth > 600) return 12.0;
    return 10.0;
  }

  double _getQuestion7OptionPadding(double maxWidth) {
    if (maxWidth > 1200) return 18.0;
    if (maxWidth > 800) return 16.0;
    if (maxWidth > 600) return 14.0;
    return 12.0;
  }

  double _getQuestion7OptionFontSize(double maxWidth) {
    if (maxWidth > 1200) return 18.0;
    if (maxWidth > 800) return 16.0;
    if (maxWidth > 600) return 15.0;
    return 14.0;
  }


  double _getPageIndicatorSize(double maxWidth) {
    if (maxWidth > 1200) return 12.0;
    if (maxWidth > 800) return 10.0;
    return 8.0;
  }
}

class QuestionData {
  final int questionNumber;
  final String title;
  final List<OptionData> options;
  final List<Color> gradientColors;

  QuestionData({
    required this.questionNumber,
    required this.title,
    required this.options,
    required this.gradientColors,
  });
}

class OptionData {
  final IconData icon;
  final String label;

  OptionData({
    required this.icon,
    required this.label,
  });
}

class SelectiveBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final double borderRadius;

  SelectiveBorderPainter({
    required this.color,
    required this.width,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thickPaint = Paint()
      ..color = color
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final thinPaint = Paint()
      ..color = color
      ..strokeWidth = 0.2
      ..style = PaintingStyle.stroke;

    final topPath = Path();
    topPath.moveTo(borderRadius, 0);
    topPath.lineTo(size.width - borderRadius - 5, 0);
    canvas.drawPath(topPath, thickPaint);

    final topLeftCornerPath = Path();
    topLeftCornerPath.moveTo(0, borderRadius);
    topLeftCornerPath.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );
    canvas.drawPath(topLeftCornerPath, thickPaint);

    final leftPath = Path();
    leftPath.moveTo(0, size.height - 25);
    leftPath.lineTo(0, borderRadius);
    canvas.drawPath(leftPath, thickPaint);

    final rightPath = Path();
    rightPath.moveTo(size.width, 20);
    rightPath.lineTo(size.width, size.height - borderRadius);
    canvas.drawPath(rightPath, thinPaint);

    final bottomRightCornerPath = Path();
    bottomRightCornerPath.moveTo(size.width, size.height - borderRadius);
    bottomRightCornerPath.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );
    canvas.drawPath(bottomRightCornerPath, thinPaint);

    final bottomPath = Path();
    bottomPath.moveTo(size.width - borderRadius, size.height);
    bottomPath.lineTo(15, size.height);
    canvas.drawPath(bottomPath, thinPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


