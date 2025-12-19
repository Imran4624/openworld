// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_field_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DynamicFieldState> _$dynamicFieldStateSerializer =
    new _$DynamicFieldStateSerializer();

class _$DynamicFieldStateSerializer
    implements StructuredSerializer<DynamicFieldState> {
  @override
  final Iterable<Type> types = const [DynamicFieldState, _$DynamicFieldState];
  @override
  final String wireName = 'DynamicFieldState';

  @override
  Iterable<Object?> serialize(Serializers serializers, DynamicFieldState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'questionGroups',
      serializers.serialize(object.questionGroups,
          specifiedType: const FullType(
              BuiltList, const [const FullType(QuestionGroupModel)])),
      'answers',
      serializers.serialize(object.answers,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(BuiltMap,
                const [const FullType(String), const FullType(dynamic)])
          ])),
      'savedAnswers',
      serializers.serialize(object.savedAnswers,
          specifiedType: const FullType(
              Map, const [const FullType(String), const FullType(dynamic)])),
      'currentGroupIndex',
      serializers.serialize(object.currentGroupIndex,
          specifiedType: const FullType(int)),
      'currentQuestionIndex',
      serializers.serialize(object.currentQuestionIndex,
          specifiedType: const FullType(int)),
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
      'inputFieldControllers',
      serializers.serialize(object.inputFieldControllers,
          specifiedType: const FullType(
              Map, const [const FullType(String), const FullType(dynamic)])),
      'questionGroupType',
      serializers.serialize(object.questionGroupType,
          specifiedType: const FullType(QuestionType)),
      'selectedTabIndex',
      serializers.serialize(object.selectedTabIndex,
          specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  DynamicFieldState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DynamicFieldStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'questionGroups':
          result.questionGroups.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(QuestionGroupModel)]))!
              as BuiltList<Object?>);
          break;
        case 'answers':
          result.answers.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(BuiltMap,
                    const [const FullType(String), const FullType(dynamic)])
              ]))!);
          break;
        case 'savedAnswers':
          result.savedAnswers = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ]))! as Map<String, dynamic>;
          break;
        case 'currentGroupIndex':
          result.currentGroupIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'currentQuestionIndex':
          result.currentQuestionIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool))! as bool;
          break;
        case 'inputFieldControllers':
          result.inputFieldControllers = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(dynamic)
              ]))! as Map<String, dynamic>;
          break;
        case 'questionGroupType':
          result.questionGroupType = serializers.deserialize(value,
              specifiedType: const FullType(QuestionType))! as QuestionType;
          break;
        case 'selectedTabIndex':
          result.selectedTabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$DynamicFieldState extends DynamicFieldState {
  @override
  final BuiltList<QuestionGroupModel> questionGroups;
  @override
  final BuiltMap<String, BuiltMap<String, dynamic>> answers;
  @override
  final Map<String, dynamic> savedAnswers;
  @override
  final int currentGroupIndex;
  @override
  final int currentQuestionIndex;
  @override
  final bool isLoading;
  @override
  final Map<String, dynamic> inputFieldControllers;
  @override
  final QuestionType questionGroupType;
  @override
  final int selectedTabIndex;

  factory _$DynamicFieldState(
          [void Function(DynamicFieldStateBuilder)? updates]) =>
      (new DynamicFieldStateBuilder()..update(updates))._build();

  _$DynamicFieldState._(
      {required this.questionGroups,
      required this.answers,
      required this.savedAnswers,
      required this.currentGroupIndex,
      required this.currentQuestionIndex,
      required this.isLoading,
      required this.inputFieldControllers,
      required this.questionGroupType,
      required this.selectedTabIndex})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        questionGroups, r'DynamicFieldState', 'questionGroups');
    BuiltValueNullFieldError.checkNotNull(
        answers, r'DynamicFieldState', 'answers');
    BuiltValueNullFieldError.checkNotNull(
        savedAnswers, r'DynamicFieldState', 'savedAnswers');
    BuiltValueNullFieldError.checkNotNull(
        currentGroupIndex, r'DynamicFieldState', 'currentGroupIndex');
    BuiltValueNullFieldError.checkNotNull(
        currentQuestionIndex, r'DynamicFieldState', 'currentQuestionIndex');
    BuiltValueNullFieldError.checkNotNull(
        isLoading, r'DynamicFieldState', 'isLoading');
    BuiltValueNullFieldError.checkNotNull(
        inputFieldControllers, r'DynamicFieldState', 'inputFieldControllers');
    BuiltValueNullFieldError.checkNotNull(
        questionGroupType, r'DynamicFieldState', 'questionGroupType');
    BuiltValueNullFieldError.checkNotNull(
        selectedTabIndex, r'DynamicFieldState', 'selectedTabIndex');
  }

  @override
  DynamicFieldState rebuild(void Function(DynamicFieldStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DynamicFieldStateBuilder toBuilder() =>
      new DynamicFieldStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DynamicFieldState &&
        questionGroups == other.questionGroups &&
        answers == other.answers &&
        savedAnswers == other.savedAnswers &&
        currentGroupIndex == other.currentGroupIndex &&
        currentQuestionIndex == other.currentQuestionIndex &&
        isLoading == other.isLoading &&
        inputFieldControllers == other.inputFieldControllers &&
        questionGroupType == other.questionGroupType &&
        selectedTabIndex == other.selectedTabIndex;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, questionGroups.hashCode);
    _$hash = $jc(_$hash, answers.hashCode);
    _$hash = $jc(_$hash, savedAnswers.hashCode);
    _$hash = $jc(_$hash, currentGroupIndex.hashCode);
    _$hash = $jc(_$hash, currentQuestionIndex.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, inputFieldControllers.hashCode);
    _$hash = $jc(_$hash, questionGroupType.hashCode);
    _$hash = $jc(_$hash, selectedTabIndex.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DynamicFieldState')
          ..add('questionGroups', questionGroups)
          ..add('answers', answers)
          ..add('savedAnswers', savedAnswers)
          ..add('currentGroupIndex', currentGroupIndex)
          ..add('currentQuestionIndex', currentQuestionIndex)
          ..add('isLoading', isLoading)
          ..add('inputFieldControllers', inputFieldControllers)
          ..add('questionGroupType', questionGroupType)
          ..add('selectedTabIndex', selectedTabIndex))
        .toString();
  }
}

