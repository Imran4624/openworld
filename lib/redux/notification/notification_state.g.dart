// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationState> _$notificationStateSerializer =
    new _$NotificationStateSerializer();
Serializer<NotificationUIState> _$notificationUIStateSerializer =
    new _$NotificationUIStateSerializer();

class _$NotificationStateSerializer
    implements StructuredSerializer<NotificationState> {
  @override
  final Iterable<Type> types = const [NotificationState, _$NotificationState];
  @override
  final String wireName = 'NotificationState';

  @override
  Iterable<Object?> serialize(Serializers serializers, NotificationState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'currentFcmToken',
      serializers.serialize(object.currentFcmToken,
          specifiedType: const FullType(String)),
      'map',
      serializers.serialize(object.map,
          specifiedType: const FullType(BuiltMap, const [
            const FullType(String),
            const FullType(NotificationEntity)
          ])),
      'list',
      serializers.serialize(object.list,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'filter',
      serializers.serialize(object.filter,
          specifiedType: const FullType(NotificationFilter)),
    ];
    Object? value;
    value = object.lastDocument;
    if (value != null) {
      result
        ..add('lastDocument')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentSnapshot, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  NotificationState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'currentFcmToken':
          result.currentFcmToken = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'map':
          result.map.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, const [
                const FullType(String),
                const FullType(NotificationEntity)
              ]))!);
          break;
        case 'list':
          result.list.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'lastDocument':
          result.lastDocument = serializers.deserialize(value,
              specifiedType: const FullType(DocumentSnapshot, const [
                const FullType.nullable(Object)
              ])) as DocumentSnapshot<Object?>?;
          break;
        case 'filter':
          result.filter.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationFilter))!
              as NotificationFilter);
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationUIStateSerializer
    implements StructuredSerializer<NotificationUIState> {
  @override
  final Iterable<Type> types = const [
    NotificationUIState,
    _$NotificationUIState
  ];
  @override
  final String wireName = 'NotificationUIState';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, NotificationUIState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'listUIState',
      serializers.serialize(object.listUIState,
          specifiedType: const FullType(ListUIState)),
      'tabIndex',
      serializers.serialize(object.tabIndex,
          specifiedType: const FullType(int)),
    ];
    Object? value;
    value = object.editing;
    if (value != null) {
      result
        ..add('editing')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(NotificationEntity)));
    }
    value = object.selectedId;
    if (value != null) {
      result
        ..add('selectedId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.forceSelected;
    if (value != null) {
      result
        ..add('forceSelected')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  NotificationUIState deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationUIStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'editing':
          result.editing.replace(serializers.deserialize(value,
                  specifiedType: const FullType(NotificationEntity))!
              as NotificationEntity);
          break;
        case 'listUIState':
          result.listUIState.replace(serializers.deserialize(value,
              specifiedType: const FullType(ListUIState))! as ListUIState);
          break;
        case 'selectedId':
          result.selectedId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'forceSelected':
          result.forceSelected = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'tabIndex':
          result.tabIndex = serializers.deserialize(value,
              specifiedType: const FullType(int))! as int;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationState extends NotificationState {
  @override
  final String currentFcmToken;
  @override
  final BuiltMap<String, NotificationEntity> map;
  @override
  final BuiltList<String> list;
  @override
  final DocumentSnapshot<Object?>? lastDocument;
  @override
  final NotificationFilter filter;

  factory _$NotificationState(
          [void Function(NotificationStateBuilder)? updates]) =>
      (new NotificationStateBuilder()..update(updates))._build();

  _$NotificationState._(
      {required this.currentFcmToken,
      required this.map,
      required this.list,
      this.lastDocument,
      required this.filter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        currentFcmToken, r'NotificationState', 'currentFcmToken');
    BuiltValueNullFieldError.checkNotNull(map, r'NotificationState', 'map');
    BuiltValueNullFieldError.checkNotNull(list, r'NotificationState', 'list');
    BuiltValueNullFieldError.checkNotNull(
        filter, r'NotificationState', 'filter');
  }

  @override
  NotificationState rebuild(void Function(NotificationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationStateBuilder toBuilder() =>
      new NotificationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationState &&
        currentFcmToken == other.currentFcmToken &&
        map == other.map &&
        list == other.list &&
        lastDocument == other.lastDocument &&
        filter == other.filter;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, currentFcmToken.hashCode);
    _$hash = $jc(_$hash, map.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jc(_$hash, lastDocument.hashCode);
    _$hash = $jc(_$hash, filter.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationState')
          ..add('currentFcmToken', currentFcmToken)
          ..add('map', map)
          ..add('list', list)
          ..add('lastDocument', lastDocument)
          ..add('filter', filter))
        .toString();
  }
}

class NotificationStateBuilder
    implements Builder<NotificationState, NotificationStateBuilder> {
  _$NotificationState? _$v;

  String? _currentFcmToken;
  String? get currentFcmToken => _$this._currentFcmToken;
  set currentFcmToken(String? currentFcmToken) =>
      _$this._currentFcmToken = currentFcmToken;

  MapBuilder<String, NotificationEntity>? _map;
  MapBuilder<String, NotificationEntity> get map =>
      _$this._map ??= new MapBuilder<String, NotificationEntity>();
  set map(MapBuilder<String, NotificationEntity>? map) => _$this._map = map;

  ListBuilder<String>? _list;
  ListBuilder<String> get list => _$this._list ??= new ListBuilder<String>();
  set list(ListBuilder<String>? list) => _$this._list = list;

  DocumentSnapshot<Object?>? _lastDocument;
  DocumentSnapshot<Object?>? get lastDocument => _$this._lastDocument;
  set lastDocument(DocumentSnapshot<Object?>? lastDocument) =>
      _$this._lastDocument = lastDocument;

  NotificationFilterBuilder? _filter;
  NotificationFilterBuilder get filter =>
      _$this._filter ??= new NotificationFilterBuilder();
  set filter(NotificationFilterBuilder? filter) => _$this._filter = filter;

  NotificationStateBuilder();

  NotificationStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currentFcmToken = $v.currentFcmToken;
      _map = $v.map.toBuilder();
      _list = $v.list.toBuilder();
      _lastDocument = $v.lastDocument;
      _filter = $v.filter.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationState;
  }

  @override
  void update(void Function(NotificationStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationState build() => _build();

  _$NotificationState _build() {
    _$NotificationState _$result;
    try {
      _$result = _$v ??
          new _$NotificationState._(
              currentFcmToken: BuiltValueNullFieldError.checkNotNull(
                  currentFcmToken, r'NotificationState', 'currentFcmToken'),
              map: map.build(),
              list: list.build(),
              lastDocument: lastDocument,
              filter: filter.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'map';
        map.build();
        _$failedField = 'list';
        list.build();

        _$failedField = 'filter';
        filter.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$NotificationUIState extends NotificationUIState {
  @override
  final NotificationEntity? editing;
  @override
  final ListUIState listUIState;
  @override
  final String? selectedId;
  @override
  final bool? forceSelected;
  @override
  final int tabIndex;
  @override
  final Completer<SelectableEntity>? saveCompleter;
  @override
  final Completer<Null>? cancelCompleter;

  factory _$NotificationUIState(
          [void Function(NotificationUIStateBuilder)? updates]) =>
      (new NotificationUIStateBuilder()..update(updates))._build();

  _$NotificationUIState._(
      {this.editing,
      required this.listUIState,
      this.selectedId,
      this.forceSelected,
      required this.tabIndex,
      this.saveCompleter,
      this.cancelCompleter})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        listUIState, r'NotificationUIState', 'listUIState');
    BuiltValueNullFieldError.checkNotNull(
        tabIndex, r'NotificationUIState', 'tabIndex');
  }

  @override
  NotificationUIState rebuild(
          void Function(NotificationUIStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationUIStateBuilder toBuilder() =>
      new NotificationUIStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationUIState &&
        editing == other.editing &&
        listUIState == other.listUIState &&
        selectedId == other.selectedId &&
        forceSelected == other.forceSelected &&
        tabIndex == other.tabIndex &&
        saveCompleter == other.saveCompleter &&
        cancelCompleter == other.cancelCompleter;
  }

  int? __hashCode;
  @override
  int get hashCode {
    if (__hashCode != null) return __hashCode!;
    var _$hash = 0;
    _$hash = $jc(_$hash, editing.hashCode);
    _$hash = $jc(_$hash, listUIState.hashCode);
    _$hash = $jc(_$hash, selectedId.hashCode);
    _$hash = $jc(_$hash, forceSelected.hashCode);
    _$hash = $jc(_$hash, tabIndex.hashCode);
    _$hash = $jc(_$hash, saveCompleter.hashCode);
    _$hash = $jc(_$hash, cancelCompleter.hashCode);
    _$hash = $jf(_$hash);
    return __hashCode ??= _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationUIState')
          ..add('editing', editing)
          ..add('listUIState', listUIState)
          ..add('selectedId', selectedId)
          ..add('forceSelected', forceSelected)
          ..add('tabIndex', tabIndex)
          ..add('saveCompleter', saveCompleter)
          ..add('cancelCompleter', cancelCompleter))
        .toString();
  }
}

class NotificationUIStateBuilder
    implements Builder<NotificationUIState, NotificationUIStateBuilder> {
  _$NotificationUIState? _$v;

  NotificationEntityBuilder? _editing;
  NotificationEntityBuilder get editing =>
      _$this._editing ??= new NotificationEntityBuilder();
  set editing(NotificationEntityBuilder? editing) => _$this._editing = editing;

  ListUIStateBuilder? _listUIState;
  ListUIStateBuilder get listUIState =>
      _$this._listUIState ??= new ListUIStateBuilder();
  set listUIState(ListUIStateBuilder? listUIState) =>
      _$this._listUIState = listUIState;

  String? _selectedId;
  String? get selectedId => _$this._selectedId;
  set selectedId(String? selectedId) => _$this._selectedId = selectedId;

  bool? _forceSelected;
  bool? get forceSelected => _$this._forceSelected;
  set forceSelected(bool? forceSelected) =>
      _$this._forceSelected = forceSelected;

  int? _tabIndex;
  int? get tabIndex => _$this._tabIndex;
  set tabIndex(int? tabIndex) => _$this._tabIndex = tabIndex;

  Completer<SelectableEntity>? _saveCompleter;
  Completer<SelectableEntity>? get saveCompleter => _$this._saveCompleter;
  set saveCompleter(Completer<SelectableEntity>? saveCompleter) =>
      _$this._saveCompleter = saveCompleter;

  Completer<Null>? _cancelCompleter;
  Completer<Null>? get cancelCompleter => _$this._cancelCompleter;
  set cancelCompleter(Completer<Null>? cancelCompleter) =>
      _$this._cancelCompleter = cancelCompleter;

  NotificationUIStateBuilder();

  NotificationUIStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _editing = $v.editing?.toBuilder();
      _listUIState = $v.listUIState.toBuilder();
      _selectedId = $v.selectedId;
      _forceSelected = $v.forceSelected;
      _tabIndex = $v.tabIndex;
      _saveCompleter = $v.saveCompleter;
      _cancelCompleter = $v.cancelCompleter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationUIState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$NotificationUIState;
  }

  @override
  void update(void Function(NotificationUIStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationUIState build() => _build();

  _$NotificationUIState _build() {
    _$NotificationUIState _$result;
    try {
      _$result = _$v ??
          new _$NotificationUIState._(
              editing: _editing?.build(),
              listUIState: listUIState.build(),
              selectedId: selectedId,
              forceSelected: forceSelected,
              tabIndex: BuiltValueNullFieldError.checkNotNull(
                  tabIndex, r'NotificationUIState', 'tabIndex'),
              saveCompleter: saveCompleter,
              cancelCompleter: cancelCompleter);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'editing';
        _editing?.build();
        _$failedField = 'listUIState';
        listUIState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'NotificationUIState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