class DynamicFieldStateBuilder
    implements Builder<DynamicFieldState, DynamicFieldStateBuilder> {
  _$DynamicFieldState? _$v;

  ListBuilder<QuestionGroupModel>? _questionGroups;
  ListBuilder<QuestionGroupModel> get questionGroups =>
      _$this._questionGroups ??= new ListBuilder<QuestionGroupModel>();
  set questionGroups(ListBuilder<QuestionGroupModel>? questionGroups) =>
      _$this._questionGroups = questionGroups;

  MapBuilder<String, BuiltMap<String, dynamic>>? _answers;
  MapBuilder<String, BuiltMap<String, dynamic>> get answers =>
      _$this._answers ??= new MapBuilder<String, BuiltMap<String, dynamic>>();
  set answers(MapBuilder<String, BuiltMap<String, dynamic>>? answers) =>
      _$this._answers = answers;

  Map<String, dynamic>? _savedAnswers;
  Map<String, dynamic>? get savedAnswers => _$this._savedAnswers;
  set savedAnswers(Map<String, dynamic>? savedAnswers) =>
      _$this._savedAnswers = savedAnswers;

  int? _currentGroupIndex;
  int? get currentGroupIndex => _$this._currentGroupIndex;
  set currentGroupIndex(int? currentGroupIndex) =>
      _$this._currentGroupIndex = currentGroupIndex;

  int? _currentQuestionIndex;
  int? get currentQuestionIndex => _$this._currentQuestionIndex;
  set currentQuestionIndex(int? currentQuestionIndex) =>
      _$this._currentQuestionIndex = currentQuestionIndex;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  Map<String, dynamic>? _inputFieldControllers;
  Map<String, dynamic>? get inputFieldControllers =>
      _$this._inputFieldControllers;
  set inputFieldControllers(Map<String, dynamic>? inputFieldControllers) =>
      _$this._inputFieldControllers = inputFieldControllers;

  QuestionType? _questionGroupType;
  QuestionType? get questionGroupType => _$this._questionGroupType;
  set questionGroupType(QuestionType? questionGroupType) =>
      _$this._questionGroupType = questionGroupType;

  int? _selectedTabIndex;
  int? get selectedTabIndex => _$this._selectedTabIndex;
  set selectedTabIndex(int? selectedTabIndex) =>
      _$this._selectedTabIndex = selectedTabIndex;

  DynamicFieldStateBuilder();

  DynamicFieldStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _questionGroups = $v.questionGroups.toBuilder();
      _answers = $v.answers.toBuilder();
      _savedAnswers = $v.savedAnswers;
      _currentGroupIndex = $v.currentGroupIndex;
      _currentQuestionIndex = $v.currentQuestionIndex;
      _isLoading = $v.isLoading;
      _inputFieldControllers = $v.inputFieldControllers;
      _questionGroupType = $v.questionGroupType;
      _selectedTabIndex = $v.selectedTabIndex;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DynamicFieldState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DynamicFieldState;
  }

  @override
  void update(void Function(DynamicFieldStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DynamicFieldState build() => _build();

  _$DynamicFieldState _build() {
    _$DynamicFieldState _$result;
    try {
      _$result = _$v ??
          new _$DynamicFieldState._(
              questionGroups: questionGroups.build(),
              answers: answers.build(),
              savedAnswers: BuiltValueNullFieldError.checkNotNull(
                  savedAnswers, r'DynamicFieldState', 'savedAnswers'),
              currentGroupIndex: BuiltValueNullFieldError.checkNotNull(
                  currentGroupIndex, r'DynamicFieldState', 'currentGroupIndex'),
              currentQuestionIndex: BuiltValueNullFieldError.checkNotNull(
                  currentQuestionIndex, r'DynamicFieldState', 'currentQuestionIndex'),
              isLoading: BuiltValueNullFieldError.checkNotNull(
                  isLoading, r'DynamicFieldState', 'isLoading'),
              inputFieldControllers: BuiltValueNullFieldError.checkNotNull(
                  inputFieldControllers,
                  r'DynamicFieldState',
                  'inputFieldControllers'),
              questionGroupType: BuiltValueNullFieldError.checkNotNull(
                  questionGroupType, r'DynamicFieldState', 'questionGroupType'),
              selectedTabIndex: BuiltValueNullFieldError.checkNotNull(
                  selectedTabIndex, r'DynamicFieldState', 'selectedTabIndex'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'questionGroups';
        questionGroups.build();
        _$failedField = 'answers';
        answers.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'DynamicFieldState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
